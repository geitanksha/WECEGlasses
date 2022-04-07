
// Base device screen class
import 'package:flutter/material.dart';
import 'package:wece_glasses/device_screens/empty_screen.dart';
import 'package:wece_glasses/device_screens/time_screen.dart';
import 'package:wece_glasses/device_screens/weather_screen.dart';
import 'package:wece_glasses/device_screens/game_screen.dart';

abstract class DeviceScreen {
  void startScreen();
  void stopScreen();
  IconData getIcon();
  int getScreenNum();
}

class DeviceScreenHandler {
  final List<DeviceScreen> screens = [TimeScreen(), WeatherScreen(), GameScreen(), EmptyScreen()];
  // Init in constructor
  late int currentScreenIdx;
  late List<bool> displayScreenOn;
  late DeviceScreen currentScreen;

  DeviceScreenHandler() {
    // TODO save state on app close and reuse
    displayScreenOn = List.filled(screens.length, true);
    currentScreenIdx = 0;
    currentScreen = screens[currentScreenIdx];
  }

  void start() {
    currentScreen.startScreen();
  }

  void stop() {
    currentScreen.stopScreen();
  }

  /// Start sending data for next device screen.
  void nextScreen() {
    // Find next valid screen
    int nextScreenIdx = _nextTrueIdx(currentScreenIdx);

    if(nextScreenIdx != currentScreenIdx) {
      currentScreen.stopScreen();
      currentScreenIdx = nextScreenIdx;
      currentScreen = screens[currentScreenIdx];
      currentScreen.startScreen();
    }
  }

  int _nextTrueIdx(int current) {
    if(current != displayScreenOn.length - 1) {
      for(int i = current + 1; i < displayScreenOn.length; i++) {
        if(displayScreenOn[i]) {
          return i;
        }
      }
    }

    // This is safe because we can assume there will always be at least one valid index
    return displayScreenOn.indexWhere((x) => x == true);
  }
}