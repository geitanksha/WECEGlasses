import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:wece_glasses/globals.dart';

class UseLocation  {
  // Link to weather forecast
  final String forecast;

  //var gridX;
  //var gridY;

  UseLocation(this.forecast);

  UseLocation.fromJson(Map<String, dynamic> json)
      : forecast = json["properties"]["forecast"];
//gridX = json["properties"]["gridX"],
//gridY = json["properties"]["gridY"];
} // class Location

  //String url = "https://api.weather.gov/points/"+ currentLocation.latitude.toString() + "," + currentLocation.longitude.toString();
  //print(url);

String link = "";
Future<String> fetchLocation() async {

  var currentLocation = await location.getLocation();

  String url = "https://api.weather.gov/points/"+ currentLocation.latitude.toString() + "," + currentLocation.longitude.toString();
  final response = await http
      .get(Uri.parse("https://api.weather.gov/points/"+ currentLocation.latitude.toString() + "," + currentLocation.longitude.toString()));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    UseLocation useLocation =  UseLocation.fromJson(jsonDecode(response.body));
    link = useLocation.forecast;
    return link;

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}