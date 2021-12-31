import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:wece_glasses/device_screens/screen_handler.dart';
import 'package:wece_glasses/globals.dart';
import 'package:wece_glasses/constants.dart';


// Bluetooth connection screen

class BluetoothConnectScreen extends StatefulWidget {
  const BluetoothConnectScreen({Key? key}) : super(key: key);

  @override
  State<BluetoothConnectScreen> createState() => _BluetoothConnectScreen();
}

class _BluetoothConnectScreen extends State<BluetoothConnectScreen> {
  final flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> deviceList = [];

  @override
  void initState() {
    super.initState();
    Future(() {
      updateDeviceList();
    });
  }

  Future<void> updateDeviceList() async {
    // TODO Handle exception when scan is already in progress
    await flutterBlue.startScan(timeout: const Duration(seconds: 4));
    List<BluetoothDevice> temp = [];
    flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        if (!temp.contains(device)) {
          temp.add(device);
        }
      }
    });
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        if (!temp.contains(result.device)) {
          temp.add(result.device);
        }
      }
    });
    setState(() {
      deviceList = temp;
    });
  }

  Future<void> connectDevice(BluetoothDevice device) async {
    try {
      await device.connect();
    } on PlatformException catch(e) {
      if (e.code != 'already_connected') {
        rethrow;
      }
    }

    connectedDevice = device;
    services = await device.discoverServices();

    deviceScreenHandler.start();

    // Exit screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect a Device'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
          onRefresh: updateDeviceList,
          child: ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: deviceList.map((device) {
              return Card(
                child: ListTile(
                  title: Text(device.name + " (" + device.id.toString() + ")"),
                  trailing: TextButton(
                    onPressed: () => connectDevice(device),
                    child: const Text("Connect"),
                  ),
                ),
              );
            }).toList(),
          ),
      ),
    );
  }
}



void bluetoothWrite(text) {
  for (BluetoothService service in services) {
    for (BluetoothCharacteristic characteristic in service.characteristics) {
      if (characteristic.uuid.toString() == Constants.uuid) {
        characteristic.write(utf8.encode(text));
        return;
      }
    }
  }
}