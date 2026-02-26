import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/app_colors.dart';

class DropdownBoxWidget extends StatelessWidget {
  final IconData icon;
  final String hint;
  String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  DropdownBoxWidget({
    super.key,
    required this.icon,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF3F4F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(isDark)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.subtleText(isDark)),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: value,
                hint: Text(
                  hint,
                  style: GoogleFonts.exo(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.subtleText(isDark),
                  ),
                ),
                icon: Icon(
                  LucideIcons.chevronDown,
                  size: 18,
                  color: AppColors.subtleText(isDark),
                ),
                items:
                    items
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: GoogleFonts.exo(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
