import 'package:anxolotl_app/src/util/aesthetics/design_theme.dart';
import 'package:anxolotl_app/src/util/aesthetics/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class LightTheme {
  static const String themeId = 'light_theme_anxolotl';

  static const ColorScheme _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xffFFE78C),
    onPrimary: Color(0xffFAFFFD),
    secondary: Color(0xff86BBD8),
    onSecondary: Color(0xffFAFFFD),
    tertiary: Color(0xffFFD27F),
    onTertiary: Color(0xffFAFFFD),
    error: Color(0xffFFA299),
    onError: Color(0xffFAFFFD),
    surface: Color(0xffFFFFFF),
    onSurface: Color.fromRGBO(0x1F, 0x21, 0x28, 0.6),
    onSurfaceVariant: Color.fromRGBO(0x1F, 0x21, 0x28, 0.87),
    shadow: Color(0xffA1A6B4),
    outline: Color(0xffA1A6B4),
    inverseSurface: Color(0xff1F2128),
    onInverseSurface: Color(0xffFFFFFF),
  );

  static AppTheme theme = AppTheme(
   id: themeId,
  description: "Light Anxolotl Color Scheme",
  data: ThemeData(
    useMaterial3: true, 
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _colorScheme.primary,
        foregroundColor: _colorScheme.onPrimary, 
      ),
    ),
    appBarTheme: AppBarTheme(
        foregroundColor: _colorScheme.onSurfaceVariant,
        backgroundColor: _colorScheme.surface,
        elevation: 4),
      cardTheme: const CardThemeData(
          clipBehavior: Clip.hardEdge,
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(DesignTheme.roundedCornersRadius)))),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: _colorScheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: _colorScheme.secondary),
        ),
      ),
      textTheme: TextStyles.lightThemeStyle,
      colorScheme: _colorScheme,
    ),
  );
}

class DarkTheme {
  static const String themeId = 'dark_theme_anxolotl';

  static const ColorScheme _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xffFFE78C),
    onPrimary: Color(0xffFAFFFD),
    secondary: Color(0xff86BBD8),
    onSecondary: Color(0xffFAFFFD),
    tertiary: Color(0xffFFD27F),
    onTertiary: Color(0xffFAFFFD),
    error: Color(0xffFFA299),
    onError: Color(0xffFAFFFD),
    surface: Color(0xffFFFFFF),
    onSurface: Color.fromRGBO(0x1F, 0x21, 0x28, 0.6),
    shadow: Color(0xffA1A6B4),
    outline: Color(0xffA1A6B4),
  );

  static AppTheme theme = AppTheme(
    id: themeId,
    description: "Light Anxolotl Color Scheme",
    data: ThemeData(
      appBarTheme:
          AppBarTheme(backgroundColor: _colorScheme.surface, elevation: 16),
      cardTheme: const CardThemeData(
          clipBehavior: Clip.hardEdge,
          elevation: 4,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(DesignTheme.roundedCornersRadius)))),
      textTheme: TextStyles.lightThemeStyle,
      colorScheme: _colorScheme,
    ),
  );
}
