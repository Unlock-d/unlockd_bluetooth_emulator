import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:unlockd_bluetooth/unlockd_bluetooth.dart';

typedef IsEmulator = bool;

class EmulatedBluetoothDevice extends UnlockdBluetoothDevice {
  EmulatedBluetoothDevice({
    required super.remoteId,
    required super.localName,
    required super.type,
    required this.deviceConnectionState,
  });

  final UnlockdBluetoothConnectionState deviceConnectionState;

  @override
  Future<void> connect({
    Duration timeout = const Duration(seconds: 35),
    bool autoConnect = false,
  }) async {
    print('override connect');
  }

  @override
  Future<void> disconnect({int timeout = 35}) async {
    print('override disconnect');
  }

  @override
  List<UnlockdBluetoothService>? get servicesList {
    return [];
  }

  @override
  Future<int> readRssi({int timeout = 15}) async {
    return 0;
  }

  @override
  Stream<UnlockdBluetoothConnectionState> get connectionState =>
      watchBluetoothDeviceConfig().asyncMap(
        (event) => readBluetoothDeviceState()
            .map((r) => r.deviceConnectionState)
            .getOrElse(() => UnlockdBluetoothConnectionState.disconnected)
            .run(),
      );

  Json toJson() => {
        'remoteId': remoteId.str,
        'localName': localName,
        'type': type.name,
        'deviceConnectionState': deviceConnectionState.name,
      };

  static EmulatedBluetoothDevice fromJson(Json json) {
    return EmulatedBluetoothDevice(
      remoteId: DeviceIdentifier(json['remoteId'] as String),
      localName: json['localName'] as String,
      type: BluetoothDeviceTypeExtension.fromValue(json['type'] as String),
      deviceConnectionState: BluetoothConnectionStateExtension.fromValue(
        json['deviceConnectionState'] as String,
      ),
    );
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
          .map((device) => EmulatedBluetoothDevice.fromJson(device as Json))
          .toList(),
      isScanning: json['isScanning'] as bool,
      scanResults: (json['scanResults'] as List<dynamic>)
          .map((device) => EmulatedScanResult.fromJson(device as Json))
          .toList(),
    );
  }

  final UnlockdBluetoothAdapterState adapterState;

  final ConnectedEmulatedBluetoothDevices connectedDevices;

  final bool isScanning;

  final EmulatedScanResults scanResults;

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

class EmulatedScanResult extends UnlockdScanResult {
  EmulatedScanResult({
    required this.device,
    required super.advertisementData,
    required super.rssi,
    required super.timeStamp,
  }) : super(device: device);

  final EmulatedBluetoothDevice device;

  Json toJson() => {
        'device': device.toJson(),
        'advertisementData': advertisementData.toJson(),
        'rssi': rssi,
        'timeStamp': timeStamp.toIso8601String(),
      };

  static EmulatedScanResult fromJson(Json json) {
    return EmulatedScanResult(
      device: EmulatedBluetoothDevice.fromJson(
        json['device'] as Json,
      ),
      advertisementData: AdvertisementDataExtension.fromJson(
        json['advertisementData'] as Json,
      ),
      rssi: json['rssi'] as int,
      timeStamp: DateTime.parse(json['timeStamp'] as String),
    );
  }
}
