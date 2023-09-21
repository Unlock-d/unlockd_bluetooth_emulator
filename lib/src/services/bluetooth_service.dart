import 'package:fpdart/fpdart.dart';
import 'package:unlockd_bluetooth/unlockd_bluetooth.dart';

Either<FileHandlingException, BluetoothState> mapToBluetoothState(Json json) =>
    Either.tryCatch(
      () => BluetoothState.fromJson(json),
      (_, __) => ConfigFileParsingException(),
    );

BluetoothState turnOnBluetooth(BluetoothState state) {
  return state.copyWith(adapterState: UnlockdBluetoothAdapterState.on);
}

BluetoothState startScanning(BluetoothState state) {
  return state.copyWith(isScanning: true);
}

BluetoothState stopScanning(BluetoothState state) {
  return state.copyWith(isScanning: false);
}
