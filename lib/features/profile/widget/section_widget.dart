import 'package:flutter/material.dart';
import 'package:wio_doctor/core/theme/app_colors.dart';
import 'package:wio_doctor/core/theme/app_decoration.dart';
import 'package:wio_doctor/core/theme/app_text_styles.dart';

class SectionWidget extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String title;
  final String subTitle;
  final Widget child;

  const SectionWidget({
    super.key,
    required this.isDark,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.card(isDark),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color:
                        isDark
                            ? Colors.white.withOpacity(0.06)
                            : Colors.black.withOpacity(0.04),
                    border: Border.all(color: AppColors.border(isDark)),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color:
                        isDark
                            ? Colors.white.withOpacity(0.88)
                            : Colors.black.withOpacity(0.80),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.section(14)),
                      const SizedBox(height: 3),
                      Text(
                        subTitle,
                        style: AppTextStyles.body(
                          13,
                        ).copyWith(color: AppColors.subtleText(isDark)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}
