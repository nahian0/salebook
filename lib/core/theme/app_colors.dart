import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFE74C3C); // Red
  static const Color primaryLight = Color(0xFFFFE6E0);
  static const Color primaryDark = Color(0xFFC0392B);

  // Background Colors
  static const Color background = Color(0xFFFAF6F1); // Warm Beige
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color surfaceVariant = Color(0xFFFAF6F1); // Light Beige
  static const Color appBarBackground = Color(0xFFE8DCC8); // Tan

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A); // Dark Gray
  static const Color textSecondary = Color(0xFF666666); // Medium Gray
  static const Color textTertiary = Color(0xFF999999); // Light Gray

  // Feature Card Colors
  static const Color stockColor = Color(0xFF4CAF50); // Green
  static const Color salesColor = Color(0xFFE74C3C); // Red
  static const Color customersColor = Color(0xFFF39C12); // Orange
  static const Color reportsColor = Color(0xFF3498DB); // Blue
  static const Color paymentsColor = Color(0xFF9B59B6); // Purple
  static const Color analyticsColor = Color(0xFF1ABC9C); // Teal
  static const Color settingsColor = Color(0xFF34495E); // Dark Blue-Gray

  // Menu Item Colors
  static const Color settingsMenuColor = Color(0xFF9B59B6); // Purple
  static const Color profileMenuColor = Color(0xFF1ABC9C); // Teal
  static const Color aboutMenuColor = Color(0xFFF39C12); // Orange
  static const Color helpMenuColor = Color(0xFFE91E63); // Pink

  // Status Colors
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color warning = Color(0xFFF39C12); // Orange
  static const Color error = Color(0xFFE74C3C); // Red
  static const Color errorLight = Color(0xFFFFEBEE); // Light Red
  static const Color info = Color(0xFF3498DB); // Blue

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF0F0F0);
  static const Color borderMedium = Color(0xFFD1D5DB);
  static const Color divider = Color(0xFFF5F5F5);

  // Shadow Colors
  static Color shadowLight = Colors.black.withOpacity(0.05);
  static Color shadowMedium = Colors.black.withOpacity(0.1);
  static Color shadowDark = Colors.black.withOpacity(0.2);

  // Badge Colors
  static const Color badgeBackground = Color(0xFFE74C3C);
  static const Color badgeText = Color(0xFFFFFFFF);

  // Helper method to get light version of a color
  static Color getLightColor(Color color) {
    return color.withOpacity(0.15);
  }

  // Helper method to get color for menu items
  static Color getMenuIconColor(String menuType) {
    switch (menuType.toLowerCase()) {
      case 'settings':
        return settingsMenuColor;
      case 'profile':
        return profileMenuColor;
      case 'about':
        return aboutMenuColor;
      case 'help':
        return helpMenuColor;
      default:
        return primary;
    }
  }

  // Helper method to get light background for menu items
  static Color getMenuBackgroundColor(String menuType) {
    return getLightColor(getMenuIconColor(menuType));
  }
}