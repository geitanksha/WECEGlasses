// Global variables
// Not sure if this is best practice -- there may be a better way
import 'package:flutter_blue/flutter_blue.dart';
import 'package:wece_glasses/device_screens/screen_handler.dart';
import 'package:wece_glasses/bluetooth_handler.dart';

late final DeviceScreenHandler deviceScreenHandler = DeviceScreenHandler();
//late final BLEHandler bleHandler = BLEHandler();
late final BLEHandler bleHandler;