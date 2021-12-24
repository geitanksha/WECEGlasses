// Global variables
// Not sure if this is best practice -- there may be a better way
import 'package:flutter_blue/flutter_blue.dart';

// TODO move back to home page state
BluetoothDevice? connectedDevice;
List<BluetoothService> services = [];
