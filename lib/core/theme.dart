import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primaryColor = Color(0xFF2C1810);
  static const Color _accentColor = Color(0xFFC5A059);
  static const Color _backgroundColor = Color(0xFFF5F5DC);
  static const Color _surfaceColor = Color(0xFFE6DCC3);
  static const Color _textColor = Color(0xFF1A1A1A);

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: const Color(0xFF3E2723),
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF3E2723),
      secondary: Color(0xFFC5A059),
      surface: Color(0xFFFFFFFF),
      background: Color(0xFFFAFAFA),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF212121),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Cinzel',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF3E2723),
        letterSpacing: 1.0,
      ),
      iconTheme: IconThemeData(color: Color(0xFFC5A059)),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFFFFFFFF),
      elevation: 2,
      shadowColor: Color(0xFFC5A059).withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFC5A059), width: 0.5),
      ),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontFamily: 'Cinzel',
        color: Color(0xFF3E2723),
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Cinzel',
        color: Color(0xFF3E2723),
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF424242),
        height: 1.5,
        fontSize: 16,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFFFFFF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFC5A059), width: 2),
      ),
      hintStyle: const TextStyle(color: Colors.grey),
      prefixIconColor: const Color(0xFFC5A059),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFFC5A059),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3E2723),
        foregroundColor: const Color(0xFFC5A059),
        elevation: 4,
        shadowColor: const Color(0xFF3E2723).withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Cinzel',
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    ),
  );
}
