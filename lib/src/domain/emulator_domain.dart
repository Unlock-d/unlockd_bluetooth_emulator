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

class EmulatedBluetoothState {
  EmulatedBluetoothState._({
    required this.adapterState,
    required this.connectedDevices,
    required this.isScanning,
    required this.scanResults,
  });

  factory EmulatedBluetoothState.fromJson(Json json) {
    return EmulatedBluetoothState._(
      adapterState: BluetoothAdapterStateExtension.fromValue(
        json['adapterState'] as String,
      ),
      connectedDevices: (json['connectedDevices'] as List<dynamic>)
          .map(
            (device) =>
                EmulatedBluetoothDeviceExtension.fromJson(device as Json),
          )
          .toList(),
      isScanning: json['isScanning'] as bool,
      scanResults: (json['scanResults'] as List<dynamic>)
          .map((device) => EmulatedScanResultExtension.fromJson(device as Json))
          .toList(),
    );
  }

  final UnlockdBluetoothAdapterState adapterState;

  final ConnectedBluetoothDevices connectedDevices;

  final bool isScanning;

  final ScanResults scanResults;

  Json toJson() => {
        'adapterState': adapterState.name,
        'connectedDevices': connectedDevices.map((e) => e.toJson()).toList(),
        'isScanning': isScanning,
        'scanResults': scanResults.map((e) => e.toJson()).toList(),
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
