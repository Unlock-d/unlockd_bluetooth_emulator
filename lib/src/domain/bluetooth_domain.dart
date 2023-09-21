import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:unlockd_bluetooth/unlockd_bluetooth.dart';

typedef IsEmulator = bool;

typedef UnlockdDeviceIdentifier = DeviceIdentifier;

typedef UnlockdBluetoothAdapterState = BluetoothAdapterState;

typedef UnlockdBluetoothConnectionState = BluetoothConnectionState;

typedef UnlockdScanResult = ScanResult;

typedef UnlockdBluetoothDevice = BluetoothDevice;

typedef UnlockdBluetoothService = BluetoothService;

typedef UnlockdBluetoothCharacteristic = BluetoothCharacteristic;

typedef UnlockdBluetoothDescriptor = BluetoothDescriptor;

typedef UnlockdBluetoothDeviceType = BluetoothDeviceType;

typedef UnlockdBluetoothException = FlutterBluePlusException;

class ConnectedBluetoothDevices
    with FromIListMixin<UnlockdBluetoothDevice, ConnectedBluetoothDevices> {
  /// This is the boilerplate to create the collection:
  final IList<UnlockdBluetoothDevice> _devices;

  const ConnectedBluetoothDevices.empty() : _devices = const IListConst([]);

  ConnectedBluetoothDevices.fromList(Iterable<UnlockdBluetoothDevice> devices)
      : _devices = IList(devices);

  @override
  ConnectedBluetoothDevices newInstance(IList<UnlockdBluetoothDevice> ilist) =>
      ConnectedBluetoothDevices.fromList(ilist);

  @override
  IList<UnlockdBluetoothDevice> get iter => _devices;

  List<Map<String, dynamic>> toJson() =>
      _devices.map((device) => device.toJson()).toList();
}

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

class BluetoothState {
  BluetoothState._({
    required this.adapterState,
    this.connectedDevices = const ConnectedBluetoothDevices.empty(),
    this.isScanning = false,
  });

  factory BluetoothState.fromJson(Map<String, dynamic> json) {
    return BluetoothState._(
      adapterState: BluetoothAdapterStateExtension.fromValue(
        json['adapterState'] as String,
      ),
      connectedDevices: ConnectedBluetoothDevices.fromList(
        IList.fromJson(
          json['connectedDevices'],
          (list) => fromJson(list as Map<String, dynamic>),
        ),
      ),
      isScanning: json['isScanning'] as bool,
    );
  }

  final UnlockdBluetoothAdapterState adapterState;

  final ConnectedBluetoothDevices connectedDevices;

  final bool isScanning;

  Map<String, dynamic> toJson() => {
        'adapterState': adapterState.name,
        'connectedDevices': connectedDevices.toJson(),
        'isScanning': isScanning,
      };

  BluetoothState copyWith({
    BluetoothAdapterState? adapterState,
  }) {
    return BluetoothState._(
      adapterState: adapterState ?? this.adapterState,
      connectedDevices: connectedDevices,
      isScanning: isScanning,
    );
  }
}
