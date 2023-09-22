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

extension BluetoothConnectionStateExtension on UnlockdBluetoothConnectionState {
  static UnlockdBluetoothConnectionState fromValue(String value) {
    return UnlockdBluetoothConnectionState.values
        .firstWhere((element) => element.name == value);
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
