// ignore_for_file: strict_raw_type

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @singleton
  DeviceInfoPlugin get deviceInfoPlugin => DeviceInfoPlugin();

  @Named('isPhysicalDevice')
  @preResolve
  Future<bool> isPhysicalDevice(DeviceInfoPlugin deviceInfo) async {
    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      return android.isPhysicalDevice;
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      return ios.isPhysicalDevice;
    }

    return true;
  }
}
