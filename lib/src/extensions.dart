import 'package:unlockd_bluetooth/unlockd_bluetooth.dart';

extension BluetoothAdapterStateExtension on UnlockdBluetoothAdapterState {
  static UnlockdBluetoothAdapterState fromValue(String value) {
    return UnlockdBluetoothAdapterState.values.firstWhere(
      (element) => element.name == value,
      orElse: () => UnlockdBluetoothAdapterState.unknown,
    );
  }
}
