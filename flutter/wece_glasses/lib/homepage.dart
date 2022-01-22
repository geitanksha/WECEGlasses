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
    setState(() {
      deviceScreenHandler.stop();
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
            // TODO Add rest of user functionality (settings, etc.) here
            if (connectedDevice != null)
            // Temporary to test screen changes
              ElevatedButton(
                  onPressed: () => deviceScreenHandler.nextScreen(),
                  child: Text("Next Screen")
              ),
          ],
        ),
      ),
    );
  }
}
