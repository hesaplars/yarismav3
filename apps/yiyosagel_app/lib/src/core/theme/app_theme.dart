import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const gold = Color(0xffd99a18);
  static const goldSoft = Color(0xfffff1cc);
  static const cream = Color(0xfff7f1e6);
  static const surface = Color(0xfffffbf3);
  static const ink = Color(0xff172222);
  static const muted = Color(0xff69736f);
  static const line = Color(0x22000000);
  static const green = Color(0xff2fbf78);
  static const red = Color(0xffef4458);
  static const blue = Color(0xff3aa7d8);

  static ThemeData light() {
    return _base(Brightness.light).copyWith(
      scaffoldBackgroundColor: cream,
      cardColor: surface,
    );
  }

  static ThemeData dark() {
    return _base(Brightness.dark).copyWith(
      scaffoldBackgroundColor: const Color(0xff111817),
      cardColor: const Color(0xff1a2422),
    );
  }

  static ThemeData _base(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: gold,
      brightness: brightness,
      primary: gold,
      secondary: green,
      error: red,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: 'Roboto',
      textTheme: Typography.material2021().black.apply(
            bodyColor: brightness == Brightness.dark ? Colors.white : ink,
            displayColor: brightness == Brightness.dark ? Colors.white : ink,
          ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 46),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: gold, width: 1.4),
        ),
      ),
    );
  }
}
