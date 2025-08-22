import 'package:flutter/widgets.dart';

class CustomColors {
  // Primary colors - Dark theme with warmer, darker red schema (Material 3 inspired)
  static const Color primary = Color(0xffD32F2F); // Warmer, darker red
  static const Color primaryDark = Color(0xffB71C1C); // Deep dark red
  static const Color secondary = Color(0xffE57373); // Warm light red
  static const Color accent = Color(0xffFFFFFF); // White accent

  // Background colors - Black theme
  static const Color backgroundPrimary = Color(0xff000000); // Pure black
  static const Color backgroundSecondary = Color(0xff0D1117); // Very dark gray
  static const Color cardBackground = Color(0xff161B22); // Dark card background
  static const Color surfaceColor = Color(0xff21262D); // Surface color

  // Additional Material 3 surface colors for better contrast
  static const Color surfaceVariant =
      Color(0xff2C3235); // Slightly lighter surface
  static const Color surfaceTint =
      Color(0xffD32F2F); // Tint color matching primary

  // Text colors
  static const Color textPrimary = Color(0xffFFFFFF); // Pure white
  static const Color textSecondary = Color(0xffC9D1D9); // Light gray
  static const Color textMuted = Color(0xff8B949E); // Muted gray

  // Status colors
  static const Color success =
      Color(0xff388E3C); // Darker green for better contrast
  static const Color error =
      Color(0xffD32F2F); // Matching primary red for consistency
  static const Color warning = Color(0xffF57C00); // Warmer orange

  // Legacy colors (keeping for backward compatibility)
  static const Color blueIndicator = primary;
  static const Color backgroundScreenColor = backgroundPrimary;
  static const Color blue = primary;
  static const Color red = error;
  static const Color green = success;
  static const Color grey = textMuted;
}
