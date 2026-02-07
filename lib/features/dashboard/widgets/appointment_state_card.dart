import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentStateCard extends StatelessWidget {
  final IconData icon;
  final String count;
  final String label;
  final Color color; // accent
  final Color lightColor; // used lightly in bg tint (optional)

  const AppointmentStateCard({
    super.key,
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
    required this.lightColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor =
        isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.06);
    final subtleText =
        isDark
            ? Colors.white.withOpacity(0.72)
            : Colors.black.withOpacity(0.62);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.07),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ icon capsule like your _StatRow
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: color.withOpacity(isDark ? 0.14 : 0.10),
                border: Border.all(
                  color: color.withOpacity(isDark ? 0.25 : 0.18),
                ),
              ),
              child: Icon(icon, size: 18, color: color),
            ),

            const SizedBox(height: 12),

            Text(
              count,
              style: GoogleFonts.exo(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.2,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 2),

            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.exo(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: subtleText,
              ),
            ),

            const SizedBox(height: 10),

            // ✅ tiny accent line (premium touch)
            Container(
              height: 4,
              width: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(isDark ? 0.85 : 0.70),
                    color.withOpacity(0.10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
