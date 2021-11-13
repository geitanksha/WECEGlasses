import 'package:flutter/material.dart';

title: testingtheme
theme: ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.deepPurple[800],

  fontFamily: 'Georgia',
  textTheme: const TextTheme(
  headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
  bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
)
)