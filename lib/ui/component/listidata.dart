import 'package:audio_play/service/audiohandler.dart';
import 'package:audio_play/ui/component/listitem.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class Listsong extends StatelessWidget {
  const Listsong({
    required this.handle,
    required this.songdata,
    required this.autoscrolly,
    super.key,
  });

  final MyAudioHandler handle;
  final List<MediaItem> songdata;
  final AutoScrollController autoscrolly;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: songdata.length,
        itemBuilder: (ctx, index) {
          MediaItem song = songdata[index];

          return StreamBuilder<MediaItem?>(
              stream: handle.mediaItem.stream,
              builder: (ctx, snapshot) {
                MediaItem? Playingsong = snapshot.data;

                return index == (songdata.length - 1)
                    ? _buildlastitem(song, Playingsong)
                    : AutoScrollTag(
                        key: ValueKey(index),
                        controller: autoscrolly,
                        index: index,
                        child: _buildnormalitem(song, Playingsong),
                      );
              });
        });
  }

  Widget _buildlastitem(MediaItem song, MediaItem? playingsong) {
    return Column(
      children: [
        Musicitemcard(
          title: song.title,
          artiste: song.title,
          artd: song.artUri,
          isplaying: song == playingsong,
          ontap: () {
            handle.skipToQueueItem(songdata.length - 1);
          },
        )
      ],
    );
  }

  Widget _buildnormalitem(MediaItem song, MediaItem? playingsong) {
    return Musicitemcard(
      title: song.title,
      artiste: song.artist ?? '',
      artd: song.artUri,
      isplaying: song == playingsong,
      ontap: () {
        handle.skipToQueueItem(songdata.indexOf(song));
      },
    );
  }
}
