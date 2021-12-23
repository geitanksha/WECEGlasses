// Global variables
// Not sure if this is best practice -- there may be a better way
import 'package:flutter_blue/flutter_blue.dart';

final flutterBlue = FlutterBlue.instance;

List<BluetoothDevice> deviceList = [];
BluetoothDevice? connectedDevice;
List<BluetoothService> services = [];
