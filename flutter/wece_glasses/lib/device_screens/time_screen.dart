import 'dart:async';
import 'package:flutter/material.dart';
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
  @override
    IconData getIcon() {
      return Icons.access_time;
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String _timeString = _formatDateTime(now);
    bleHandler.bluetoothWrite(_timeString, getScreenNum());
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MM/dd/yy\nhh:mm').format(dateTime);
  }

  @override
  int getScreenNum() {
    return 1;
  }
}



