import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wece_glasses/device_screens/screen_handler.dart';
import 'package:notifications/notifications.dart';
import 'package:wece_glasses/globals.dart';

class AndroidSMSScreen extends DeviceScreen {

  final Notifications _notifications = Notifications();
  late StreamSubscription _smsSubscription;

  @override
  IconData getIcon() {
    return Icons.message;
  }

  @override
  void startScreen() {
    bleHandler.bluetoothWrite("");
    print("*******Start Screen********");
    try {
      _smsSubscription = _notifications.notificationStream!.listen(onData);
    } on NotificationException catch (exception) {
      print("AN EXCEPTION!!!");
      print(exception);

    }
  }

  @override
  void stopScreen() {
    // TODO: It may be preferable to just pause the subscription here and find another place to cancel it altogether
    _smsSubscription.cancel();
  }

  void onData(NotificationEvent event) {
    String title = event.title == null ? "" : event.title.toString() + "\n";
    String message = event.message == null ? "" : event.message.toString();
    bleHandler.bluetoothWrite(title);
    bleHandler.bluetoothWrite(message);
    print("*********This is the notification***********" + title + "\n" + message);
    print("*********************EVENT**********" + event.toString());
  }
}
