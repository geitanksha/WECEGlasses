import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:wece_glasses/globals.dart';
import 'dart:convert';
import 'package:wece_glasses/constants.dart';


class BLEHandler {
  late StreamSubscription notificationSubscription;
  late StreamSubscription connectionStateSubscription;
  List<BluetoothService> services = [];
  Function setState;
  BluetoothDevice? connectedDevice;

  // Constructor
  BLEHandler(this.setState);

  Future<void> connect(BluetoothDevice device) async {
    // TODO Add handling for device side disconnect
    try {
      await device.connect();
    } on PlatformException catch(e) {
      if (e.code != 'already_connected') {
        rethrow;
      }
    }

    connectedDevice = device;
    setState();

    services = await device.discoverServices();

  }

  void subscribeNotifications() async {
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if(characteristic.properties.notify) {
          await characteristic.setNotifyValue(true);
          notificationSubscription = characteristic.value.listen((value) async {
            // Currently moves to next screen on any input
            deviceScreenHandler.nextScreen();
          });
          await Future.delayed(const Duration(milliseconds: 500));
          return;
        }
      }
    }
  }

  void bluetoothWrite(text) async {
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == Constants.uuid) {
            await characteristic.write(utf8.encode(text), withoutResponse: true);
            return;
        }
      }
    }
  }

  void disconnect() {
    notificationSubscription.cancel();
    if(connectedDevice != null) {
      connectedDevice!.disconnect();
      connectedDevice = null;
    }
  }
}