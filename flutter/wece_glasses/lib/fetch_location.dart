import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

var location = Location();

class UseLocation  {
  final String forecast;

  //var gridX;
  //var gridY;

  UseLocation(this.forecast);

  UseLocation.fromJson(Map<String, dynamic> json)
      : forecast = json["properties"]["forecast"];
//gridX = json["properties"]["gridX"],
//gridY = json["properties"]["gridY"];
} // class Location

Future<String> fetchLocation() async {

  LocationData currentLocation = await location.getLocation();

  final response = await http
      .get(Uri.parse('https://api.weather.gov/points/'+ currentLocation.longitude.toString() +',' + currentLocation.longitude.toString()));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    UseLocation location =  UseLocation.fromJson(jsonDecode(response.body));
    return location.forecast;

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}