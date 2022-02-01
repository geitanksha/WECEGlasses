// Global variables
// Not sure if this is best practice -- there may be a better way
import 'package:flutter_blue/flutter_blue.dart';
import 'package:wece_glasses/bluetooth.dart';
import 'package:wece_glasses/device_screens/screen_handler.dart';

BluetoothDevice? connectedDevice;
List<BluetoothService> services = [];
late final DeviceScreenHandler deviceScreenHandler = DeviceScreenHandler();
late final BLEHandler bleHandler = BLEHandler();