import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:unlockd_bluetooth/unlockd_bluetooth.dart';

sealed class UnlockdBluetooth {
  UnlockdBluetooth._();

  static Stream<UnlockdBluetoothAdapterState> adapterState({
    required IsEmulator isEmulator,
  }) =>
      isEmulator ? EmulatorBluePlus.adapterState : FlutterBluePlus.adapterState;

  static FutureOr<bool> isScanningNow({
    required IsEmulator isEmulator,
  }) async =>
      isEmulator
          ? await EmulatorBluePlus.isScanningNow
          : FlutterBluePlus.isScanningNow;

  static Stream<bool> isScanning({
    required IsEmulator isEmulator,
  }) =>
      isEmulator ? EmulatorBluePlus.isScanning : FlutterBluePlus.isScanning;

  static Future<ConnectedBluetoothDevices> connectedSystemDevices({
    required IsEmulator isEmulator,
  }) =>
      isEmulator
          ? EmulatorBluePlus.connectedSystemDevices
          : FlutterBluePlus.connectedSystemDevices
              .then(ConnectedBluetoothDevices.fromList);

  static TurnOn get turnOn => FlutterBluePlus.turnOn;

  static StartScan get startScan => FlutterBluePlus.startScan;

  static StopScan get stopScan => FlutterBluePlus.stopScan;

  static Stream<ScanResults> get scanResults => FlutterBluePlus.scanResults;
}
