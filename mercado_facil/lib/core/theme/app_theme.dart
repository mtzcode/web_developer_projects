import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color produtoButtonColor = Color(0xFF005463);

  static ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF64ba01), // Primária
          onPrimary: Colors.white,
          secondary: Color(0xFF3a3a3a), // Secundária
          onSecondary: Colors.white,
          tertiary: Color(0xFF8f8f8f), // Terciária
          onTertiary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.white, // Fundo
          onBackground: Color(0xFF3a3a3a),
          surface: Color(0xFFb9b9b9), // Quartária
          onSurface: Color(0xFF3a3a3a),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      );
} 