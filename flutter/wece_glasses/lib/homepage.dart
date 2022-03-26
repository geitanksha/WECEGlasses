import 'package:flutter/material.dart';
import 'package:wece_glasses/bluetooth.dart';
import 'package:wece_glasses/theme.dart';
import 'globals.dart';
import 'theme.dart';
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
    setState(() {});
  }

  void connectDevicePrompt() {
    // Show prompt for connecting a device
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return const BluetoothConnectScreen();
        });
  }

  void disconnectDevice() {
    setState(() {
      deviceScreenHandler.stop();
      bleHandler.disconnect();
    });
  }

  loopElements() {
    List<Icon> allIcons = [];
    for (int i = 0; i < deviceScreenHandler.screens.length; i++) {
      allIcons.add(Icon(deviceScreenHandler.screens[i].getIcon()));
    }
    return allIcons;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: gradientDecoration,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
          ),
          body: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'lib/Image/Top_Banner.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Text(bleHandler.connectedDevice == null
                        ? "Please connect a device"
                        : bleHandler.connectedDevice!.name),

                    ElevatedButton(
                      onPressed: bleHandler.connectedDevice == null
                          ? connectDevicePrompt
                          : disconnectDevice,
                      child: Text(bleHandler.connectedDevice == null
                          ? "Connect"
                          : "Disconnect"),
                    ),
                    // TODO Add rest of user functionality (settings, etc.) here
                    if (bleHandler.connectedDevice != null)
                      // Temporary to test screen changes
                      ElevatedButton(
                          onPressed: () => deviceScreenHandler.nextScreen(),
                          child: const Text("Next Screen")),
                    if (bleHandler.connectedDevice != null)
                      Ink(
                        width: 200,
                        height: 60,
                        child: GridView.count(
                          primary: true,
                          crossAxisCount: 3,
                          //set the number of buttons in a row
                          crossAxisSpacing: 8,
                          //set the spacing between the buttons
                          childAspectRatio: 1,
                          //set the width-to-height ratio of the button,
                          //>1 is a horizontal rectangle
                          children: List.generate(
                              deviceScreenHandler.displayScreenOn.length,
                              (index) {
                            //using Inkwell widget to create a button
                            return InkWell(
                                splashColor: AppColors.pink,
                                //the default splashColor is grey
                                onTap: () {
                                  //set the toggle logic
                                  int count = 0;
                                  for (var val
                                      in deviceScreenHandler.displayScreenOn) {
                                    if (val) count++;
                                  }

                                  // At least one screen should be selected at all times
                                  if (deviceScreenHandler
                                          .displayScreenOn[index] &&
                                      count < 2) {
                                    return;
                                  }

                                  // Note that if the current screen is deselected,
                                  // it will only take effect once user moves to next screen
                                  setState(() {
                                    deviceScreenHandler.displayScreenOn[index] =
                                        !deviceScreenHandler
                                            .displayScreenOn[index];
                                  }); //setState
                                },
                                child: Ink(
                                  decoration: BoxDecoration(
                                    //set the background color of the button when it is selected/ not selected
                                    color: deviceScreenHandler
                                            .displayScreenOn[index]
                                        ? AppColors.lightBlue
                                        : Colors.white,
                                    // here is where we set the rounded corner
                                    borderRadius: BorderRadius.circular(8),
                                    //don't forget to set the border,
                                    //otherwise there will be no rounded corner
                                    border:
                                        Border.all(color: AppColors.darkBlue),
                                  ),
                                  child: Icon(
                                      deviceScreenHandler.screens[index]
                                          .getIcon(),
                                      //set the color of the icon when it is selected/ not selected
                                      color: deviceScreenHandler
                                              .displayScreenOn[index]
                                          ? AppColors.pink
                                          : Colors.grey),
                                ));
                          }),
                        ),
                      ),
                  ]))
            ],
          ),
        ));
  } //Widget build
} //_HomePageState
