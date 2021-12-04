import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
 Here is where we will constants relating to the theme of our app, such as
 color scheme, font settings, and other UI objects as necessary
 */

class AppColors {
  /*
   Here are WECE's theme colors for 2021-2022 courtesy of marketing.
   We don't necessarily have to use these colors, but if we do they should be
   renamed appropriately. Leaving them here for reference.
  */
  // Flutter colors are RGB color codes prefixed with an opacity value.
  // The FF represents full opacity


  static const blue = Color(0xFF022B3A);
  static const pink = Color(0xFFE83E8C) ;
  static const green = Color(0xFF78C178);
  static const white = Color(0xFDFFFFFF);
}

const OmbreColor = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.pink,
        AppColors.blue,
      ],
    ),
);

// ignore: non_constant_identifier_names
final AppTheme = ThemeData(
  // TODO Add AppTheme

  // See Flutter theme documentation for details
  // https://flutter.dev/docs/cookbook/design/themes
);