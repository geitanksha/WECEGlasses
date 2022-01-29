import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wece_glasses/device_screens/screen_handler.dart';
import 'package:wece_glasses/bluetooth.dart';

class button_screen extends DeviceScreen {


  @override
  void startScreen() {

  }

  @override
  void stopScreen() {

  }
  ToggleButtons(
      children: <Widget>[
        Icon(Icons.ac_unit),
        Icon(Icons.call),
        Icon(Icons.cake),
    ],
    onPressed: (int index) {
      int count = 0;
      isSelected.forEach((bool val) {
            if (val) count++;
            });

            if (isSelected[index] && count < 2)
             return;

            setState(() {
              isSelected[index] = !isSelected[index];
        });
      },
      isSelected: isSelected,
    ),
