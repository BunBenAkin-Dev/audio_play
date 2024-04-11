import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> permit() async {
  try {
    final bool istorage = await Permission.storage.isGranted;
    final bool isexternal = await Permission.manageExternalStorage.isGranted;

    if (!istorage || !isexternal) {
      final Map<Permission, PermissionStatus> statue = await [
        Permission.storage,
        Permission.manageExternalStorage,
      ].request();

      if (statue[Permission.storage] == PermissionStatus.denied ||
          statue[Permission.manageExternalStorage] == PermissionStatus.denied) {
        await openAppSettings();
      }
    }
  } catch (e) {
    debugPrint('errror: ${'check error'}');
  }
}
