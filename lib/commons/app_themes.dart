import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppThemes {
  static ThemeData theme = ThemeData(
    primaryColor: AppColors.mainColor,
    primaryTextTheme: TextTheme(button: TextStyle(color: Colors.white)),
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Roboto',
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.grey,
      selectionHandleColor: AppColors.mainColor,
    ),
  );
}
