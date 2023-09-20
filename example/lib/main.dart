// Copyright 2023, Charles Weinberger & Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:example/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unlockd_bluetooth/unlockd_bluetooth.dart';

import 'widgets.dart';

final snackBarKeyA = GlobalKey<ScaffoldMessengerState>();
final snackBarKeyB = GlobalKey<ScaffoldMessengerState>();
final snackBarKeyC = GlobalKey<ScaffoldMessengerState>();
final Map<UnlockdDeviceIdentifier, ValueNotifier<bool>>
    isConnectingOrDisconnecting = {};

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureGetItDependencies(Environment.dev);
  if (Platform.isAndroid) {
    [
      Permission.location,
      Permission.storage,
      Permission.manageExternalStorage,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ].request().then((status) {
      runApp(FlutterBlueApp(
          isEmulator: !getIt<bool>(instanceName: 'isPhysicalDevice')));
    });
  } else {
    runApp(FlutterBlueApp(
        isEmulator: !getIt<bool>(instanceName: 'isPhysicalDevice')));
  }
}

class BluetoothAdapterStateObserver extends NavigatorObserver {
  BluetoothAdapterStateObserver(this.isEmulator);

  StreamSubscription<UnlockdBluetoothAdapterState>? _btStateSubscription;
  final bool isEmulator;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/deviceScreen') {
      // Start listening to Bluetooth state changes when a new route is pushed
      _btStateSubscription ??=
          UnlockdBluetooth.adapterState(isEmulator: isEmulator).listen((state) {
        if (state != UnlockdBluetoothAdapterState.on) {
          // Pop the current route if Bluetooth is off
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancel the subscription when the route is popped
    _btStateSubscription?.cancel();
    _btStateSubscription = null;
  }
}

class FlutterBlueApp extends StatelessWidget {
  const FlutterBlueApp({Key? key, required this.isEmulator}) : super(key: key);

  final bool isEmulator;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      home: StreamBuilder<UnlockdBluetoothAdapterState>(
          stream: UnlockdBluetooth.adapterState(isEmulator: isEmulator),
          initialData: UnlockdBluetoothAdapterState.unknown,
          builder: (c, snapshot) {
            final adapterState = snapshot.data;
            if (adapterState == UnlockdBluetoothAdapterState.on) {
              return const FindDevicesScreen();
            } else {
              UnlockdBluetooth.stopScan();
              return BluetoothOffScreen(adapterState: adapterState);
            }
          }),
      navigatorObservers: [BluetoothAdapterStateObserver(isEmulator)],
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.adapterState}) : super(key: key);

