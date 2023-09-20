part of '../unlockd_bluetooth.dart';

sealed class UnlockdBluetooth {
  UnlockdBluetooth._();

  static Stream<UnlockdBluetoothAdapterState> adapterState({
    required IsEmulator isEmulator,
  }) =>
      isEmulator ? EmulatorBluePlus.adapterState : FlutterBluePlus.adapterState;

  static bool get isScanningNow => FlutterBluePlus.isScanningNow;

  static Stream<bool> get isScanning => FlutterBluePlus.isScanning;

  static Future<ConnectedBluetoothDevices> get connectedSystemDevices =>
      FlutterBluePlus.connectedSystemDevices;

  static TurnOn get turnOn => FlutterBluePlus.turnOn;

  static StartScan get startScan => FlutterBluePlus.startScan;

  static StopScan get stopScan => FlutterBluePlus.stopScan;

  static Stream<ScanResults> get scanResults =>
      FlutterBluePlus.scanResults;
}
