import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  // Feature Card Colors
  static const Color stockColor = Color(0xFF6366F1); // Indigo
  static const Color salesColor = Color(0xFF10B981); // Green
  static const Color customersColor = Color(0xFFF59E0B); // Orange
  static const Color reportsColor = Color(0xFF8B5CF6); // Purple
  static const Color paymentsColor = Color(0xFF06B6D4); // Cyan
  static const Color settingsColor = Color(0xFF6B7280); // Gray

  // Menu Item Colors
  static const Color settingsMenuColor = Color(0xFF3B82F6); // Blue
  static const Color profileMenuColor = Color(0xFF8B5CF6); // Purple
  static const Color aboutMenuColor = Color(0xFF10B981); // Green
  static const Color helpMenuColor = Color(0xFFF59E0B); // Orange

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Border Colors
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderMedium = Color(0xFFD1D5DB);

  // Shadow Colors
  static Color shadowLight = Colors.black.withOpacity(0.05);
  static Color shadowMedium = Colors.black.withOpacity(0.1);
  static Color shadowDark = Colors.black.withOpacity(0.2);

  // Badge Colors
  static const Color badgeBackground = Color(0xFFEF4444);
  static const Color badgeText = Color(0xFFFFFFFF);

  // Helper method to get light version of a color
  static Color getLightColor(Color color) {
    return color.withOpacity(0.1);
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