import 'package:fpdart/fpdart.dart';
import 'package:unlockd_bluetooth/src/domain/bluetooth_domain.dart';

extension BluetoothAdapterStateExtension on UnlockdBluetoothAdapterState {
  static UnlockdBluetoothAdapterState fromValue(String value) {
    return UnlockdBluetoothAdapterState.values
        .firstWhere((element) => element.name == value);
  }
}

extension BluetoothDeviceTypeExtension on UnlockdBluetoothDeviceType {
  static UnlockdBluetoothDeviceType fromValue(String value) {
    return UnlockdBluetoothDeviceType.values
        .firstWhere((element) => element.name == value);
  }
}

extension BluetoothDeviceExtension on UnlockdBluetoothDevice {
  Map<String, dynamic> toJson() => {
        'remoteId': remoteId.str,
        'localName': localName,
        'type': type.name,
      };

  static UnlockdBluetoothDevice fromJson(Map<String, dynamic> json) {
    return UnlockdBluetoothDevice(
      remoteId: UnlockdDeviceIdentifier(json['remoteId'] as String),
      localName: json['localName'] as String,
      type: BluetoothDeviceTypeExtension.fromValue(json['type'] as String),
    );
  }
}

extension AdvertisementDataExtension on UnlockdAdvertisementData {
  Map<String, dynamic> toJson() => {
        'localName': localName,
        'txPowerLevel': txPowerLevel,
        'connectable': connectable,
        'manufacturerData':
            manufacturerData.map((key, value) => MapEntry('$key', value)),
        'serviceData': serviceData,
        'serviceUuids': serviceUuids,
      };

  static UnlockdAdvertisementData fromJson(Map<String, dynamic> json) {
    return UnlockdAdvertisementData(
      localName: json['localName'] as String,
      txPowerLevel: json['txPowerLevel'] as int?,
      connectable: json['connectable'] as bool,
      manufacturerData: (json['manufacturerData'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(int.parse(key), value))
          .mapValue(
            (value) => (value as List<dynamic>).map((e) => e as int).toList(),
          ),
      serviceData: (json['serviceData'] as Map<String, dynamic>).mapValue(
        (value) => (value as List<dynamic>).map((e) => e as int).toList(),
      ),
      serviceUuids: (json['serviceUuids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }
}

extension ScanResultExtension on UnlockdScanResult {
  Map<String, dynamic> toJson() => {
        'device': device.toJson(),
        'advertisementData': advertisementData.toJson(),
        'rssi': rssi,
        'timeStamp': timeStamp.toIso8601String(),
      };

  static UnlockdScanResult fromJson(Map<String, dynamic> json) {
    return UnlockdScanResult(
      device: BluetoothDeviceExtension.fromJson(
        json['device'] as Map<String, dynamic>,
      ),
      advertisementData: AdvertisementDataExtension.fromJson(
        json['advertisementData'] as Map<String, dynamic>,
      ),
      rssi: json['rssi'] as int,
      timeStamp: DateTime.parse(json['timeStamp'] as String),
    );
  }
}
