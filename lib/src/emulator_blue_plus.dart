import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:unlockd_bluetooth/unlockd_bluetooth.dart';

class EmulatorBluePlus {
  EmulatorBluePlus._();

  static Stream<UnlockdBluetoothAdapterState> get adapterState =>
      watchConfig()
      .asyncMap(
        (event) => readBluetoothState()
            .map((r) => r.adapterState)
            .getOrElse(() => UnlockdBluetoothAdapterState.unknown)
            .run(),
      );

  static Future<bool> get isScanningNow async => readBluetoothState()
      .map((r) => r.isScanning)
      .getOrElse(() => false)
      .run();

  static Stream<bool> get isScanning => watchConfig().asyncMap(
        (event) => readBluetoothState()
            .map((r) => r.isScanning)
            .getOrElse(() => false)
            .run(),
      );

  static Future<ConnectedBluetoothDevices> get connectedSystemDevices =>
      readBluetoothState()
          .map((r) => r.connectedDevices)
          .getOrElse(() => const ConnectedBluetoothDevices.empty())
          .run();

  static TurnOn get turnOn => FlutterBluePlus.turnOn;

  static StartScan get startScan => FlutterBluePlus.startScan;

  static StopScan get stopScan => FlutterBluePlus.stopScan;

  static Stream<ScanResults> get scanResults => FlutterBluePlus.scanResults;
}
