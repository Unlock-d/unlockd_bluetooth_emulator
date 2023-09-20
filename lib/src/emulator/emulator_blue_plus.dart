import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:unlockd_bluetooth/unlockd_bluetooth.dart';

class EmulatorBluePlus {
  EmulatorBluePlus._();

  static Stream<UnlockdBluetoothAdapterState> get adapterState =>
      watchConfig().asyncMap(
        (event) => readBluetoothState()
            .swap()
            .map(logException)
            .swap()
            .map((r) => r.adapterState)
            .getOrElse((l) => UnlockdBluetoothAdapterState.unknown)
            .run(),
      );

  static bool get isScanningNow => FlutterBluePlus.isScanningNow;

  static Stream<bool> get isScanning => FlutterBluePlus.isScanning;

  static Future<ConnectedBluetoothDevices> get connectedSystemDevices =>
      readBluetoothState()
          .swap()
          .map(logException)
          .swap()
          .map((r) => r.connectedDevices)
          .getOrElse((l) => const ConnectedBluetoothDevices.empty())
          .run();

  static TurnOn get turnOn => FlutterBluePlus.turnOn;

  static StartScan get startScan => FlutterBluePlus.startScan;

  static StopScan get stopScan => FlutterBluePlus.stopScan;

  static Stream<ScanResults> get scanResults => FlutterBluePlus.scanResults;
}
