import 'package:fpdart/fpdart.dart';
import 'package:unlockd_bluetooth/unlockd_bluetooth.dart';

Either<FileHandlingException, EmulatedBluetoothState> mapToBluetoothState(Json json) =>
    Either.tryCatch(
      () => EmulatedBluetoothState.fromJson(json),
      ConfigFileParsingException.new,
    );

EmulatedBluetoothState turnOnBluetooth(EmulatedBluetoothState state) {
  return state.copyWith(adapterState: UnlockdBluetoothAdapterState.on);
}

EmulatedBluetoothState startScanning(EmulatedBluetoothState state) {
  return state.copyWith(isScanning: true);
}

EmulatedBluetoothState stopScanning(EmulatedBluetoothState state) {
  return state.copyWith(isScanning: false);
}
