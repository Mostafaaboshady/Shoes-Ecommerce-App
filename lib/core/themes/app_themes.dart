import 'package:final_project/core/constants/colors.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundAppbar,
    primaryColor: AppColors.primaryBlue,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundAppbar,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.black),
      titleTextStyle: TextStyle(
          color: AppColors.black, fontSize: 20, fontWeight: FontWeight.w600),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryBlue,
      secondary: AppColors.lightBlue,
      surface: AppColors.white,
      onSurface: AppColors.black,
      background: AppColors.backgroundAppbar,
      error: AppColors.red,
    ),
    iconTheme: const IconThemeData(color: AppColors.black),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.black),
      bodyMedium: TextStyle(color: AppColors.grey),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.sideMenu,
    primaryColor: AppColors.lightBlue,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.sideMenu,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.white),
      titleTextStyle: TextStyle(
          color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w600),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.lightBlue,
      secondary: AppColors.lightOrange,
      surface: AppColors.surface,
      onSurface: AppColors.white,
      background: AppColors.sideMenu,
      error: AppColors.red,
    ),
    iconTheme: const IconThemeData(color: AppColors.white),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.white),
      bodyMedium: TextStyle(color: AppColors.lightGrey),
    ),
  );
}
