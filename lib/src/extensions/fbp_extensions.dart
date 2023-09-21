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

UnlockdBluetoothDevice fromJson(Map<String, dynamic> json) {
  return UnlockdBluetoothDevice(
    remoteId: UnlockdDeviceIdentifier(json['remoteId'] as String),
    localName: json['localName'] as String,
    type: BluetoothDeviceTypeExtension.fromValue(json['type'] as String),
  );
}

extension BluetoothDeviceExtension on UnlockdBluetoothDevice {
  Map<String, dynamic> toJson() => {
        'remoteId': remoteId.str,
        'localName': localName,
        'type': type.name,
      };
}
