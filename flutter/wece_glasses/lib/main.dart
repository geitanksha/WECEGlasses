import 'package:flutter/material.dart';
import 'theme.dart';
import 'constants.dart';
import 'homepage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // The app theme is defined in constants.dart
      title: Constants.appName,
      // The app theme is defined in theme.dart
      theme: AppTheme,
      // This directs the app to start at the screen class called MyHomePage.
      // Currently the main screen is the default from Flutter, but we will
      // edit the screens and screen routes as needed.
      home: const HomePage(title: Constants.appName),
    );
  }
}
