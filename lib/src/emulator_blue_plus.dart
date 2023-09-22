import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:unlockd_bluetooth/unlockd_bluetooth.dart';

class EmulatorBluePlus {
  EmulatorBluePlus._();

  static Stream<UnlockdBluetoothAdapterState> get adapterState => watchConfig()
      .asyncMap(
        (event) => readBluetoothState()
            .map((r) => r.adapterState)
            .getOrElse(() => UnlockdBluetoothAdapterState.unknown)
            .run(),
      )
      .handleError((e, s) => print(e));

  static Future<bool> get isScanningNow async => readBluetoothState()
      .map((r) => r.isScanning)
      .getOrElse(() => false)
      .run();

  static Stream<bool> get isScanning => watchConfig()
      .asyncMap(
        (event) => readBluetoothState()
            .map((r) => r.isScanning)
            .getOrElse(() => false)
            .run(),
      )
      .handleError((e, s) => print(e));

  static Future<ConnectedBluetoothDevices> get connectedSystemDevices =>
      readBluetoothState()
          .map((r) => r.connectedDevices)
          .getOrElse(() => const [])
          .run();

  static TurnOn get turnOn => ({int timeout = 0}) => readBluetoothState()
      .map(turnOnBluetooth)
      .chainTask(writeBluetoothState)
      .delay(Duration(seconds: timeout))
      .run();

  static StartScan get startScan => ({
        List<Guid> withServices = const [],
        Duration? timeout,
        Duration? removeIfGone,
        bool oneByOne = false,
        bool androidUsesFineLocation = false,
      }) =>
          readBluetoothState()
              .filter((state) => !state.isScanning)
              .map(startScanning)
              .chainTask(writeBluetoothState)
              .delay(timeout ?? Duration.zero)
              .run();

  static StopScan get stopScan => () => readBluetoothState()
      .filter((state) => state.isScanning)
      .map(stopScanning)
      .chainTask(writeBluetoothState)
      .run();

  static Stream<ScanResults> get scanResults => watchConfig()
      .asyncMap(
        (event) => readBluetoothState()
            .map((r) => r.scanResults)
            .getOrElse(() => const [])
            .run(),
      )
      .handleError((e, s) => print(e));
}
