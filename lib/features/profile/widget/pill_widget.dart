import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wio_doctor/core/theme/app_colors.dart';

class PillWidget extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String text;
  const PillWidget({super.key, required this.isDark, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF3F4F8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border(isDark)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.subtleText(isDark)),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.exo(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color:
                  isDark
                      ? Colors.white.withOpacity(0.88)
                      : Colors.black.withOpacity(0.75),
            ),
          ),
        ],
      ),
    );
  }
}