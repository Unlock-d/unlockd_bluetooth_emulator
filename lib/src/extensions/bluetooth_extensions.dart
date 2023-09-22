import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:unlockd_bluetooth/unlockd_bluetooth.dart';

extension BluetoothAdapterStateExtension on UnlockdBluetoothAdapterState {
  static UnlockdBluetoothAdapterState fromValue(String value) {
    return UnlockdBluetoothAdapterState.values
        .firstWhere((element) => element.name == value);
  }
}

extension BluetoothDeviceTypeExtension on UnlockdBluetoothDeviceType {
  static UnlockdBluetoothDeviceType fromValue(String value) {
    return UnlockdBluetoothDeviceType.values
        .firstWhere((element) => element.name == value);
  }
}

extension BluetoothConnectionStateExtension on UnlockdBluetoothConnectionState {
  static UnlockdBluetoothConnectionState fromValue(String value) {
    return UnlockdBluetoothConnectionState.values
        .firstWhere((element) => element.name == value);
  }
}

extension AdvertisementDataExtension on UnlockdAdvertisementData {
  Json toJson() => {
        'localName': localName,
        'txPowerLevel': txPowerLevel,
        'connectable': connectable,
        'manufacturerData':
            manufacturerData.map((key, value) => MapEntry('$key', value)),
        'serviceData': serviceData,
        'serviceUuids': serviceUuids,
      };

  static UnlockdAdvertisementData fromJson(Json json) {
    return UnlockdAdvertisementData(
      localName: json['localName'] as String,
      txPowerLevel: json['txPowerLevel'] as int?,
      connectable: json['connectable'] as bool,
      manufacturerData: (json['manufacturerData'] as Json).map(
        (key, value) => MapEntry(
          int.parse(key),
          (value as List<dynamic>).map((e) => e as int).toList(),
        ),
      ),
      serviceData: (json['serviceData'] as Json).map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>).map((e) => e as int).toList(),
        ),
      ),
      serviceUuids: (json['serviceUuids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }
}

extension BluetoothServiceExtension on UnlockdBluetoothService {
  Json toJson() => {
        'service_uuid': uuid.toMac(),
        'is_primary': isPrimary ? 1 : 0,
        'remote_id': remoteId.str,
        'characteristics': characteristics.map((e) => e.toJson()).toList(),
        'included_services': includedServices.map((e) => e.toJson()).toList(),
      };

  static UnlockdBluetoothService fromJson(Json json) {
    return UnlockdBluetoothService.fromProto(BmBluetoothService.fromMap(json));
  }
}

extension BluetoothCharacteristicExtension on UnlockdBluetoothCharacteristic {
  Json toJson() => {
        'characteristic_uuid': uuid.toMac(),
        'service_uuid': serviceUuid.toMac(),
        'remote_id': remoteId.str,
        'properties': properties.toJson(),
        'descriptors': descriptors.map((e) => e.toJson()).toList(),
      };

// static UnlockdBluetoothCharacteristic fromJson(Json json) {
//   return UnlockdBluetoothCharacteristic.fromProto(
//     BmBluetoothCharacteristic.fromMap(json),
//   );
// }
}

extension BluetoothDescriptorExtension on UnlockdBluetoothDescriptor {
  Json toJson() => {
        'descriptor_uuid': uuid.toMac(),
        'characteristic_uuid': characteristicUuid.toMac(),
        'service_uuid': serviceUuid.toMac(),
        'remote_id': remoteId.str,
      };

// static UnlockdBluetoothDescriptor fromJson(Json json) {
//   return UnlockdBluetoothDescriptor.fromProto(
//     BmBluetoothDescriptor.fromMap(json),
//   );
// }
}

extension BluetoothCharacteristicPropertiesExtension
    on UnlockdCharacteristicProperties {
  Json toJson() => {
        'broadcast': broadcast ? 1 : 0,
        'read': read ? 1 : 0,
        'write_without_response': writeWithoutResponse ? 1 : 0,
        'write': write ? 1 : 0,
        'notify': notify ? 1 : 0,
        'indicate': indicate ? 1 : 0,
        'authenticated_signed_writes': authenticatedSignedWrites ? 1 : 0,
        'extended_properties': extendedProperties ? 1 : 0,
        'notify_encryption_required': notifyEncryptionRequired ? 1 : 0,
        'indicate_encryption_required': indicateEncryptionRequired ? 1 : 0
      };

// static UnlockdCharacteristicProperties fromJson(Json json) {
//   return UnlockdCharacteristicProperties(
//     broadcast: (json['broadcast'] as int) == 0,
//     read: (json['read'] as int) == 0,
//     writeWithoutResponse: (json['writeWithoutResponse'] as int) == 0,
//     write: (json['write'] as int) == 0,
//     notify: (json['notify'] as int) == 0,
//     indicate: (json['indicate'] as int) == 0,
//     authenticatedSignedWrites:
//         (json['authenticatedSignedWrites'] as int) == 0,
//     extendedProperties: (json['extendedProperties'] as int) == 0,
//     notifyEncryptionRequired: (json['notifyEncryptionRequired'] as int) == 0,
//     indicateEncryptionRequired:
//         (json['indicateEncryptionRequired'] as int) == 0,
//   );
// }
}
