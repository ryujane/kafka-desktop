import 'package:flutter/material.dart';

const _fontFamily = 'NotoSansSC';

abstract final class AppTheme {
  static ThemeData light() => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    fontFamily: _fontFamily,
  );

  static ThemeData dark() => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    fontFamily: _fontFamily,
  );
}
