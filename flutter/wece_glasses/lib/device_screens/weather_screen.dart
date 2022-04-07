import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wece_glasses/fetch_location.dart';
import 'package:wece_glasses/device_screens/screen_handler.dart';
import 'package:wece_glasses/globals.dart';


class WeatherScreen extends DeviceScreen  {

  Timer? _timer;
  String cachedTemp = "Loading";

  @override
  void startScreen() {
    // Generating initial weather report takes some time
    int mode = cachedTemp == "Loading" ? 1 : 0;
    bleHandler.bluetoothWrite(cachedTemp, getScreenNum(), mode);
    // To make sure it starts immediately
    fetchWeather();
    // Refresh every 30 minutes after that
    _timer = Timer.periodic(const Duration(minutes: 30), (Timer t) => fetchWeather());
  }

  @override
  void stopScreen() {
    _timer!.cancel();
  }

  @override
  IconData getIcon() {
    return Icons.cloud;
  }

  void fetchWeather() async {
    Future<String> forecast = fetchLocation();

    forecast.then((String urlWeather) async {
      final response = await http
          .get(Uri.parse(urlWeather.toString()));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response, then parse the JSON.
        Weather weather =  Weather.fromJson(jsonDecode(response.body));
        cachedTemp = weather.temperature.toString();
        bleHandler.bluetoothWrite(cachedTemp, getScreenNum());
      } else {
        // If the server did not return a 200 OK response, then throw an exception.
        bleHandler.bluetoothWrite("Not available", getScreenNum(), 1);
      }
    });
  }

  @override
  int getScreenNum() {
    return 2;
  }

}

/// Reads relevant fields from weather api json response
class Weather {
  final int temperature;
  final String shortForecast;

  Weather(this.temperature, this.shortForecast);

  Weather.fromJson(Map<String, dynamic> json)
      : temperature = json["properties"]["periods"][0]['temperature'],
        shortForecast = json["properties"]["periods"][0]['shortForecast'];
}

