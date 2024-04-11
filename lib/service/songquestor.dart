import 'package:audio_play/service/audiohandler.dart';
import 'package:audio_play/service/convertart.dart';
import 'package:audio_play/service/permsisson.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

Future<List<SongModel>> fetchsongs() async {
  try {
    await permit();
    OnAudioQuery audioquery = OnAudioQuery();
    final List<SongModel> fetch = await audioquery.querySongs();

    return fetch;
  } catch (e) {
    return [];
  }
}

Future<List<MediaItem>> fetchMediaitem() async {
  try {
    final songm = await fetchsongs();

    final List<MediaItem> mediaitemdata = [];

    for (var songmodel in songm) {
      final Uri? art = await convertalbum(
          id: songmodel.id, type: ArtworkType.AUDIO, quality: 100, size: 300);
      final data = MediaItem(
        id: songmodel.uri ?? '',
        title: songmodel.title,
        artist: songmodel.artist,
        duration: Duration(milliseconds: songmodel.duration ?? 0),
        artUri: art,
      );

      mediaitemdata.add(data);
    }
    debugPrint('total songs available:  ${mediaitemdata.length}');

    return mediaitemdata;
  } catch (e) {
    return [];
  }
}

// Future<void> fetchforinit() async {
//   try {
//     final aol = await fetchMediaitem();

//     final audiohandle = await MyAudioHandler();

//     final boom = audiohandle.initst(songs: aol);
//     return boom;
//   } catch (e) {
//     debugPrint('error with fetchforinit');
//   }
// }
