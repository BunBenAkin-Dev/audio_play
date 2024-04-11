import 'package:audio_play/service/audiohandler.dart';
import 'package:audio_play/service/songquestor.dart';
import 'package:audio_play/ui/screen/homescreen.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

final kcolorscheme = ColorScheme.fromSeed(seedColor: Colors.cyan);
MyAudioHandler _audioHandler = MyAudioHandler();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.audio_play.app',
      androidNotificationChannelName: 'Music playback',
    ),
  );

  final layuplist = await fetchMediaitem();

  await _audioHandler.initst(songs: layuplist);
  // MyAudioHandler handle = MyAudioHandler();
  runApp(MaterialApp(
    theme: ThemeData().copyWith(
        colorScheme: kcolorscheme,
        cardTheme:
            ThemeData().cardTheme.copyWith(color: kcolorscheme.onPrimary)),
    home: MyHomeScreen(handle: _audioHandler),
  ));
}
