import 'package:flutter/material.dart';

class AppConstants {
  // Colors - Main Palette
  static const Color primaryGreen = Color(0xFF00AD48);
  static const Color secondaryGreen = Color(0xFFEBF3EE);
  static const Color primaryOrange = Color(0xFFFF7643);
  static const Color highlightOrange = Color(0xFFFF4848);

  // Neutral Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color black87 = Colors.black87;
  static const Color lightGrey = Color(0xFFDBDEE4);
  static const Color mediumGrey = Color(0xFF979797);
  static const Color darkGrey = Color(0xFF6B6B6B);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // Layout Spacing
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Border Radii
  static const double radiusSmall = 5.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 30.0;

  // Specific Widget Constants
  static const double productCardWidth = 175.0;
  static const double productCardHeight = 260.0;
  static const double productCardAspectRatio = 1.02;
  static const double productDetailImageAspectRatio = 1.4;

  // Standard Configurations
  static const int popularProductsLimit = 100;
  static const int drawerElevation = 10;

  // Asset Paths (if any)
  static const String placeholderImage = 'assets/images/no-photo.png';
}
