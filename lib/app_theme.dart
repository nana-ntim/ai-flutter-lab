import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary color palette - elegant purple gradient
  static const Color primaryColor = Color(0xFF8A2BE2);
  static const Color secondaryColor = Color(0xFF5D3FD3);
  static const Color accentColor = Color(0xFFE2A8FE);

  // Background colors
  static const Color backgroundColor = Color(0xFFF8F9FE);
  static const Color darkBackgroundColor = Color(0xFF1A1A2E);

  // Chat bubble colors
  static const Color userBubbleColor = Color(0xFFE9EFFF);
  static const Color botBubbleColor = Color(0xFFF0E6FF);

  // Text colors
  static const Color primaryTextColor = Color(0xFF2D2D3A);
  static const Color secondaryTextColor = Color(0xFF6E6E82);
  static const Color lightTextColor = Color(0xFFF0F0F5);

  // Card and container styling
  static final BorderRadius defaultBorderRadius = BorderRadius.circular(16);
  static const double defaultPadding = 16.0;

  // Shadow for elevation effect
  static List<BoxShadow> get subtleShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  // Glass effect
  static BoxDecoration get glassEffect => BoxDecoration(
    color: Colors.white.withOpacity(0.7),
    borderRadius: defaultBorderRadius,
    border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
    boxShadow: subtleShadow,
  );

  // Text styles with Google Fonts
  static TextStyle get headingStyle => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryTextColor,
  );

  static TextStyle get subheadingStyle => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: primaryTextColor,
  );

  static TextStyle get bodyStyle =>
      GoogleFonts.poppins(fontSize: 16, color: primaryTextColor);

  static TextStyle get captionStyle =>
      GoogleFonts.poppins(fontSize: 13, color: secondaryTextColor);

  // Create the theme data
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        background: backgroundColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryTextColor,
        ),
        bodyLarge: GoogleFonts.poppins(fontSize: 16, color: primaryTextColor),
        bodyMedium: GoogleFonts.poppins(fontSize: 14, color: primaryTextColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}
