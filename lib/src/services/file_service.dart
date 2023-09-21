import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:unlockd_bluetooth/unlockd_bluetooth.dart';
import 'package:watcher/watcher.dart';

const _bluetoothConfigPath = '/storage/self/primary/Download/bluetooth.json';

Stream<WatchEvent> watchConfig() => FileWatcher(_bluetoothConfigPath).events;

TaskOption<BluetoothState> readBluetoothState() =>
    readJsonFile(_bluetoothConfigPath)
        .chainEither(
          (json) => Either.tryCatch(
            () => BluetoothState.fromJson(json),
            (_, __) => ConfigFileParsingException(),
          ),
        )
        .bind(logException)
        .toTaskOption();

TaskEither<ReaderException, Json> readJsonFile(FilePath path) =>
    TaskEither.tryCatch(
      () async => openFile(path).readAsString(),
      (_, __) => FileReadException(),
    )
    // TODO(PJ): for some reason this cast is needed. Figure out why.
    // ignore: unnecessary_cast
        .mapLeft((l) => l as ReaderException)
        .map(jsonDecode)
        .map((dynamicValue) => dynamicValue as Json);

File openFile(FilePath path) => File(path);
