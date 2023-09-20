import 'dart:convert';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:unlockd_bluetooth/src/domain/bluetooth_domain.dart';
import 'package:unlockd_bluetooth/src/domain/file_reader_domain.dart';
import 'package:watcher/watcher.dart';

const _bluetoothConfigPath = '/storage/self/primary/Download/bluetooth.json';

Stream<WatchEvent> watchConfig() => FileWatcher(_bluetoothConfigPath).events;

TaskEither<Exception, BluetoothState> readBluetoothState() =>
    readJsonFile(_bluetoothConfigPath).chainEither(
      (json) => Either.tryCatch(
        () => BluetoothState.fromJson(json),
        (o, s) => ConfigFileParsingException(),
      ),
    );

TaskEither<Exception, Json> readJsonFile(FilePath path) => TaskEither.tryCatch(
      () async => openFile(path).readAsString(),
      (_, __) => FileReadException(),
    ).map(jsonDecode).map((dynamicValue) => dynamicValue as Json);

File openFile(FilePath path) => File(path);

