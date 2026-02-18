import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/services/time_formate_service.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';
import 'package:wio_doctor/features/clinical_review/view/clinical_review_screen.dart';
import 'package:wio_doctor/features/dashboard/view_model/dashboard_view_model.dart';
import 'package:wio_doctor/features/dashboard/widgets/appointment_state_card.dart';
import 'package:wio_doctor/features/dashboard/widgets/patient_card.dart';
import 'package:wio_doctor/features/digital_prescription/view/digital_prescription_screen.dart';
import 'package:wio_doctor/features/patient/view/patient_details_screen.dart';
import 'package:wio_doctor/features/patient_access/view/patient_access_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  _HeaderPalette _paletteForNow(bool isDark) {
    final hour = DateTime.now().hour;

    // Morning: 5-11, Noon: 12-15, Evening: 16-19, Night: 20-4
    if (hour >= 5 && hour <= 11) {
      return _HeaderPalette(
        title: "Good Morning",
        colors:
            isDark
                ? const [Color(0xFF0B2B4A), Color(0xFF0B7B7A)]
                : const [Color(0xFF79C2FF), Color(0xFF1FD1C3)],
      );
    } else if (hour >= 12 && hour <= 15) {
      return _HeaderPalette(
        title: "Good Afternoon",
        colors:
            isDark
                ? const [Color(0xFF0A2447), Color(0xFF0F766E)]
                : const [Color(0xFF7DE7F5), Color(0xFF16A34A)],
      );
    } else if (hour >= 16 && hour <= 19) {
      return _HeaderPalette(
        title: "Good Evening",
        colors:
            isDark
                ? const [Color(0xFF1B163B), Color(0xFF0F766E)]
                : const [Color(0xFFFFB37A), Color(0xFF3BB2B8)],
      );
    } else {
      return _HeaderPalette(
        title: "Good Night",
        colors:
            isDark
                ? const [Color(0xFF050A12), Color(0xFF0F172A)]
                : const [Color(0xFF2B5876), Color(0xFF4E4376)],
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<DashboardViewModel>(context, listen: false).fetchDoctorData();
    Provider.of<DashboardViewModel>(
      context,
      listen: false,
    ).fetchPatientRoaster();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = ThemeProvider.of(context);

    final palette = _paletteForNow(isDark);

    final bg = isDark ? Colors.black : const Color(0xFFF8FAFC);
    final onHeader =
        isDark
            ? Colors.white.withOpacity(0.95)
            : Colors.white.withOpacity(0.96);

    return Scaffold(
      backgroundColor: bg,

      extendBodyBehindAppBar: true,
      endDrawerEnableOpenDragGesture: false,

      // ✅ END DRAWER
      endDrawer: _DashboardEndDrawer(isDark: isDark),

      // ✅ bKash-like top header (AppBar background changes by time)
      appBar: AppBar(
        toolbarHeight: 150,
        leading: const SizedBox.shrink(), // Add this
        actions: const [
          SizedBox.shrink(),
        ], // Keep this but make it empty widget
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        flexibleSpace: Stack(
          children: [
            // Gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: palette.colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Soft decorative layers (healthcare vibe)
            CustomPaint(
              painter: _HeaderWavePainter(
                isDark: isDark,
                accent: const Color(0xFF0D9488),
              ),
              size: const Size(double.infinity, 200),
            ),

            // Top content
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row: avatar + name + actions (search, notif, theme)
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: onHeader, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.18),
                                blurRadius: 14,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Consumer<DashboardViewModel>(
                            builder: (context, dashboardVM, child) {
                              return CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    dashboardVM.photo == null ||
                                            dashboardVM.photo!.isEmpty
                                        ? AssetImage(
                                          "assets/icons/user-icon.png",
                                        )
                                        : AssetImage(dashboardVM.photo!),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                palette.title,
                                style: GoogleFonts.exo(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: onHeader.withOpacity(0.90),
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Consumer<DashboardViewModel>(
                                builder: (context, dashboardVM, child) {
                                  return Text(
                                    dashboardVM.name == null ||
                                            dashboardVM.name!.isEmpty
                                        ? "Dr. Alex Riveira"
                                        : dashboardVM.name!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.exo(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: onHeader,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),
                        _CircleIconButton(
                          onTap: () {
                            // TODO: notifications
                          },
                          icon: LucideIcons.bell,
                          isDarkHeader: true,
                        ),
                        const SizedBox(width: 10),
                        _CircleIconButton(
                          onTap: () {
                            themeProvider.setThemeMode(
                              themeProvider.isDarkMode
                                  ? ThemeMode.light
                                  : ThemeMode.dark,
                            );
                          },
                          icon:
                              themeProvider.isDarkMode
                                  ? LucideIcons.sun
                                  : LucideIcons.moon,
                          isDarkHeader: true,
                        ),
                        const SizedBox(width: 10),

                        Builder(
                          builder:
                              (context) => _CircleIconButton(
                                onTap: () {
                                  Scaffold.of(context).openEndDrawer();
                                },
                                icon: LucideIcons.menu,
                                isDarkHeader: true,
                              ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // bKash-like pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(isDark ? 0.10 : 0.18),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(isDark ? 0.22 : 0.28),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(0.22),
                            ),
                            child: const Icon(
                              LucideIcons.badgeCheck,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Consumer<DashboardViewModel>(
                            builder: (context, dashboardVm, child) {
                              return Text(
                                "${dashboardVm.specialization == null || dashboardVm.specialization!.isEmpty ? "Cardiologist" : dashboardVm.wioId} • WIO ID: ${dashboardVm.wioId == null || dashboardVm.wioId!.isEmpty ? "XXXXXXX" : dashboardVm.wioId}",
                                style: GoogleFonts.exo(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: onHeader,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ✅ Keep your contents & ListView builder logic — only design changes
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 220, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A white rounded sheet like bKash (makes the header look premium)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color:
                      isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.black.withOpacity(0.06),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Statistics Cards (kept as-is)
                  Row(
                    children: [
                      Expanded(
                        child: AppointmentStateCard(
                          icon: Icons.people_outline,
                          count: "1,256",
                          label: "Total Patients",
                          color: const Color(0xFF8B5CF6),
                          lightColor:
                              isDark
                                  ? const Color(0xFF312E81)
                                  : const Color(0xFFF3E8FF),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppointmentStateCard(
                          icon: Icons.event_available,
                          count: "12",
                          label: "Today",
                          color: const Color(0xFF0D9488),
                          lightColor:
                              isDark
                                  ? const Color(0xFF134E4A)
                                  : const Color(0xFFCCFBF1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppointmentStateCard(
                          icon: Icons.priority_high,
                          count: "4",
                          label: "Critical",
                          color: const Color(0xFFEF4444),
                          lightColor:
                              isDark
                                  ? const Color(0xFF7F1D1D)
                                  : const Color(0xFFFEE2E2),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Small quick strip (optional vibe, not breaking your content)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.04)
                              : const Color(0xFFF3F4F8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.08)
                                : Colors.black.withOpacity(0.06),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.activity,
                          size: 18,
                          color: Colors.teal,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Tip: Keep your availability updated for better bookings.",
                            style: GoogleFonts.exo(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color:
                                  isDark
                                      ? Colors.white.withOpacity(0.84)
                                      : Colors.black.withOpacity(0.72),
                            ),
                          ),
                        ),
                        Icon(
                          LucideIcons.chevronRight,
                          size: 18,
                          color:
                              isDark
                                  ? Colors.white.withOpacity(0.55)
                                  : Colors.black.withOpacity(0.40),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Section Header (kept as-is)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color:
                      isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.black.withOpacity(0.06),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Patient Roaster",
                        style: GoogleFonts.exo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF1F2937),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "See All",
                          style: GoogleFonts.exo(
                            fontSize: 14,
                            color: const Color(0xFF0D9488),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Patient List (kept as-is)
                  Consumer<DashboardViewModel>(
                    builder: (context, dashboardVM, child) {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dashboardVM.roasterPatients.length,
                        itemBuilder: (context, index) {
                          final patientDetails =
                              dashboardVM.roasterPatients[index]
                                  as Map<String, dynamic>;

                          return dashboardVM.isLoadingPatientRoaster
                              ? Icon(LucideIcons.loader)
                              : PatientCard(
                                name: patientDetails["patientName"] ?? "",
                                sex: "F",
                                lastVisited:
                                    patientDetails["lastVisitAt"] != null
                                        ? TimeFormateService().formatDate(
                                          patientDetails["lastVisitAt"],
                                        )
                                        : "New Visit",
                                status: patientDetails["status"] ?? "",
                                onPressed: () {
                                  print(patientDetails["patientId"]);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => const PatientDetailsScreen(),
                                    ),
                                  );
                                },
                              );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderPalette {
  final String title;
  final List<Color> colors;
  const _HeaderPalette({required this.title, required this.colors});
}

class _CircleIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final bool isDarkHeader;

  const _CircleIconButton({
    required this.onTap,
    required this.icon,
    required this.isDarkHeader,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.18),
          border: Border.all(color: Colors.white.withOpacity(0.22)),
        ),
        child: Icon(icon, size: 18, color: Colors.white.withOpacity(0.95)),
      ),
    );
  }
}

class _DashboardEndDrawer extends StatelessWidget {
  final bool isDark;
  const _DashboardEndDrawer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor =
        isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.06);
    final subtleText =
        isDark
            ? Colors.white.withOpacity(0.72)
            : Colors.black.withOpacity(0.65);

    Widget item({
      required IconData icon,
      required String title,
      required VoidCallback onTap,
    }) {
      return InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color:
                isDark
                    ? Colors.white.withOpacity(0.04)
                    : const Color(0xFFF3F4F8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.teal.withOpacity(isDark ? 0.14 : 0.10),
                  border: Border.all(
                    color: Colors.teal.withOpacity(isDark ? 0.25 : 0.18),
                  ),
                ),
                child: const Icon(
                  LucideIcons.dot,
                  size: 18,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.exo(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Icon(LucideIcons.chevronRight, size: 18, color: subtleText),
            ],
          ),
        ),
      );
    }

    return Drawer(
      width: 320,
      backgroundColor: cardColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Quick Access",
                      style: GoogleFonts.exo(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.06)
                                : Colors.black.withOpacity(0.04),
                        border: Border.all(color: borderColor),
                      ),
                      child: Icon(
                        LucideIcons.x,
                        size: 18,
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.85)
                                : Colors.black.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                "Tools for clinical workflow & patient operations.",
                style: GoogleFonts.exo(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: subtleText,
                ),
              ),

              const SizedBox(height: 14),

              item(
                icon: LucideIcons.users,
                title: "Patient Access",
                onTap: () {
                  // TODO: navigate
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PatientAccessScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              item(
                icon: LucideIcons.fileText,
                title: "Digital Prescriber",
                onTap: () {
                  // TODO: navigate
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DigitalPrescriberScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              item(
                icon: LucideIcons.stethoscope,
                title: "Clinical Review",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClinicalReviewScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              item(
                icon: LucideIcons.messagesSquare,
                title: "Case Discussion",
                onTap: () {
                  // TODO: navigate
                },
              ),

              const Spacer(),

              // Disclaimer
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? Colors.white.withOpacity(0.04)
                          : const Color(0xFFF3F4F8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  "Disclaimer: This section provides quick access to tools. Always follow clinical guidelines and verify patient information before making decisions.",
                  style: GoogleFonts.exo(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: subtleText,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Decorative wave/hills like bKash header (no images needed)
class _HeaderWavePainter extends CustomPainter {
  final bool isDark;
  final Color accent;

  _HeaderWavePainter({required this.isDark, required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final p1 =
        Paint()
          ..color = Colors.white.withOpacity(isDark ? 0.06 : 0.10)
          ..style = PaintingStyle.fill;

    final p2 =
        Paint()
          ..color = Colors.white.withOpacity(isDark ? 0.08 : 0.12)
          ..style = PaintingStyle.fill;

    final p3 =
        Paint()
          ..color = accent.withOpacity(isDark ? 0.10 : 0.10)
          ..style = PaintingStyle.fill;

    // Layer 1 (far)
    final path1 =
        Path()
          ..moveTo(0, size.height * 0.55)
          ..quadraticBezierTo(
            size.width * 0.25,
            size.height * 0.48,
            size.width * 0.52,
            size.height * 0.56,
          )
          ..quadraticBezierTo(
            size.width * 0.78,
            size.height * 0.64,
            size.width,
            size.height * 0.58,
          )
          ..lineTo(size.width, 0)
          ..lineTo(0, 0)
          ..close();
    canvas.drawPath(path1, p1);

    // Layer 2 (mid)
    final path2 =
        Path()
          ..moveTo(0, size.height * 0.70)
          ..quadraticBezierTo(
            size.width * 0.22,
            size.height * 0.62,
            size.width * 0.50,
            size.height * 0.70,
          )
          ..quadraticBezierTo(
            size.width * 0.78,
            size.height * 0.78,
            size.width,
            size.height * 0.72,
          )
          ..lineTo(size.width, 0)
          ..lineTo(0, 0)
          ..close();
    canvas.drawPath(path2, p2);

    // Accent blob
    final path3 =
        Path()
          ..moveTo(size.width * 0.62, size.height * 0.18)
          ..quadraticBezierTo(
            size.width * 0.78,
            size.height * 0.10,
            size.width * 0.88,
            size.height * 0.22,
          )
          ..quadraticBezierTo(
            size.width * 0.98,
            size.height * 0.36,
            size.width * 0.78,
            size.height * 0.40,
          )
          ..quadraticBezierTo(
            size.width * 0.56,
            size.height * 0.42,
            size.width * 0.62,
            size.height * 0.18,
          )
          ..close();
    canvas.drawPath(path3, p3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