  final UnlockdBluetoothAdapterState? adapterState;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: snackBarKeyA,
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.bluetooth_disabled,
                size: 200.0,
                color: Colors.white54,
              ),
              Text(
                'Bluetooth Adapter is ${adapterState != null ? adapterState.toString().split(".").last : 'not available'}.',
                style: Theme.of(context)
                    .primaryTextTheme
                    .titleSmall
                    ?.copyWith(color: Colors.white),
              ),
              if (Platform.isAndroid)
                ElevatedButton(
                  child: const Text('TURN ON'),
                  onPressed: () async {
                    try {
                      if (Platform.isAndroid) {
                        await UnlockdBluetooth.turnOn();
                      }
                    } catch (e) {
                      final snackBar =
                          snackBarFail(prettyException("Error Turning On:", e));
                      snackBarKeyA.currentState?.removeCurrentSnackBar();
                      snackBarKeyA.currentState?.showSnackBar(snackBar);
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatefulWidget {
  const FindDevicesScreen({Key? key}) : super(key: key);

  @override
  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: snackBarKeyB,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Find Devices'),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {}); // force refresh of connectedSystemDevices
            if (UnlockdBluetooth.isScanningNow == false) {
              UnlockdBluetooth.startScan(
                  timeout: const Duration(seconds: 15),
                  androidUsesFineLocation: false);
            }
            return Future.delayed(
                Duration(milliseconds: 500)); // show refresh icon breifly
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                StreamBuilder<List<UnlockdBluetoothDevice>>(
                  stream: Stream.fromFuture(
                      UnlockdBluetooth.connectedSystemDevices),
                  initialData: const [],
                  builder: (c, snapshot) => Column(
                    children: (snapshot.data ?? [])
                        .map((d) => ListTile(
                              title: Text(d.localName),
                              subtitle: Text(d.remoteId.toString()),
                              trailing: StreamBuilder<
                                  UnlockdBluetoothConnectionState>(
                                stream: d.connectionState,
                                initialData: UnlockdBluetoothConnectionState
                                    .disconnected,
                                builder: (c, snapshot) {
                                  if (snapshot.data ==
                                      UnlockdBluetoothConnectionState
                                          .connected) {
                                    return ElevatedButton(
                                      child: const Text('OPEN'),
                                      onPressed: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  DeviceScreen(device: d),
                                              settings: RouteSettings(
                                                  name: '/deviceScreen'))),
                                    );
                                  }
                                  if (snapshot.data ==
                                      UnlockdBluetoothConnectionState
                                          .disconnected) {
                                    return ElevatedButton(
                                        child: const Text('CONNECT'),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    isConnectingOrDisconnecting[
                                                            d.remoteId] ??=
                                                        ValueNotifier(true);
                                                    isConnectingOrDisconnecting[
                                                            d.remoteId]!
                                                        .value = true;
                                                    d
                                                        .connect(
                                                            timeout: Duration(
                                                                seconds: 35))
                                                        .catchError((e) {
                                                      final snackBar =
                                                          snackBarFail(
                                                              prettyException(
                                                                  "Connect Error:",
                                                                  e));
                                                      snackBarKeyC.currentState
                                                          ?.removeCurrentSnackBar();
                                                      snackBarKeyC.currentState
                                                          ?.showSnackBar(
                                                              snackBar);
                                                    }).then((v) {
                                                      isConnectingOrDisconnecting[
                                                              d.remoteId] ??=
                                                          ValueNotifier(false);
                                                      isConnectingOrDisconnecting[
                                                              d.remoteId]!
                                                          .value = false;
                                                    });
                                                    return DeviceScreen(
                                                        device: d);
                                                  },
                                                  settings: RouteSettings(
                                                      name: '/deviceScreen')));
                                        });
                                  }
                                  return Text(snapshot.data
                                      .toString()
                                      .toUpperCase()
                                      .split('.')[1]);
                                },
                              ),
                            ))
                        .toList(),
                  ),
                ),
                StreamBuilder<List<UnlockdScanResult>>(
                  stream: UnlockdBluetooth.scanResults,
                  initialData: const [],
                  builder: (c, snapshot) => Column(
                    children: (snapshot.data ?? [])
                        .map(
                          (r) => ScanResultTile(
                            result: r,
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) {
                                      isConnectingOrDisconnecting[r.device
                                          .remoteId] ??= ValueNotifier(true);
                                      isConnectingOrDisconnecting[
                                              r.device.remoteId]!
                                          .value = true;
                                      r.device
                                          .connect(
                                              timeout: Duration(seconds: 35))
                                          .catchError((e) {
                                        final snackBar = snackBarFail(
                                            prettyException(
                                                "Connect Error:", e));
                                        snackBarKeyC.currentState
                                            ?.removeCurrentSnackBar();
                                        snackBarKeyC.currentState
                                            ?.showSnackBar(snackBar);
                                      }).then((v) {
                                        isConnectingOrDisconnecting[r.device
                                            .remoteId] ??= ValueNotifier(false);
                                        isConnectingOrDisconnecting[
                                                r.device.remoteId]!
                                            .value = false;
                                      });
                                      return DeviceScreen(device: r.device);
                                    },
                                    settings:
                                        RouteSettings(name: '/deviceScreen'))),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: StreamBuilder<bool>(
          stream: UnlockdBluetooth.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data ?? false) {
              return FloatingActionButton(
                child: const Icon(Icons.stop),
                onPressed: () async {
                  try {
                    UnlockdBluetooth.stopScan();
                  } catch (e) {
                    final snackBar =
                        snackBarFail(prettyException("Stop Scan Error:", e));
                    snackBarKeyB.currentState?.removeCurrentSnackBar();
                    snackBarKeyB.currentState?.showSnackBar(snackBar);
                  }
                },
                backgroundColor: Colors.red,
              );
            } else {
              return FloatingActionButton(
                  child: const Text("SCAN"),
                  onPressed: () async {
                    try {
                      await UnlockdBluetooth.startScan(
                          timeout: const Duration(seconds: 15),
                          androidUsesFineLocation: false);
                    } catch (e) {
                      final snackBar =
                          snackBarFail(prettyException("Start Scan Error:", e));
                      snackBarKeyB.currentState?.removeCurrentSnackBar();
                      snackBarKeyB.currentState?.showSnackBar(snackBar);
                    }
                    setState(() {}); // force refresh of connectedSystemDevices
                  });
            }
          },
        ),
      ),
    );
  }
}

class DeviceScreen extends StatelessWidget {
  final UnlockdBluetoothDevice device;

