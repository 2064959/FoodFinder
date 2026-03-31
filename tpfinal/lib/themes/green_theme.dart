import 'package:flutter/material.dart';
import 'package:tpfinal/util/app_constants.dart';


ThemeData foodFinderTheme() {
  return ThemeData(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppConstants.secondaryGreen,
      selectedItemColor: AppConstants.primaryGreen,
      unselectedItemColor: Color.fromARGB(255, 83, 83, 83),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppConstants.white,
      titleTextStyle: TextStyle(
        color: AppConstants.black,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    primaryColor: AppConstants.white,
    primaryIconTheme: const IconThemeData(
      color: AppConstants.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppConstants.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppConstants.white)),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color.fromARGB(255, 255, 199, 194),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 94, 94, 94),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppConstants.primaryGreen,
      foregroundColor: AppConstants.white,
    ),
    cardTheme: CardTheme(
      color: const Color.fromARGB(255, 246, 167, 197),
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
    ),
    drawerTheme: DrawerThemeData(
      elevation: AppConstants.drawerElevation.toDouble(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
    ),
  );
}

