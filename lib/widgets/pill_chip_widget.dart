import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wio_doctor/core/theme/status_styles.dart';

class PillChipWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final String statusKey;
  final bool isDark;

  const PillChipWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.statusKey,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: StatusStyles.chipBg(statusKey, isDark),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: StatusStyles.chipBorder(statusKey, isDark)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: StatusStyles.chipText(statusKey, isDark)),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.exo(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: StatusStyles.chipText(statusKey, isDark),
            ),
          ),
        ],
      ),
    );
  }
}
