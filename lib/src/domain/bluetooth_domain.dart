import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:unlockd_bluetooth/unlockd_bluetooth.dart';

typedef IsEmulator = bool;

class EmulatedBluetoothDevice extends UnlockdBluetoothDevice {
  EmulatedBluetoothDevice({
    required super.remoteId,
    required super.localName,
    required super.type,
  });

  @override
  Future<void> connect({
    Duration timeout = const Duration(seconds: 35),
    bool autoConnect = false,
  }) async {
    print('override connect');
  }
}

class ConnectedBluetoothDevices
    with FromIListMixin<BluetoothDevice, ConnectedBluetoothDevices> {
  /// This is the boilerplate to create the collection:
  final IList<BluetoothDevice> _devices;

  const ConnectedBluetoothDevices.empty() : _devices = const IListConst([]);

  ConnectedBluetoothDevices.fromList(Iterable<BluetoothDevice> devices)
      : _devices = IList(devices);

  @override
  ConnectedBluetoothDevices newInstance(IList<BluetoothDevice> ilist) =>
      ConnectedBluetoothDevices.fromList(ilist);

  @override
  IList<BluetoothDevice> get iter => _devices;

  List<Map<String, dynamic>> toJson() =>
      _devices.map((device) => device.toJson()).toList();
}

class ScanResults with FromIListMixin<UnlockdScanResult, ScanResults> {
  /// This is the boilerplate to create the collection:
  final IList<UnlockdScanResult> _results;

  const ScanResults.empty() : _results = const IListConst([]);

  ScanResults.fromList(Iterable<UnlockdScanResult> devices)
      : _results = IList(devices);

  @override
  ScanResults newInstance(IList<UnlockdScanResult> ilist) =>
      ScanResults.fromList(ilist);

  @override
  IList<UnlockdScanResult> get iter => _results;

  List<Map<String, dynamic>> toJson() =>
      _results.map((result) => result.toJson()).toList();
}

class EmulatedBluetoothState {
  EmulatedBluetoothState._({
    required this.adapterState,
    required this.connectedDevices,
    required this.isScanning,
    required this.scanResults,
  });

  factory EmulatedBluetoothState.fromJson(Map<String, dynamic> json) {
    return EmulatedBluetoothState._(
      adapterState: BluetoothAdapterStateExtension.fromValue(
        json['adapterState'] as String,
      ),
      connectedDevices: ConnectedBluetoothDevices.fromList(
        IList.fromJson(
          json['connectedDevices'],
          (device) => EmulatedBluetoothDeviceExtension.fromJson(
              device as Map<String, dynamic>),
        ),
      ),
      isScanning: json['isScanning'] as bool,
      scanResults: ScanResults.fromList(
        IList.fromJson(
          json['scanResults'],
          (result) => EmulatedScanResultExtension.fromJson(
              result as Map<String, dynamic>),
        ),
      ),
    );
  }

  final UnlockdBluetoothAdapterState adapterState;

  final ConnectedBluetoothDevices connectedDevices;

  final bool isScanning;

  final ScanResults scanResults;

  Map<String, dynamic> toJson() => {
        'adapterState': adapterState.name,
        'connectedDevices': connectedDevices.toJson(),
        'isScanning': isScanning,
        'scanResults': scanResults.toJson(),
      };

  EmulatedBluetoothState copyWith({
    BluetoothAdapterState? adapterState,
    bool? isScanning,
  }) {
    return EmulatedBluetoothState._(
      adapterState: adapterState ?? this.adapterState,
      connectedDevices: connectedDevices,
      isScanning: isScanning ?? this.isScanning,
      scanResults: scanResults,
    );
  }
}
