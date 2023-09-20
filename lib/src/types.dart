part of '../unlockd_bluetooth.dart';

typedef IsEmulator = bool;

typedef UnlockdDeviceIdentifier = DeviceIdentifier;

typedef UnlockdBluetoothAdapterState = BluetoothAdapterState;

typedef UnlockdBluetoothConnectionState = BluetoothConnectionState;

typedef UnlockdScanResult = ScanResult;

typedef UnlockdBluetoothDevice = BluetoothDevice;

typedef UnlockdBluetoothService = BluetoothService;

typedef UnlockdBluetoothCharacteristic = BluetoothCharacteristic;

typedef UnlockdBluetoothDescriptor = BluetoothDescriptor;

typedef UnlockdBluetoothException = FlutterBluePlusException;

typedef ConnectedBluetoothDevices = List<UnlockdBluetoothDevice>;

typedef ScanResults = List<UnlockdScanResult>;

typedef TurnOn = Future<void> Function({int timeout});

typedef StartScan = Future<void> Function({
  List<Guid> withServices,
  Duration? timeout,
  Duration? removeIfGone,
  bool oneByOne,
  bool androidUsesFineLocation,
});

typedef StopScan = Future<void> Function();

class BluetoothConfig {
  BluetoothConfig._({
    this.adapterState = UnlockdBluetoothAdapterState.unknown,
  });

  factory BluetoothConfig.fromJson(dynamic value) {
    final json = value as Map<String, dynamic>;
    return BluetoothConfig._(
      adapterState: BluetoothAdapterStateExtension.fromValue(
        json['adapterState'] as String,
      ),
    );
  }

  final UnlockdBluetoothAdapterState adapterState;
}
