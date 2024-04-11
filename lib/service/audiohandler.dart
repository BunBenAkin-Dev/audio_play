import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler with SeekHandler, QueueHandler {
  final audioplayer = AudioPlayer();

  UriAudioSource getauisource(MediaItem item) {
    return ProgressiveAudioSource(Uri.parse(item.id));
  }

  void currentaudioindex() {
    audioplayer.currentIndexStream.listen((event) {
      final playslist = queue.value;
      if (playslist.isEmpty || event == null) return;
      mediaItem.add(playslist[event]);
    });
  }

  void _broadcaststate(PlaybackEvent event) {
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.rewind,
        if (audioplayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[audioplayer.processingState]!,
      playing: audioplayer.playing,
      updatePosition: audioplayer.position,
      bufferedPosition: audioplayer.bufferedPosition,
      speed: audioplayer.speed,
      queueIndex: event.currentIndex,
    ));
  }

  Future<void> initst({required List<MediaItem> songs}) async {
    audioplayer.playbackEventStream.listen(_broadcaststate);

    final audiosource = songs.map(getauisource).toList();

    await audioplayer.setAudioSource(ConcatenatingAudioSource(
        children: audiosource, shuffleOrder: DefaultShuffleOrder()));

    queue.value.clear();
    queue.value.addAll(songs);
    queue.add(queue.value);

    currentaudioindex();

    audioplayer.processingStateStream.listen((event) {
      if (event == ProcessingState.completed) skipToNext();
    });
  }

  @override
  Future<void> play() => audioplayer.play();
  @override
  Future<void> pause() => audioplayer.pause();
  @override
  Future<void> skipToNext() => audioplayer.seekToNext();
  @override
  Future<void> skipToPrevious() => audioplayer.seekToPrevious();
  @override
  Future<void> seek(Duration position) => audioplayer.seek(position);
  @override
  Future<void> skipToQueueItem(int index) async {
    await audioplayer.seek(Duration.zero, index: index);
    play();
  }
}
