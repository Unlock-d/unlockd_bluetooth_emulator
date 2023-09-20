import 'dart:convert';
import 'dart:io';

import 'package:unlockd_bluetooth/unlockd_bluetooth.dart';
import 'package:watcher/watcher.dart';

typedef FilePath = String;

typedef ReadJsonFile = dynamic Function(FilePath path);

const _bluetoothConfigPath = '/storage/self/primary/Download/bluetooth.json';

Stream<WatchEvent> watchConfig() => FileWatcher(_bluetoothConfigPath).events;

BluetoothConfig readConfig() =>
    BluetoothConfig.fromJson(readJsonFile(_bluetoothConfigPath));

dynamic readJsonFile(FilePath path) =>
    jsonDecode(openFile(path).readAsStringSync());

File openFile(FilePath path) => File(path);
