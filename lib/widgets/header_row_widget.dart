import 'package:flutter/material.dart';
import 'package:wio_doctor/core/theme/app_colors.dart';
import 'package:wio_doctor/core/theme/app_text_styles.dart';

class HeaderRowWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;
  const HeaderRowWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.teal.withOpacity(isDark ? 0.14 : 0.10),
            border: Border.all(
              color: Colors.teal.withOpacity(isDark ? 0.25 : 0.18),
            ),
          ),
          child: Icon(icon, size: 18, color: Colors.teal),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.section(16)),
              const SizedBox(height: 2),
              Text(
                subTitle,
                style: AppTextStyles.body(
                  12.5,
                ).copyWith(color: AppColors.subtleText(isDark)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
