import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//need temperature
//need detailedForecast

class Weather {
  final int temperature;
  final String detailedForecast;

  Weather(this.temperature, this.detailedForecast);

   Weather.fromJson(Map<String, dynamic> json)
      : temperature = json["properties"]["periods"][0]['temperature'],
        detailedForecast =  json["properties"]["periods"][0]['detailedForecast'];


} // class Weather

Future<Weather> fetchWeather() async {
  final response = await http
      .get(Uri.parse('https://api.weather.gov/gridpoints/TOP/40,-88/forecast'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print("cloud clicked");
    Weather weather =  Weather.fromJson(jsonDecode(response.body));
    print(weather.temperature);
    print(weather.detailedForecast);
    return weather;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
