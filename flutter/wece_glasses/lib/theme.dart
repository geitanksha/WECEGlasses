import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
 Here is where we will constants relating to the theme of our app, such as
 color scheme, font settings, and other UI objects as necessary
 */

class AppColors {
  // Flutter colors are RGB color codes prefixed with an opacity value.
  // The FF represents full opacity
  static const darkBlue = Color(0xFF022B3A);
  static const lightBlue = Color(0xFFB2BEC1);
  static const pink = Color(0xFFC75E61);
  static const red = Color(0xFF8F2220);
  static const green = Color(0xFF78C178);
  static const white = Color(0xFDFFFFFF);
}

ColorScheme colorScheme = const ColorScheme.dark(
  primary: AppColors.pink,
  primaryVariant: AppColors.red,
  secondary: AppColors.green,
  secondaryVariant: AppColors.green,
  surface: AppColors.darkBlue,
  background: AppColors.darkBlue,
);
final appTheme = ThemeData.from(
    colorScheme: colorScheme
);

// Gradient for home screen background
const gradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.pink,
        AppColors.darkBlue,
      ],
    ),
);
