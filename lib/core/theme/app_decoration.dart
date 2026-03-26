import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wio_doctor/core/theme/app_text_styles.dart';
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

  // ------------------ Input Decoration -----------------------
  static InputDecoration inputDec(String hint, IconData icon, bool isDark) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.exo(
        color: AppColors.subtleText(isDark),
        fontWeight: FontWeight.w600,
      ),
      prefixIcon: Icon(icon, size: 18),
      filled: true,
      fillColor:
          isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF3F4F8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.border(isDark)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.border(isDark)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Color(0xFF14c7eb).withOpacity(0.6)),
      ),
    );
  }
}