  const DeviceScreen({Key? key, required this.device}) : super(key: key);

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  List<Widget> _buildServiceTiles(
      BuildContext context, List<UnlockdBluetoothService> services) {
    return services
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics
                .map(
                  (c) => CharacteristicTile(
                    characteristic: c,
                    onReadPressed: () async {
                      try {
                        await c.read();
                        final snackBar = snackBarGood("Read: Success");
                        snackBarKeyC.currentState?.removeCurrentSnackBar();
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      } catch (e) {
                        final snackBar =
                            snackBarFail(prettyException("Read Error:", e));
                        snackBarKeyC.currentState?.removeCurrentSnackBar();
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      }
                    },
                    onWritePressed: () async {
                      try {
                        await c.write(_getRandomBytes(),
                            withoutResponse: c.properties.writeWithoutResponse);
                        final snackBar = snackBarGood("Write: Success");
                        snackBarKeyC.currentState?.removeCurrentSnackBar();
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                        if (c.properties.read) {
                          await c.read();
                        }
                      } catch (e) {
                        final snackBar =
                            snackBarFail(prettyException("Write Error:", e));
                        snackBarKeyC.currentState?.removeCurrentSnackBar();
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      }
                    },
                    onNotificationPressed: () async {
                      try {
                        String op =
                            c.isNotifying == false ? "Subscribe" : "Unubscribe";
                        await c.setNotifyValue(c.isNotifying == false);
                        final snackBar = snackBarGood("$op : Success");
                        snackBarKeyC.currentState?.removeCurrentSnackBar();
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                        if (c.properties.read) {
                          await c.read();
                        }
                      } catch (e) {
                        final snackBar = snackBarFail(
                            prettyException("Subscribe Error:", e));
                        snackBarKeyC.currentState?.removeCurrentSnackBar();
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      }
                    },
                    descriptorTiles: c.descriptors
                        .map(
                          (d) => DescriptorTile(
                            descriptor: d,
                            onReadPressed: () async {
                              try {
                                await d.read();
                                final snackBar = snackBarGood("Read: Success");
                                snackBarKeyC.currentState
                                    ?.removeCurrentSnackBar();
                                snackBarKeyC.currentState
                                    ?.showSnackBar(snackBar);
                              } catch (e) {
                                final snackBar = snackBarFail(
                                    prettyException("Read Error:", e));
                                snackBarKeyC.currentState
                                    ?.removeCurrentSnackBar();
                                snackBarKeyC.currentState
                                    ?.showSnackBar(snackBar);
                              }
                            },
                            onWritePressed: () async {
                              try {
                                await d.write(_getRandomBytes());
                                final snackBar = snackBarGood("Write: Success");
                                snackBarKeyC.currentState
                                    ?.removeCurrentSnackBar();
                                snackBarKeyC.currentState
                                    ?.showSnackBar(snackBar);
                              } catch (e) {
                                final snackBar = snackBarFail(
                                    prettyException("Write Error:", e));
                                snackBarKeyC.currentState
                                    ?.removeCurrentSnackBar();
                                snackBarKeyC.currentState
                                    ?.showSnackBar(snackBar);
                              }
                            },
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: snackBarKeyC,
      child: Scaffold(
        appBar: AppBar(
          title: Text(device.localName),
          actions: <Widget>[
            StreamBuilder<UnlockdBluetoothConnectionState>(
              stream: device.connectionState,
              initialData: UnlockdBluetoothConnectionState.connecting,
              builder: (c, snapshot) {
                VoidCallback? onPressed;
                String text;
                switch (snapshot.data) {
                  case UnlockdBluetoothConnectionState.connected:
                    onPressed = () async {
                      isConnectingOrDisconnecting[device.remoteId] ??=
                          ValueNotifier(true);
                      isConnectingOrDisconnecting[device.remoteId]!.value =
                          true;
                      try {
                        await device.disconnect();
                        final snackBar = snackBarGood("Disconnect: Success");
                        snackBarKeyC.currentState?.removeCurrentSnackBar();
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      } catch (e) {
                        final snackBar = snackBarFail(
                            prettyException("Disconnect Error:", e));
                        snackBarKeyC.currentState?.removeCurrentSnackBar();
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      }
                      isConnectingOrDisconnecting[device.remoteId] ??=
                          ValueNotifier(false);
                      isConnectingOrDisconnecting[device.remoteId]!.value =
                          false;
                    };
                    text = 'DISCONNECT';
                    break;
                  case UnlockdBluetoothConnectionState.disconnected:
                    onPressed = () async {
                      isConnectingOrDisconnecting[device.remoteId] ??=
                          ValueNotifier(true);
                      isConnectingOrDisconnecting[device.remoteId]!.value =
                          true;
                      try {
                        await device.connect(timeout: Duration(seconds: 35));
                        final snackBar = snackBarGood("Connect: Success");
                        snackBarKeyC.currentState?.removeCurrentSnackBar();
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      } catch (e) {
                        final snackBar =
                            snackBarFail(prettyException("Connect Error:", e));
                        snackBarKeyC.currentState?.removeCurrentSnackBar();
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      }
                      isConnectingOrDisconnecting[device.remoteId] ??=
                          ValueNotifier(false);
                      isConnectingOrDisconnecting[device.remoteId]!.value =
                          false;
                    };
                    text = 'CONNECT';
                    break;
                  default:
                    onPressed = null;
                    text =
                        snapshot.data.toString().split(".").last.toUpperCase();
                    break;
                }
                return ValueListenableBuilder<bool>(
                    valueListenable:
                        isConnectingOrDisconnecting[device.remoteId]!,
                    builder: (context, value, child) {
                      isConnectingOrDisconnecting[device.remoteId] ??=
                          ValueNotifier(false);
                      if (isConnectingOrDisconnecting[device.remoteId]!.value ==
                          true) {
                        // Show spinner when connecting or disconnecting
                        return Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.black12,
                              color: Colors.black26,
                            ),
                          ),
                        );
                      } else {
                        return TextButton(
                            onPressed: onPressed,
                            child: Text(
                              text,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .labelLarge
                                  ?.copyWith(color: Colors.white),
                            ));
                      }
                    });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<UnlockdBluetoothConnectionState>(
                stream: device.connectionState,
                initialData: UnlockdBluetoothConnectionState.connecting,
                builder: (c, snapshot) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${device.remoteId}'),
                    ),
                    ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          snapshot.data ==
                                  UnlockdBluetoothConnectionState.connected
                              ? const Icon(Icons.bluetooth_connected)
                              : const Icon(Icons.bluetooth_disabled),
                          snapshot.data ==
                                  UnlockdBluetoothConnectionState.connected
                              ? StreamBuilder<int>(
                                  stream: rssiStream(maxItems: 1),
                                  builder: (context, snapshot) {
                                    return Text(
                                        snapshot.hasData
                                            ? '${snapshot.data}dBm'
                                            : '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall);
                                  })
                              : Text('',
                                  style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      title: Text(
                          'Device is ${snapshot.data.toString().split('.')[1]}.'),
                      trailing: StreamBuilder<bool>(
                        stream: device.isDiscoveringServices,
                        initialData: false,
                        builder: (c, snapshot) => IndexedStack(
                          index: (snapshot.data ?? false) ? 1 : 0,
                          children: <Widget>[
                            TextButton(
                              child: const Text("Get Services"),
                              onPressed: () async {
                                try {
                                  await device.discoverServices();
                                  final snackBar = snackBarGood(
                                      "Discover Services: Success");
                                  snackBarKeyC.currentState
                                      ?.removeCurrentSnackBar();
                                  snackBarKeyC.currentState
                                      ?.showSnackBar(snackBar);
                                } catch (e) {
                                  final snackBar = snackBarFail(prettyException(
                                      "Discover Services Error:", e));
                                  snackBarKeyC.currentState
                                      ?.removeCurrentSnackBar();
                                  snackBarKeyC.currentState
                                      ?.showSnackBar(snackBar);
                                }
                              },
                            ),
                            const IconButton(
                              icon: SizedBox(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.grey),
                                ),
                                width: 18.0,
                                height: 18.0,
                              ),
                              onPressed: null,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<int>(
                stream: device.mtu,
                initialData: 0,
                builder: (c, snapshot) => ListTile(
                  title: const Text('MTU Size'),
                  subtitle: Text('${snapshot.data} bytes'),
                  trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        try {
                          await device.requestMtu(223);
                          final snackBar = snackBarGood("Request Mtu: Success");
                          snackBarKeyC.currentState?.removeCurrentSnackBar();
                          snackBarKeyC.currentState?.showSnackBar(snackBar);
                        } catch (e) {
                          final snackBar = snackBarFail(
                              prettyException("Change Mtu Error:", e));
                          snackBarKeyC.currentState?.removeCurrentSnackBar();
                          snackBarKeyC.currentState?.showSnackBar(snackBar);
                        }
                      }),
                ),
              ),
              StreamBuilder<List<UnlockdBluetoothService>>(
                stream: device.servicesStream,
                initialData: const [],
                builder: (c, snapshot) {
                  return Column(
                    children: _buildServiceTiles(context, snapshot.data ?? []),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<int> rssiStream(
      {Duration frequency = const Duration(seconds: 5),
      int? maxItems = null}) async* {
    var isConnected = true;
    final subscription = device.connectionState.listen((v) {
      isConnected = v == UnlockdBluetoothConnectionState.connected;
    });
    int i = 0;
    while (isConnected && (maxItems == null || i < maxItems)) {
      try {
        yield await device.readRssi();
      } catch (e) {
        print("Error reading RSSI: $e");
        break;
      }
      await Future.delayed(frequency);
      i++;
    }
    // Device disconnected, stopping RSSI stream
    subscription.cancel();
  }
}

String prettyException(String prefix, dynamic e) {
  if (e is UnlockdBluetoothException) {
    return "$prefix ${e.description}";
  } else if (e is PlatformException) {
    return "$prefix ${e.message}";
  }
  return prefix + e.toString();
}
