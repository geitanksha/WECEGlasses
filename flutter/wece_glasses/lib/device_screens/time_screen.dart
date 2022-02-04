import 'dart:async';
import 'package:intl/intl.dart';
import 'package:wece_glasses/device_screens/screen_handler.dart';
import 'package:wece_glasses/globals.dart';


class TimeScreen extends DeviceScreen {
  Timer? _timer;

  @override
  void startScreen() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  void stopScreen() {
    _timer!.cancel();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String _timeString = _formatDateTime(now);
    bleHandler.bluetoothWrite(_timeString);
  }

  String _formatDateTime(DateTime dateTime) {
    // TODO Add full formatting info
    return DateFormat('MM/dd/yyyy hh:mm:ss').format(dateTime);
  }
}



