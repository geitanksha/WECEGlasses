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

  loopElements() {
    List<Icon> allIcons = [];
    for (int i = 0; i < deviceScreenHandler.screens.length; i++) {
      allIcons.add(deviceScreenHandler.screens[i].getIcon());
    }
    return allIcons;
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
                onPressed: connectedDevice == null
                    ? connectDevicePrompt
                    : disconnectDevice,
                child: Text(connectedDevice == null ? "Connect" : "Disconnect"),
              ),
              if (connectedDevice != null)
                // Temporary to test screen changes
                ElevatedButton(
                    onPressed: () => deviceScreenHandler.nextScreen(),
                    child: const Text("Next Screen")),
              if (connectedDevice != null)
                ToggleButtons(
                  children: loopElements(),
                  isSelected: deviceScreenHandler.displayScreenOn,
                  onPressed: (int index) {
                    int count = 0;
                    for (var val in deviceScreenHandler.displayScreenOn) {
                      if (val) count++;
                    }

                    // At least one screen should be selected at all times
                    if (deviceScreenHandler.displayScreenOn[index] && count < 2) {
                      return;
                    }

                    // Note that if the current screen is deselected,
                    // it will only take effect once user moves to next screen
                    setState(() {
                      deviceScreenHandler.displayScreenOn[index] =
                          !deviceScreenHandler.displayScreenOn[index];
                    }); //setState
                  },
                ),
            ]),
      ),
    );
  }
}
