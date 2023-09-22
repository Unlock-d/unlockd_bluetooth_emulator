import 'package:unlockd_bluetooth/unlockd_bluetooth.dart';

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

extension EmulatedBluetoothDeviceExtension on UnlockdBluetoothDevice {
  Json toJson() => {
        'remoteId': remoteId.str,
        'localName': localName,
        'type': type.name,
      };

  static UnlockdBluetoothDevice fromJson(Json json) {
    return EmulatedBluetoothDevice(
      remoteId: UnlockdDeviceIdentifier(json['remoteId'] as String),
      localName: json['localName'] as String,
      type: BluetoothDeviceTypeExtension.fromValue(json['type'] as String),
    );
  }
}

extension AdvertisementDataExtension on UnlockdAdvertisementData {
  Json toJson() => {
        'localName': localName,
        'txPowerLevel': txPowerLevel,
        'connectable': connectable,
        'manufacturerData':
            manufacturerData.map((key, value) => MapEntry('$key', value)),
        'serviceData': serviceData,
        'serviceUuids': serviceUuids,
      };

  static UnlockdAdvertisementData fromJson(Json json) {
    return UnlockdAdvertisementData(
      localName: json['localName'] as String,
      txPowerLevel: json['txPowerLevel'] as int?,
      connectable: json['connectable'] as bool,
      manufacturerData: (json['manufacturerData'] as Json).map(
        (key, value) => MapEntry(
          int.parse(key),
          (value as List<dynamic>).map((e) => e as int).toList(),
        ),
      ),
      serviceData: (json['serviceData'] as Json).map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>).map((e) => e as int).toList(),
        ),
      ),
      serviceUuids: (json['serviceUuids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }
}

extension EmulatedScanResultExtension on UnlockdScanResult {
  Json toJson() => {
        'device': device.toJson(),
        'advertisementData': advertisementData.toJson(),
        'rssi': rssi,
        'timeStamp': timeStamp.toIso8601String(),
      };

  static UnlockdScanResult fromJson(Json json) {
    return UnlockdScanResult(
      device: EmulatedBluetoothDeviceExtension.fromJson(
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
