import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:wece_glasses/bluetooth.dart';
import 'globals.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Temporary for testing
  final TextEditingController _writeController = TextEditingController();

  void connectDevice() {
    // Show prompt for connecting a device
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return const BluetoothConnectScreen();
        });
  }

  void disconnectDevice() {
    // TODO implement
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(connectedDevice == null
                ? "Please connect a device"
                : connectedDevice!.name),
            ElevatedButton(
              onPressed: connectedDevice == null ? connectDevice: disconnectDevice,
              child: Text(connectedDevice == null ? "Connect": "Disconnect"),
            ),
            if (connectedDevice != null)
              ElevatedButton(
                child: Text("Write"),
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Write"),
                          content: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  controller: _writeController,
                                ),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text("Send"),
                              onPressed: () {
                                for (BluetoothService ser in services) {
                                  print(ser);
                                  for (BluetoothCharacteristic char
                                      in ser.characteristics) {
                                    char.write(utf8
                                        .encode(_writeController.value.text));
                                  }
                                }
                              },
                            ),
                            TextButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      });
                },
              ),
            // TODO Add rest of settings functionality here
          ],
        ),
      ),
    );
  }
}
