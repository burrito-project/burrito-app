import 'package:flutter/material.dart';

const Map<String, Color> colorThemes = {
  'primary': Color(0xfff8fafb),
  'backgroundBlack': Color(0xFF171920),
  'surface': Color.fromARGB(255, 255, 255, 255),
  'surfaceContainer': Color.fromARGB(255, 39, 41, 43),
  'accent': Color(0xFF74777C),
  'secondary': Color.fromARGB(255, 24, 24, 24),
  'onSecondary': Color.fromARGB(255, 155, 155, 155),
  'tertiary': Color(0xFFC3D1E4),
  'backgroundError': Color(0xFFF7D7DA),
  'highlight': Color(0xFF78262E),
  'danger': Color(0xFFDC1200),
  'white': Colors.white,
  'black': Colors.black,
};

class BurritoMobileTheme {
  static ThemeData theme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: colorThemes['primary']!,
      onPrimary: colorThemes['black']!,
      secondary: colorThemes['secondary']!,
      onSecondary: colorThemes['onSecondary']!,
      tertiary: colorThemes['tertiary']!,
      error: colorThemes['danger']!,
      onError: colorThemes['primary']!,
      surface: colorThemes['surface']!,
      onSurface: colorThemes['accent']!,
      surfaceContainer: colorThemes['surfaceContainer']!,
    ),
    hintColor: const Color.fromARGB(255, 102, 102, 102),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'OpenSans',
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'OpenSans',
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontFamily: 'OpenSans',
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
      titleMedium: TextStyle(
        fontFamily: 'OpenSans',
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
      titleSmall: TextStyle(
        fontFamily: 'OpenSans',
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      labelLarge: TextStyle(
        fontFamily: 'OpenSans',
        color: Colors.white,
        fontWeight: FontWeight.normal,
        fontSize: 15,
      ),
      labelMedium: TextStyle(
        fontFamily: 'OpenSans',
        color: Colors.white,
      ),
      labelSmall: TextStyle(
        fontFamily: 'OpenSans',
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
          fontFamily: 'OpenSans',
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 17),
      bodyMedium: TextStyle(
        fontFamily: 'OpenSans',
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: 15,
      ),
      bodySmall: TextStyle(
        fontFamily: 'OpenSans',
        color: Colors.white,
        fontWeight: FontWeight.w300,
        fontSize: 12,
      ),
    ),
    scrollbarTheme: const ScrollbarThemeData(
      radius: Radius.circular(10),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
  );
}
