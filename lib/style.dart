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
    secondaryContainer: Color(0xFFF4EAD4),
    surface: Color(0xFFEFDFBB),
    tertiary: Color(0xFFC1856D),
    inversePrimary: Color(0xFF63A361), // For success button
    error: Color(0xFFAD2424),
    errorContainer: Colors.red.shade300,
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontFamily: fontNameHeadline,
      fontWeight: FontWeight.bold,
      fontSize: 28.0,
    ),
    headlineMedium: GoogleFonts.prozaLibre(
      fontSize: 26,
      fontWeight: FontWeight.w700,
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
    labelSmall: TextStyle(
      fontFamily: fontNameDefault,
      fontWeight: FontWeight.normal,
      fontSize: 12.0,
    )
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF722F37),
    foregroundColor: Color(0xFFE6CFA9),
    titleTextStyle: GoogleFonts.prozaLibre(
      color: Color(0xFFE6CFA9),
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    toolbarTextStyle: GoogleFonts.prozaLibre(
      color: Color(0xFFE6CFA9),
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
  useMaterial3: true,
);
