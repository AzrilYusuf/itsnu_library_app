// This is the file where you can add your own styles to the app.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String? fontNameHeadline = GoogleFonts.prozaLibre().fontFamily;
String? fontNameDefault = GoogleFonts.poppins().fontFamily;

ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFFEFDFBB),
    primary: Color(0xFFE6CFA9),
    secondary: Color(0xFF722F37),
    surface: Color(0xFFEFDFBB),
    tertiary: Color(0xFFC1856D),
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontFamily: fontNameHeadline,
      fontWeight: FontWeight.bold,
      fontSize: 28.0,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontNameHeadline,
      fontWeight: FontWeight.bold,
      fontSize: 26.0,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontNameHeadline,
      fontWeight: FontWeight.bold,
      fontSize: 24.0,
    ),
    titleLarge: TextStyle(
      fontFamily: fontNameDefault,
      fontWeight: FontWeight.bold,
      fontSize: 22.0,
    ),
    titleMedium: TextStyle(
      fontFamily: fontNameDefault,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
    titleSmall: TextStyle(
      fontFamily: fontNameDefault,
      fontWeight: FontWeight.bold,
      fontSize: 18.0,
    ),
    bodyLarge: TextStyle(
      fontFamily: fontNameDefault,
      fontWeight: FontWeight.normal,
      fontSize: 18.0,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontNameDefault,
      fontWeight: FontWeight.normal,
      fontSize: 16.0,
    ),
    bodySmall: TextStyle(
      fontFamily: fontNameDefault,
      fontWeight: FontWeight.normal,
      fontSize: 14.0,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF722F37),
    foregroundColor: Color(0xFFE6CFA9),
  ),
  useMaterial3: true,
);
