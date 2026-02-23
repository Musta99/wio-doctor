import 'package:flutter/material.dart';

class AppColors {
  static Color bgTop(bool isDark) =>
      isDark ? const Color(0xFF0B1220) : const Color(0xFFF7F8FC);

  static Color bgBottom(bool isDark) =>
      isDark ? const Color(0xFF060A12) : Colors.white;

  static Color card(bool isDark) =>
      isDark ? const Color(0xFF0F172A) : Colors.white;

  static Color border(bool isDark) =>
      isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06);

  static Color subtleText(bool isDark) =>
      isDark ? Colors.white.withOpacity(0.72) : Colors.black.withOpacity(0.65);
}
