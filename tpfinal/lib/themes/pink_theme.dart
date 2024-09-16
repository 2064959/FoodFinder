import 'package:flutter/material.dart';

ThemeData pinkTheme() {
  return ThemeData(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 151, 71, 255),
      selectedItemColor: Colors.white,
      unselectedItemColor: Color.fromARGB(255, 83, 83, 83),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white, //Color.fromARGB(255, 246, 167, 197),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    ),
    primaryColor: Colors.white, //const Color.fromARGB(255, 255, 199, 194),
    primaryIconTheme: const IconThemeData(
      color: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color.fromARGB(255, 255, 199, 194), //<-- SEE HERE
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 94, 94, 94),
        textStyle: const TextStyle(
          
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 253, 223, 114),
      ),
    ),
    cardTheme: CardTheme(
      color: const Color.fromARGB(255, 246, 167, 197),
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    drawerTheme: DrawerThemeData(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
}
