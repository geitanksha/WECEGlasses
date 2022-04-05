import 'package:flutter/material.dart';
import 'package:wece_glasses/bluetooth.dart';
import 'package:wece_glasses/device_screens/screen_handler.dart';
import 'package:wece_glasses/globals.dart';

class GameScreen extends DeviceScreen {
  // For better reaction times, all game handling is done locally on the device.
  // This is here so the app knows what's going on. 
  @override
  IconData getIcon() {
    return Icons.videogame_asset;
  }

  @override
  void startScreen() {
    bleHandler.bluetoothWrite("", getScreenNum(), 0);
  }

  @override
  void stopScreen() {}

  @override
  int getScreenNum() {
    return 3;
  }

}
