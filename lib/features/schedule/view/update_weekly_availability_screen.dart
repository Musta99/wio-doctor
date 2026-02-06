import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';

class UpdateWeeklyAvailabilityScreen extends StatefulWidget {
  const UpdateWeeklyAvailabilityScreen({super.key});

  @override
  State<UpdateWeeklyAvailabilityScreen> createState() =>
      _UpdateWeeklyAvailabilityScreenState();
}

class _UpdateWeeklyAvailabilityScreenState
    extends State<UpdateWeeklyAvailabilityScreen> {
  // Demo state (connect to Provider later)
  bool instantVideo = false;
  bool onlineAppointment = false;
  bool inClinicAppointment = false;

  int durationMinutes = 30; // 30 or 60

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    final isDark = themeProvider.isDarkMode;

    final bgTop = isDark ? const Color(0xFF0B1220) : const Color(0xFFF7F8FC);
    final bgBottom = isDark ? const Color(0xFF060A12) : const Color(0xFFFFFFFF);

    final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor =
        isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.06);
    final subtleText =
        isDark
            ? Colors.white.withOpacity(0.72)
            : Colors.black.withOpacity(0.65);

    TextStyle titleStyle(double size) => GoogleFonts.exo(
      fontWeight: FontWeight.w800,
      fontSize: size,
      letterSpacing: -0.2,
    );

    TextStyle sectionStyle(double size) =>
        GoogleFonts.exo(fontWeight: FontWeight.w800, fontSize: size);

    TextStyle bodyStyle(double size) =>
        GoogleFonts.exo(fontWeight: FontWeight.w500, fontSize: size);

    BoxDecoration cardDecoration() {
      return BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withOpacity(0.38)
                    : Colors.black.withOpacity(0.07),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      );
    }

    Widget serviceTile({
      required IconData icon,
      required String title,
      required bool value,
      required ValueChanged<bool?> onChanged,
    }) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color:
              isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF3F4F8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 6),
            Icon(icon, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.exo(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget durationTile({required int minutes}) {
      final selected = durationMinutes == minutes;
      return InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => durationMinutes = minutes),
        child: Container(
          decoration: BoxDecoration(
            color:
                isDark
                    ? Colors.white.withOpacity(0.04)
                    : const Color(0xFFF3F4F8),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color:
                  selected
                      ? Colors.green.withOpacity(isDark ? 0.55 : 0.45)
                      : borderColor,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$minutes Minutes",
                  style: bodyStyle(14).copyWith(fontWeight: FontWeight.w900),
                ),
                Icon(
                  selected ? LucideIcons.circleCheck : LucideIcons.circle,
                  color: selected ? Colors.green : subtleText,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Weekly Availability', style: titleStyle(18)),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: isDark ? "Switch to light" : "Switch to dark",
            icon: Icon(isDark ? LucideIcons.sun : LucideIcons.moon),
            onPressed: () {
              themeProvider.setThemeMode(
                isDark ? ThemeMode.light : ThemeMode.dark,
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgTop, bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: cardDecoration(),
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
                              ),
                              child: Icon(
                                LucideIcons.calendarClock,
                                size: 18,
                                color:
                                    isDark
                                        ? Colors.white.withOpacity(0.88)
                                        : Colors.black.withOpacity(0.82),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Weekly Availability",
                                    style: sectionStyle(18),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Choose services and consultation duration.",
                                    style: bodyStyle(
                                      13,
                                    ).copyWith(color: subtleText),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text("Service offered", style: sectionStyle(16)),
                        const SizedBox(height: 10),

                        serviceTile(
                          icon: LucideIcons.video,
                          title: "Instant video consultations",
                          value: instantVideo,
                          onChanged:
                              (v) => setState(() => instantVideo = v ?? false),
                        ),
                        const SizedBox(height: 10),
                        serviceTile(
                          icon: LucideIcons.calendar,
                          title: "Online appointment",
                          value: onlineAppointment,
                          onChanged:
                              (v) => setState(
                                () => onlineAppointment = v ?? false,
                              ),
                        ),
                        const SizedBox(height: 10),
                        serviceTile(
                          icon: LucideIcons.building,
                          title: "In clinic appointment",
                          value: inClinicAppointment,
                          onChanged:
                              (v) => setState(
                                () => inClinicAppointment = v ?? false,
                              ),
                        ),

                        const SizedBox(height: 18),

                        Text("Consultation Duration", style: sectionStyle(16)),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(child: durationTile(minutes: 30)),
                            const SizedBox(width: 10),
                            Expanded(child: durationTile(minutes: 60)),
                          ],
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Save to Provider/API
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Saved (demo).")),
                              );
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              "Save changes",
                              style: GoogleFonts.exo(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
