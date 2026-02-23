import 'package:flutter/material.dart';

class StatusStyles {
  /// Normalize key once
  static String _normalize(String key) => key.toLowerCase();

  /// Base color for each status
  static Color _baseColor(String key) {
    final s = _normalize(key);

    if (s.contains("pending")) return Colors.orange;
    if (s.contains("confirm")) return Colors.green;
    if (s.contains("complete")) return Colors.blue;
    if (s.contains("paid")) return Colors.green;
    if (s.contains("unpaid")) return Colors.red;

    return Colors.blueGrey;
  }

  /// Background color
  static Color chipBg(String key, bool isDark) {
    final base = _baseColor(key);
    return base.withOpacity(isDark ? 0.18 : 0.12);
  }

  /// Border color
  static Color chipBorder(String key, bool isDark) {
    final base = _baseColor(key);
    return base.withOpacity(isDark ? 0.35 : 0.25);
  }

  /// Text color
  static Color chipText(String key, bool isDark) {
    if (isDark) return Colors.white.withOpacity(0.92);

    final base = _baseColor(key);

    if (base == Colors.orange) return Colors.orange.shade900;
    if (base == Colors.green) return Colors.green.shade900;
    if (base == Colors.blue) return Colors.blue.shade900;
    if (base == Colors.red) return Colors.red.shade900;

    return Colors.blueGrey.shade900;
  }
}