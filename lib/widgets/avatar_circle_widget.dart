import 'package:flutter/material.dart';
import 'package:wio_doctor/core/theme/app_text_styles.dart';
import '../core/theme/app_colors.dart';

class AvatarCircleWidget extends StatelessWidget {
  final String name;
  final bool isDark;

  const AvatarCircleWidget({
    super.key,
    required this.name,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final parts = name.trim().split(" ");
    final initials = parts.take(2).map((e) => e[0]).join().toUpperCase();

    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.black.withOpacity(0.06),
        border: Border.all(color: AppColors.border(isDark)),
      ),
      child: Center(child: Text(initials, style: AppTextStyles.title(14))),
    );
  }
}
