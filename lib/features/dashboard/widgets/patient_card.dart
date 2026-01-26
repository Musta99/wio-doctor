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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border:
              isDark ? Border.all(color: Color(0xFF334155), width: 1) : null,

          boxShadow: [
            BoxShadow(
              color:
                  isDark ? Colors.transparent : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isDark ? Color(0xFF0F766E) : Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  name[0],
                  style: GoogleFonts.exo(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Color(0xFF0D9488),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.exo(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    spacing: 12,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? Color(0xFF713F12) : Color(0xFFFEF3C7),

                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          sex,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color:
                                isDark ? Color(0xFFFDE68A) : Color(0xFF92400E),

                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? Color(0xFF713F12) : Color(0xFFFEF3C7),

                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          age,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color:
                                isDark ? Color(0xFFFDE68A) : Color(0xFF92400E),

                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? Color(0xFF713F12) : Color(0xFFFEF3C7),

                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          reason,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color:
                                isDark ? Color(0xFFFDE68A) : Color(0xFF92400E),

                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ShadButton(
              onPressed: onPressed,
              backgroundColor: Colors.teal,
              child: Text(
                "View",
                style: GoogleFonts.exo2(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
