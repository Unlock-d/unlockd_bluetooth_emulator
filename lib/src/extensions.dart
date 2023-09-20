import 'package:unlockd_bluetooth/unlockd_bluetooth.dart';

extension BluetoothAdapterStateExtension on UnlockdBluetoothAdapterState {
  static UnlockdBluetoothAdapterState fromValue(String value) {
    return UnlockdBluetoothAdapterState.values.firstWhere(
      (element) => element.name == value,
      orElse: () => UnlockdBluetoothAdapterState.unknown,
    );
  }
}

extension BluetoothDeviceTypeExtension on UnlockdBluetoothDeviceType {
  static UnlockdBluetoothDeviceType fromValue(String value) {
    return UnlockdBluetoothDeviceType.values.firstWhere(
      (element) => element.name == value,
      orElse: () => UnlockdBluetoothDeviceType.unknown,
    );
  }
}

extension BluetoothDeviceExtension on UnlockdBluetoothDevice {
  static UnlockdBluetoothDevice fromJson(dynamic value) {
    final json = value as Map<String, dynamic>;
    return UnlockdBluetoothDevice(
      remoteId: UnlockdDeviceIdentifier(json['remoteId'] as String),
      localName: json['localName'] as String,
      type: BluetoothDeviceTypeExtension.fromValue(
        json['type'] as String,
      ),
    );
  }
}
