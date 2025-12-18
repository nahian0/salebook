import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Modern Purple/Blue
  static const Color primary = Color(0xFF6C63FF); // Vibrant Purple
  static const Color primaryLight = Color(0xFFE8E6FF);
  static const Color primaryDark = Color(0xFF5A52D5);

  // Background Colors
  static const Color background = Color(0xFFF8F9FA); // Light Gray
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color surfaceVariant = Color(0xFFF3F4F6); // Slightly Gray
  static const Color appBarBackground = Color(0xFFFFFFFF); // Clean White

  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937); // Dark Gray
  static const Color textSecondary = Color(0xFF6B7280); // Medium Gray
  static const Color textTertiary = Color(0xFF9CA3AF); // Light Gray

  // Feature Card Colors - Modern & Vibrant
  static const Color salesColor = Color(0xFFEF4444); // Modern Red
  static const Color purchaseColor = Color(0xFF3B82F6); // Modern Blue
  static const Color stockColor = Color(0xFF10B981); // Modern Green
  static const Color customersColor = Color(0xFFF59E0B); // Modern Amber
  static const Color reportsColor = Color(0xFF8B5CF6); // Modern Purple
  static const Color paymentsColor = Color(0xFFEC4899); // Modern Pink
  static const Color analyticsColor = Color(0xFF06B6D4); // Modern Cyan
  static const Color settingsColor = Color(0xFF6366F1); // Modern Indigo

  // Menu Item Colors - Cohesive Palette
  static const Color settingsMenuColor = Color(0xFF8B5CF6); // Purple
  static const Color profileMenuColor = Color(0xFF06B6D4); // Cyan
  static const Color aboutMenuColor = Color(0xFFF59E0B); // Amber
  static const Color helpMenuColor = Color(0xFF10B981); // Green

  // Status Colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red
  static const Color errorLight = Color(0xFFFEE2E2); // Light Red
  static const Color info = Color(0xFF3B82F6); // Blue

  // Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  static const Color borderMedium = Color(0xFFD1D5DB);
  static const Color divider = Color(0xFFF9FAFB);

  // Shadow Colors
  static Color shadowLight = Colors.black.withOpacity(0.05);
  static Color shadowMedium = Colors.black.withOpacity(0.08);
  static Color shadowDark = Colors.black.withOpacity(0.15);

  // Badge Colors
  static const Color badgeBackground = Color(0xFFEF4444);
  static const Color badgeText = Color(0xFFFFFFFF);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
  );

  static const LinearGradient salesGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
  );

  static const LinearGradient purchaseGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  // Helper method to get light version of a color
  static Color getLightColor(Color color) {
    return color.withOpacity(0.12);
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

  // Helper method to get gradient for menu items
  static LinearGradient getMenuGradient(String menuType) {
    final color = getMenuIconColor(menuType);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [color, color.withOpacity(0.8)],
    );
  }

  // Helper method to get light background for menu items
  static Color getMenuBackgroundColor(String menuType) {
    return getLightColor(getMenuIconColor(menuType));
  }
}