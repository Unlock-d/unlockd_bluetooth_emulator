import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:unlockd_bluetooth/unlockd_bluetooth.dart';

TaskOption<EmulatedBluetoothState> readBluetoothState() =>
    readJsonFile(bluetoothConfigPath)
        .chainEither(mapToBluetoothState)
        .bind(logException)
        .toTaskOption();

TaskOption<EmulatedBluetoothDevice> readBluetoothDeviceState() =>
    readJsonFile(bluetoothDeviceConfigPath)
        .chainEither(mapToBluetoothDevice)
        .bind(logException)
        .toTaskOption();

// TODO(PJ): this should return the bluetooth state from the emulator not a file
TaskOption<File> writeBluetoothState(EmulatedBluetoothState state) =>
    openFile(bluetoothConfigPath)
        .chainFirst((file) => overwriteFileContents(file, jsonEncode(state)))
        .bind(logException)
        .toTaskOption();

Either<FileHandlingException, EmulatedBluetoothState> mapToBluetoothState(
  Json json,
) =>
    Either.tryCatch(
      () => EmulatedBluetoothState.fromJson(json),
      ConfigFileParsingException.new,
    );

Either<FileHandlingException, EmulatedBluetoothDevice> mapToBluetoothDevice(
  Json json,
) =>
    Either.tryCatch(
      () => EmulatedBluetoothDevice.fromJson(json),
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
