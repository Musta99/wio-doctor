
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';
import 'package:wio_doctor/features/schedule/view/update_weekly_availability_screen.dart';
import 'package:wio_doctor/features/schedule/view_model/schedule_view_model.dart';

/// SCREEN 1 (KEEP ONLY): Current Availability
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Demo state (you can connect these to Provider/API later)
  String status = "Offline"; // Online / Appointment only / Offline
  bool instantEnabled = true;
  bool appointmentEnabled = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ScheduleViewModel>(context,listen: false).fetchDoctorSchedule(context);
  }

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

    Color statusDotColor() {
      if (status == "Online") return Colors.greenAccent;
      if (status == "Appointment only") return Colors.orangeAccent;
      return Colors.redAccent;
    }

    Color statusChipBg() {
      if (status == "Online")
        return Colors.green.withOpacity(isDark ? 0.18 : 0.12);
      if (status == "Appointment only")
        return Colors.orange.withOpacity(isDark ? 0.18 : 0.12);
      return Colors.red.withOpacity(isDark ? 0.18 : 0.12);
    }

    Color statusChipBorder() {
      if (status == "Online")
        return Colors.green.withOpacity(isDark ? 0.35 : 0.25);
      if (status == "Appointment only")
        return Colors.orange.withOpacity(isDark ? 0.35 : 0.25);
      return Colors.red.withOpacity(isDark ? 0.35 : 0.25);
    }

    Color statusTextColor() {
      if (isDark) return Colors.white.withOpacity(0.92);
      if (status == "Online") return Colors.green.shade900;
      if (status == "Appointment only") return Colors.orange.shade900;
      return Colors.red.shade900;
    }

    Widget pillFeature({
      required IconData icon,
      required String title,
      required bool enabled,
      required Color glow,
    }) {
      return Container(
        decoration: cardDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: glow.withOpacity(isDark ? 0.12 : 0.10),
                  border: Border.all(
                    color: glow.withOpacity(isDark ? 0.25 : 0.18),
                  ),
                ),
                child: Icon(
                  enabled ? LucideIcons.check : LucideIcons.x,
                  size: 18,
                  color:
                      enabled
                          ? glow
                          : (isDark ? Colors.white54 : Colors.black45),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: bodyStyle(14).copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Availability', style: titleStyle(20)),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                // ==============================
                // Current Availability (ONLY)
                // ==============================
                Container(
                  decoration: cardDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
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
                                LucideIcons.activity,
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
                                    "Current Availability",
                                    style: sectionStyle(18),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Manage your weekly schedule from the next screen.",
                                    style: bodyStyle(
                                      13,
                                    ).copyWith(color: subtleText),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Status Row
                        Row(
                          children: [
                            Text(
                              "Status:",
                              style: bodyStyle(14).copyWith(color: subtleText),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: statusChipBg(),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: statusChipBorder()),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                      color: statusDotColor(),
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    status,
                                    style: GoogleFonts.exo(
                                      color: statusTextColor(),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            // Quick demo toggle (optional)
                            PopupMenuButton<String>(
                              tooltip: "Change status",
                              icon: Icon(
                                LucideIcons.chevronsUpDown,
                                size: 18,
                                color:
                                    isDark
                                        ? Colors.white.withOpacity(0.75)
                                        : Colors.black.withOpacity(0.65),
                              ),
                              onSelected: (v) => setState(() => status = v),
                              itemBuilder:
                                  (_) => const [
                                    PopupMenuItem(
                                      value: "Online",
                                      child: Text("Online"),
                                    ),
                                    PopupMenuItem(
                                      value: "Appointment only",
                                      child: Text("Appointment only"),
                                    ),
                                    PopupMenuItem(
                                      value: "Offline",
                                      child: Text("Offline"),
                                    ),
                                  ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Services
                        Row(
                          children: [
                            Expanded(
                              child: pillFeature(
                                icon: LucideIcons.video,
                                title: "Instant Consultations",
                                enabled: instantEnabled,
                                glow: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: pillFeature(
                                icon: LucideIcons.calendar,
                                title: "Appointment Consultations",
                                enabled: appointmentEnabled,
                                glow: Colors.green,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Days chips
                        Text("Available days", style: sectionStyle(16)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _prettyChip("Monday", isDark),
                            _prettyChip("Tuesday", isDark),
                            _prettyChip("Wednesday", isDark),
                            _prettyChip("Thursday", isDark),
                            _prettyChip("Friday", isDark),
                            _prettyChip("Saturday", isDark),
                          ],
                        ),

                        const SizedBox(height: 36),

                        // CTA Button -> New screen
                        ShadButton(
                          width: double.infinity,
                          height: 46,
                          backgroundColor: Colors.teal,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        const UpdateWeeklyAvailabilityScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Update weekly availability",
                            style: GoogleFonts.exo(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
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

  Widget _prettyChip(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color:
            isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF3F4F8),
        border: Border.all(
          color:
              isDark
                  ? Colors.white.withOpacity(0.10)
                  : Colors.black.withOpacity(0.06),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.exo(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color:
              isDark
                  ? Colors.white.withOpacity(0.85)
                  : Colors.black.withOpacity(0.8),
        ),
      ),
    );
  }
}
