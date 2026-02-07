import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PatientCard extends StatelessWidget {
  final String name;
  final String sex;
  final String age;
  final String reason;
  final VoidCallback onPressed;

  const PatientCard({
    super.key,
    required this.name,
    required this.sex,
    required this.age,
    required this.reason,
    required this.onPressed,
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
            : Colors.black.withOpacity(0.65);

    Widget infoChip(String text, IconData icon) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color:
              isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF3F4F8),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: subtleText),
            const SizedBox(width: 6),
            Text(
              text,
              style: GoogleFonts.exo(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color:
                    isDark
                        ? Colors.white.withOpacity(0.9)
                        : Colors.black.withOpacity(0.75),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          /// Avatar block with glow
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),

              // ✅ Better contrast glass (visible in light theme too)
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    isDark
                        ? [
                          Colors.white.withOpacity(0.10),
                          Colors.white.withOpacity(0.03),
                        ]
                        : [
                          const Color.fromARGB(
                            255,
                            19,
                            102,
                            102,
                          ), // light glass base (slightly gray)
                          const Color.fromARGB(
                            255,
                            193,
                            214,
                            242,
                          ), // subtle depth
                        ],
              ),

              // ✅ Stronger border in light theme
              border: Border.all(
                color:
                    isDark
                        ? Colors.white.withOpacity(0.18)
                        : Colors.black.withOpacity(0.08),
              ),

              boxShadow: [
                // outer soft shadow (gives visibility in light theme)
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.40 : 0.10),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),

                // subtle highlight
                BoxShadow(
                  color: Colors.white.withOpacity(isDark ? 0.05 : 0.65),
                  blurRadius: 10,
                  offset: const Offset(-2, -2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : "?",
                style: GoogleFonts.exo(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          /// Patient info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.exo(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    infoChip(sex, LucideIcons.user),
                    infoChip(age, LucideIcons.clock),
                    infoChip(reason, LucideIcons.heartPulse),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          /// Action button
          ShadButton(
            backgroundColor: Colors.teal,
            onPressed: onPressed,
            child: Text(
              "View",
              style: GoogleFonts.exo(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
