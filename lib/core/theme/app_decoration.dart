import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppDecorations {
  static BoxDecoration card(bool isDark) {
    return BoxDecoration(
      color: AppColors.card(isDark),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.border(isDark)),
      boxShadow: [
        BoxShadow(
          color:
              isDark
                  ? Colors.black.withOpacity(0.38)
                  : Colors.black.withOpacity(0.07),
          blurRadius: 22,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }
}
