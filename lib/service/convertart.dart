import 'dart:io';
import 'dart:typed_data';

import 'package:on_audio_query/on_audio_query.dart';

Future<Uri?> convertalbum({
  required int id,
  required ArtworkType type,
  required int quality,
  required int size,
}) async {
  try {
    final OnAudioQuery audioquery = OnAudioQuery();

    final Uint8List? data = await audioquery.queryArtwork(
      id,
      type,
      size: size,
      quality: quality,
    );

    Uri? art;

    if (data != null) {
      Directory tempdir = Directory.systemTemp;
      File file = File('${tempdir.path}/$id.jpg');

      await file.writeAsBytes(data);

      art = file.uri;
    }
    return art;
  } catch (e) {
    return null;
  }
}
