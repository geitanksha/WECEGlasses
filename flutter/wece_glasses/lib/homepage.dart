import 'package:flutter/material.dart';
import 'package:wece_glasses/bluetooth.dart';
import 'globals.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Temporary for testing
  final TextEditingController _writeController = TextEditingController();

  void connectDevicePrompt() {
    // Show prompt for connecting a device
    Future<void> future = showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return const BluetoothConnectScreen();
        });
    // When bottom sheet is closed, call setState so main screen updates
    future.then((void value) => setState(() {}));
  }

  void disconnectDevice() {
    // TODO Fix device unavailable after disconnect (until device reset) May be a device code issue.
    setState(() {
      connectedDevice!.disconnect();
      connectedDevice = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(connectedDevice == null
                ? "Please connect a device"
                : connectedDevice!.name),
            ElevatedButton(
              onPressed:
                  connectedDevice == null ? connectDevicePrompt : disconnectDevice,
              child: Text(connectedDevice == null ? "Connect" : "Disconnect"),
            ),
            // Temporary
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
                                bluetoothWrite(services, _writeController.value.text);
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
