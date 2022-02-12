import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:wece_glasses/UseLocation.dart';
import 'package:wece_glasses/LocationAccess.dart';
import 'package:intl/intl.dart';
import 'package:wece_glasses/device_screens/screen_handler.dart';
import 'package:wece_glasses/globals.dart';

//need temperature
//need detailedForecast

class Weather extends DeviceScreen  {

  Timer? _timer;

  @override
  void startScreen() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => fetchWeather());
  }

  @override
  void stopScreen() {
    _timer!.cancel();
  }

  final int temperature;
  final String detailedForecast;

  Weather(this.temperature, this.detailedForecast);

  Weather.fromJson(Map<String, dynamic> json)
      : temperature = json["properties"]["periods"][0]['temperature'],
        detailedForecast = json["properties"]["periods"][0]['detailedForecast'];

} // class Weather

Future<Weather> fetchWeather() async {

  final response = await http
      .get(Uri.parse(fetchLocation().toString()));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print("cloud clicked");
    Weather weather =  Weather.fromJson(jsonDecode(response.body));
    bleHandler.bluetoothWrite(weather.temperature);
    bleHandler.bluetoothWrite(weather.detailedForecast);
    return weather;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
