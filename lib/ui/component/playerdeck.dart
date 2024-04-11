import 'package:audio_play/service/audiohandler.dart';
import 'package:audio_play/service/filetouri.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:transparent_image/transparent_image.dart';

class Playerdeck extends StatelessWidget {
  const Playerdeck({required this.handle, super.key});

  final MyAudioHandler handle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: StreamBuilder<MediaItem?>(
          stream: handle.mediaItem.stream,
          builder: (ctx, snapshot) {
            MediaItem? playingsong = snapshot.data;

            // ignore: unnecessary_null_comparison

            return playingsong == null
                ? const SizedBox.shrink()
                : _mainplayerlayup(context, playingsong);
          }),
    );
  }

  Widget _playerlayup(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          ClipRRect(
            child: Center(
              child: Icon(Icons.music_note),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text('Not Playing')
        ],
      ),
    );
  }

  Widget _mainplayerlayup(BuildContext context, MediaItem playingsong) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: FutureBuilder(
                  future: filetouri(playingsong.artUri),
                  builder: (ctx, snapshot) {
                    final pls = snapshot.data;

                    return pls == null
                        ? const Icon(Icons.music_note)
                        : FadeInImage(
                            placeholder: MemoryImage(kTransparentImage),
                            image: FileImage(pls));
                  })),
          // QueryArtworkWidget(
          //   id: int.parse(playingsong.displayDescription ?? '0'),
          //   type: ArtworkType.AUDIO,
          //   size: 45,
          //   quality: 300,
          // )),
          const SizedBox(
            width: 20,
          ),
          Text(
            playingsong.title,
          ),
          const SizedBox(
            width: 50,
          ),
          _duration(context, playingsong)
        ],
      ),
    );
  }

  Widget _duration(BuildContext context, MediaItem Playingsong) {
    return Stack(
      children: [
        StreamBuilder(
            stream: AudioService.position,
            builder: (context, snapshot) {
              var daz = snapshot.data!.inMilliseconds /
                  Playingsong.duration!.inMilliseconds;

              return Center(
                child: CircularProgressIndicator(
                  value: daz,
                ),
              );
            }),
        Center(
          child: Icon(
            Icons.play_arrow,
            size: 30,
          ),
        )
      ],
    );
  }
}
