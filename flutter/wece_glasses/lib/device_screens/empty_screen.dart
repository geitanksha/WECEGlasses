import 'package:wece_glasses/device_screens/screen_handler.dart';
import 'package:wece_glasses/globals.dart';

class EmptyScreen extends DeviceScreen {
  @override
  void startScreen() {
    bleHandler.bluetoothWrite("");
  }

  @override
  void stopScreen() {}
}