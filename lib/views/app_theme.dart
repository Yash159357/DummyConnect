// lib/config/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Color scheme
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color secondaryColor = Color(0xFF8B5CF6); // Purple
  static const Color accentColor = Color(0xFF06B6D4); // Cyan
  static const Color errorColor = Color(0xFFEF4444); // Red
  static const Color successColor = Color(0xFF10B981); // Green
  static const Color warningColor = Color(0xFFF59E0B); // Amber

  // Dark theme colors
  static const Color darkBackground = Color(0xFF0F0F23);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF16213E);

  // Light theme colors
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF1F5F9);

  // Common theme configurations
  static const double borderRadius = 16.0;
  static const double cardElevation = 0.0;
  static const double buttonBorderRadius = 12.0;
  static const double inputBorderRadius = 12.0;

  // Text styles
  static const TextStyle _baseTextStyle = TextStyle(
    fontFamily: 'SF Pro Display', // iOS-like font, fallback to system
  );

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      scaffoldBackgroundColor: lightBackground,
      
      // App bar theme
      appBarTheme: _buildAppBarTheme(isDark: false),
      
      // Card theme
      cardTheme: _buildCardTheme(isDark: false),
      
      // Button themes
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      textButtonTheme: _buildTextButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      
      // Input decoration theme
      inputDecorationTheme: _buildInputDecorationTheme(isDark: false),
      
      // Text theme
      textTheme: _buildTextTheme(isDark: false),
      
      // Bottom navigation theme
      bottomNavigationBarTheme: _buildBottomNavTheme(isDark: false),
      
      // Floating action button theme
      floatingActionButtonTheme: _buildFABTheme(),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE2E8F0),
        thickness: 1,
        space: 1,
      ),
      
      // Chip theme
      chipTheme: _buildChipTheme(isDark: false),
      
      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
      ),
      
      // Snack bar theme
      snackBarTheme: _buildSnackBarTheme(isDark: false),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,
      scaffoldBackgroundColor: darkBackground,
      
      // App bar theme
      appBarTheme: _buildAppBarTheme(isDark: true),
      
      // Card theme
      cardTheme: _buildCardTheme(isDark: true),
      
      // Button themes
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      textButtonTheme: _buildTextButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      
      // Input decoration theme
      inputDecorationTheme: _buildInputDecorationTheme(isDark: true),
      
      // Text theme
      textTheme: _buildTextTheme(isDark: true),
      
      // Bottom navigation theme
      bottomNavigationBarTheme: _buildBottomNavTheme(isDark: true),
      
      // Floating action button theme
      floatingActionButtonTheme: _buildFABTheme(),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFF374151),
        thickness: 1,
        space: 1,
      ),
      
      // Chip theme
      chipTheme: _buildChipTheme(isDark: true),
      
      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
      ),
      
      // Snack bar theme
      snackBarTheme: _buildSnackBarTheme(isDark: true),
    );
  }

  // Color schemes
  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    tertiary: accentColor,
    error: errorColor,
    background: lightBackground,
    surface: lightSurface,
    surfaceVariant: lightCard,
  );

  static const ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: primaryColor,
    secondary: secondaryColor,
    tertiary: accentColor,
    error: errorColor,
    background: darkBackground,
    surface: darkSurface,
    surfaceVariant: darkCard,
  );

  // Theme component builders
  static AppBarTheme _buildAppBarTheme({required bool isDark}) {
    return AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(
        color: isDark ? Colors.white : Colors.black87,
      ),
      actionsIconTheme: IconThemeData(
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }

  static CardTheme _buildCardTheme({required bool isDark}) {
    return CardTheme(
      color: isDark ? darkCard : lightCard,
      elevation: cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonBorderRadius),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonBorderRadius),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonBorderRadius),
        ),
        side: const BorderSide(color: primaryColor, width: 1.5),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme({required bool isDark}) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? darkCard : lightCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: BorderSide(
          color: isDark ? Colors.white12 : Colors.black12,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: const BorderSide(color: errorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: TextStyle(
        color: isDark ? Colors.white54 : Colors.black54,
        fontSize: 16,
      ),
    );
  }

  static TextTheme _buildTextTheme({required bool isDark}) {
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subtitleColor = isDark ? Colors.white70 : Colors.black54;

    return TextTheme(
      headlineLarge: _baseTextStyle.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
        height: 1.2,
      ),
      headlineMedium: _baseTextStyle.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
      ),
      headlineSmall: _baseTextStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.3,
      ),
      titleLarge: _baseTextStyle.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
      ),
      titleMedium: _baseTextStyle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.4,
      ),
      titleSmall: _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.4,
      ),
      bodyLarge: _baseTextStyle.copyWith(
        fontSize: 16,
        color: textColor,
        height: 1.5,
      ),
      bodyMedium: _baseTextStyle.copyWith(
        fontSize: 14,
        color: subtitleColor,
        height: 1.4,
      ),
      bodySmall: _baseTextStyle.copyWith(
        fontSize: 12,
        color: subtitleColor,
        height: 1.3,
      ),
      labelLarge: _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.2,
      ),
      labelMedium: _baseTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.2,
      ),
      labelSmall: _baseTextStyle.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: subtitleColor,
        height: 1.2,
      ),
    );
  }

  static BottomNavigationBarThemeData _buildBottomNavTheme({required bool isDark}) {
    return BottomNavigationBarThemeData(
      backgroundColor: isDark ? darkSurface : lightSurface,
      selectedItemColor: primaryColor,
      unselectedItemColor: isDark ? Colors.white54 : Colors.black54,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    );
  }

  static FloatingActionButtonThemeData _buildFABTheme() {
    return const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      highlightElevation: 8,
      shape: CircleBorder(),
    );
  }

  static ChipThemeData _buildChipTheme({required bool isDark}) {
    return ChipThemeData(
      backgroundColor: isDark ? darkCard : lightCard,
      selectedColor: primaryColor.withOpacity(0.2),
      disabledColor: isDark ? Colors.white12 : Colors.black12,
      labelStyle: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      brightness: isDark ? Brightness.dark : Brightness.light,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  static SnackBarThemeData _buildSnackBarTheme({required bool isDark}) {
    return SnackBarThemeData(
      backgroundColor: isDark ? darkCard : Colors.black87,
      contentTextStyle: TextStyle(
        color: isDark ? Colors.white : Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      actionTextColor: primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
    );
  }

  // Utility methods for custom colors
  static Color get primarySwatch => primaryColor;
  static Color get onPrimaryLight => Colors.white;
  static Color get onPrimaryDark => Colors.white;
  
  // Status colors
  static Color get success => successColor;
  static Color get warning => warningColor;
  static Color get info => accentColor;
  
  // Gradient definitions
  static LinearGradient get primaryGradient => const LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get accentGradient => const LinearGradient(
    colors: [accentColor, primaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}