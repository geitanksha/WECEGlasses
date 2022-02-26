
// Base device screen class
import 'package:wece_glasses/device_screens/empty_screen.dart';
import 'package:wece_glasses/device_screens/time_screen.dart';
import 'package:wece_glasses/device_screens/music_screen.dart';
abstract class DeviceScreen {
  void startScreen();
  void stopScreen(); 
}

class DeviceScreenHandler {
  // TODO add external handling for screen selection
  List<DeviceScreen> screens = [EmptyScreen(), TimeScreen(),MusicScreen()];
  int currentScreenIdx = 0;
  late DeviceScreen currentScreen;

  DeviceScreenHandler() {
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
    currentScreen.stopScreen();

    currentScreenIdx = (currentScreenIdx == screens.length - 1) ? 0 : currentScreenIdx+1;
    currentScreen = screens[currentScreenIdx];
    currentScreen.startScreen();
  }
}