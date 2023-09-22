import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:unlockd_bluetooth/src/domain/domain.dart';

typedef UnlockdDeviceIdentifier = DeviceIdentifier;

typedef UnlockdBluetoothAdapterState = BluetoothAdapterState;

typedef UnlockdBluetoothConnectionState = BluetoothConnectionState;

typedef UnlockdScanResult = ScanResult;

typedef UnlockdBluetoothDevice = BluetoothDevice;

typedef ConnectedBluetoothDevices = List<BluetoothDevice>;

typedef ConnectedEmulatedBluetoothDevices = List<EmulatedBluetoothDevice>;

typedef ScanResults = List<ScanResult>;

typedef EmulatedScanResults = List<EmulatedScanResult>;

typedef UnlockdBluetoothService = BluetoothService;

typedef UnlockdBluetoothCharacteristic = BluetoothCharacteristic;

typedef UnlockdBluetoothDescriptor = BluetoothDescriptor;

typedef UnlockdBluetoothDeviceType = BluetoothDeviceType;

typedef UnlockdAdvertisementData = AdvertisementData;

typedef UnlockdBluetoothException = FlutterBluePlusException;

typedef TurnOn = Future<void> Function({int timeout});

typedef StartScan = Future<void> Function({
  List<Guid> withServices,
  Duration? timeout,
  Duration? removeIfGone,
  bool oneByOne,
  bool androidUsesFineLocation,
});

typedef StopScan = Future<void> Function();
