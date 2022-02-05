import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
//need temperature
//need detailedForecast

class Weather {
  var location = new Location();
  PermissionStatus permissionGranted;
  LocationData locationData;
 void locationAccess() async {



    bool serviceEnabled = await location.serviceEnabled();

    if(!serviceEnabled){
      serviceEnabled = await location.requestService();

      if(!serviceEnabled){
        return;
      }
    }
    permissionGranted = await location.hasPermission();

    if(permissionGranted == PermissionStatus.denied){
        permissionGranted = await location.requestPermission();
      if(permissionGranted != PermissionStatus.granted){
        return;
      }
    }
  }

  Future<String> fetchLocation() async{

    var currentLocation = await location.getLocation();

    var latitude = locationData.latitude;
    var longitude = locationData.longitude;

    var forecast;
    var gridX;
    var gridY;

    LocationURL.fromJson(Map<String, dynamic> json)
        : forecast = json["properties"]["forecast"],
          gridX = json["properties"]["gridX"],
          gridY = json["properties"]["gridY"];

    final response = await http
        .get(Uri.parse('https://api.weather.gov/points/'+ latitude +',' + longitude));
    if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        return forecast;

    } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
    }
  }

  final int temperature;
  final String detailedForecast;

  Weather(this.temperature, this.detailedForecast);

  Weather.fromJson(Map<String, dynamic> json)
      : temperature = json["properties"]["periods"][0]['temperature'],
        detailedForecast = json["properties"]["periods"][0]['detailedForecast'];

} // class Weather

Future<Weather> fetchWeather(String url) async {
  fetchLocation();
  final response = await http
      .get(Uri.parse(url));

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
