import 'package:flutter/material.dart';
import 'package:wece_glasses/bluetooth.dart';
import 'globals.dart';
import 'bluetooth_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    bleHandler = BLEHandler(setStateCallback);
  }

  void setStateCallback() {
    setState((){});
  }

  void connectDevicePrompt() {
    // Show prompt for connecting a device
    Future<void> future = showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return const BluetoothConnectScreen();
        });
    // When bottom sheet is closed, call setState so main screen updates
    // future.then((void value) => setState(() {}));
  }

  void disconnectDevice() {
    setState(() {
      deviceScreenHandler.stop();
      bleHandler.disconnect();
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
            Text(bleHandler.connectedDevice == null
                ? "Please connect a device"
                : bleHandler.connectedDevice!.name),
            ElevatedButton(
              onPressed:
                  bleHandler.connectedDevice == null ? connectDevicePrompt : disconnectDevice,
              child: Text(bleHandler.connectedDevice == null ? "Connect" : "Disconnect"),
            ),
            // TODO Add rest of user functionality (settings, etc.) here
            if (bleHandler.connectedDevice != null)
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
