import 'dart:convert';
import 'dart:io';

import 'package:unlockd_bluetooth/unlockd_bluetooth.dart';

typedef FilePath = String;

typedef ReadJsonFile = dynamic Function(FilePath path);

const _bluetoothConfigPath = '/storage/self/primary/Download/bluetooth.json';

Stream<FileSystemEvent> watchConfig() => openFile(_bluetoothConfigPath).watch();

BluetoothConfig readConfig(ReadJsonFile readFile) =>
    BluetoothConfig.fromJson(readJsonFile(_bluetoothConfigPath));

dynamic readJsonFile(FilePath path) =>
    jsonDecode(openFile(path).readAsStringSync());

File openFile(FilePath path) => File(path);
