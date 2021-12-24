import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'globals.dart';

// Bluetooth connection screen

class BluetoothConnectScreen extends StatefulWidget {
  const BluetoothConnectScreen({Key? key}) : super(key: key);

  @override
  State<BluetoothConnectScreen> createState() => _BluetoothConnectScreen();
}

class _BluetoothConnectScreen extends State<BluetoothConnectScreen> {

  @override
  void initState() {
    // TODO Fix. Currently does not generate list on app open
    super.initState();
    updateDeviceList();
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
