import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestPermissions() async {
    if (!Platform.isAndroid) return true;

    Map<Permission, PermissionStatus> status = await [
      Permission.location,
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.nearbyWifiDevices,
    ].request();

    return status.values.every((e) => e.isGranted);
  }

  Future<bool> hasPermissions() async {
    if (!Platform.isAndroid) return true;

    return await Permission.location.isGranted &&
        await Permission.bluetoothScan.isGranted &&
        await Permission.bluetoothConnect.isGranted &&
        await Permission.bluetoothAdvertise.isGranted;
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }
}
