import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentStateCard extends StatelessWidget {
  final IconData icon;
  final String count;
  final String label;
  final Color color;
  final Color lightColor;
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
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: Color(0xFF334155), width: 1) : null,
        boxShadow:
            isDark
                ? null
                : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: lightColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 12),
          Text(
            count,
            style: GoogleFonts.exo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.exo(
              fontSize: 12,
              color: isDark ? Color(0xFF94A3B8) : Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
