import 'package:audio_play/service/audiohandler.dart';
import 'package:audio_play/service/songquestor.dart';
import 'package:audio_play/ui/component/listidata.dart';
import 'package:audio_play/ui/component/playerdeck.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({required this.handle, super.key});

  final MyAudioHandler handle;

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  final AutoScrollController _autoscrollcontroller = AutoScrollController();

  void autoscroll(int index) {
    _autoscrollcontroller.scrollToIndex(index,
        preferPosition: AutoScrollPosition.middle,
        duration: const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            StreamBuilder<bool>(
                stream: widget.handle.playbackState
                    .map((event) => event.playing)
                    .distinct(),
                builder: (ctx, snapshot) {
                  final playing = snapshot.data ?? false;
                  return playing
                      ? IconButton(
                          onPressed: widget.handle.pause,
                          icon: const Icon(Icons.pause))
                      : IconButton(
                          onPressed: widget.handle.play,
                          icon: const Icon(Icons.play_arrow));
                }),
            SizedBox(
              width: 20,
            ),
            SizedBox(
              child: StreamBuilder<MediaItem?>(
                  stream: widget.handle.mediaItem.stream,
                  builder: (ctx, snapshot) {
                    final mediaItem = snapshot.data;
                    return Text(mediaItem?.artist ?? 'artiste');
                  }),
            )
          ],
        ),
        body: OrientationBuilder(builder: (ctx, orientation) {
          return SafeArea(
              child: Column(
            children: [
              Expanded(
                child: FutureBuilder<List<MediaItem>>(
                    future: fetchMediaitem(),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        var songdata = snapshot.data!;
                        return Listsong(
                          handle: widget.handle,
                          songdata: songdata,
                          autoscrolly: _autoscrollcontroller,
                        );
                      } else {
                        return const Center(
                          child: Text('You Have bad Taste'),
                        );
                      }
                    }),
              ),
              Playerdeck(
                handle: widget.handle,
              ),
            ],
          ));
        }));
  }
}
