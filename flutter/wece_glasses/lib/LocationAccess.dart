import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
 import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class LocationAccess {

  var location = new Location();

  void locationAccess() async {
     bool serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();

      if (!serviceEnabled) {
        return;
      }
    }
     PermissionStatus permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

}