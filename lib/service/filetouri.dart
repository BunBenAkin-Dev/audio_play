import 'dart:io';

Future<File?> filetouri(Uri? uri) async {
  if (uri == null) {
    return null;
  }

  try {
    return File.fromUri(uri);
  } catch (e) {
    return null;
  }
}
