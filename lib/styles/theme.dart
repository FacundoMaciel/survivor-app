import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData.dark().copyWith(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFF1A1A1A), // fondo gris oscuro
  cardColor: const Color(0xFF2C2C2C), // cards gris
  colorScheme: const ColorScheme.dark().copyWith(
    primary: Colors.orangeAccent, // acento principal
    secondary: Colors.orangeAccent,
    surface: const Color(0xFF2C2C2C),
    background: const Color(0xFF1A1A1A),
    error: Colors.redAccent,
  ),

  /// AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),

  /// Textos
  textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ).copyWith(
        titleLarge: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: Colors.white70,
        ),
        labelLarge: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.orangeAccent,
        ),
      ),

  /// Botones elevados
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orangeAccent,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  /// Snackbars
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.black87,
    contentTextStyle: TextStyle(color: Colors.white),
    behavior: SnackBarBehavior.floating,
  ),

  /// TabBar
  tabBarTheme: const TabBarThemeData(
    indicatorColor: Colors.orangeAccent,
    labelColor: Colors.orangeAccent,
    unselectedLabelColor: Colors.white70,
    labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  ),

  /// Dividers
  dividerColor: Colors.grey,
);
