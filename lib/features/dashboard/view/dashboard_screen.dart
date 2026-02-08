// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shadcn_ui/shadcn_ui.dart';
// import 'package:wio_doctor/core/theme/theme_provider.dart';
// import 'package:wio_doctor/features/dashboard/widgets/appointment_state_card.dart';
// import 'package:wio_doctor/features/dashboard/widgets/patient_card.dart';
// import 'package:wio_doctor/features/patient/view/patient_details_screen.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final themeProvider = ThemeProvider.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Wio Doctor'),
//         actions: [
//           // Theme switcher button - toggles between light and dark
//           IconButton(
//             icon: Icon(
//               themeProvider.isDarkMode ? LucideIcons.sun : LucideIcons.moon,
//             ),
//             onPressed: () {
//               // Toggle between light and dark mode
//               themeProvider.setThemeMode(
//                 themeProvider.isDarkMode ? ThemeMode.light : ThemeMode.dark,
//               );
//             },
//           ),
//         ],
//       ),
//       backgroundColor: isDark ? Colors.black : Color(0xFFF8FAFC),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Doctor Profile Header
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors:
//                       isDark
//                           ? [Color(0xFF0D9488), Color(0xFF0F766E)]
//                           : [Color(0xFF0D9488), Color(0xFF14B8A6)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Color(0xFF0D9488).withOpacity(isDark ? 0.2 : 0.3),
//                     blurRadius: 20,
//                     offset: Offset(0, 10),
//                   ),
//                 ],
//               ),
//               padding: EdgeInsets.all(20),
//               child: Row(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 3),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 10,
//                           offset: Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: CircleAvatar(
//                       radius: 35,
//                       backgroundImage: NetworkImage(
//                         "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Dr. Alex Riveira",
//                           style: GoogleFonts.exo(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           "Cardiologist",
//                           style: GoogleFonts.exo(
//                             fontSize: 14,
//                             color: Colors.white.withOpacity(0.9),
//                           ),
//                         ),
//                         Text(
//                           "WIO ID: XXXXXXXXX",
//                           style: GoogleFonts.exo(
//                             fontSize: 14,
//                             color: Colors.white.withOpacity(0.9),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Icon(
//                     Icons.notifications_outlined,
//                     color: Colors.white,
//                     size: 28,
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: 24),

//             // Statistics Cards
//             Row(
//               children: [
//                 Expanded(
//                   child: AppointmentStateCard(
//                     icon: Icons.people_outline,
//                     count: "1,256",
//                     label: "Total Patients",
//                     color: Color(0xFF8B5CF6),
//                     lightColor: isDark ? Color(0xFF312E81) : Color(0xFFF3E8FF),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: AppointmentStateCard(
//                     icon: Icons.event_available,
//                     count: "12",
//                     label: "Today",
//                     color: Color(0xFF0D9488),
//                     lightColor: isDark ? Color(0xFF134E4A) : Color(0xFFCCFBF1),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: AppointmentStateCard(
//                     icon: Icons.priority_high,
//                     count: "4",
//                     label: "Critical",
//                     color: Color(0xFFEF4444),
//                     lightColor: isDark ? Color(0xFF7F1D1D) : Color(0xFFFEE2E2),
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: 28),

//             // Section Header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Today's Patient Roaster",
//                   style: GoogleFonts.exo(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: isDark ? Colors.white : Color(0xFF1F2937),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {},
//                   child: Text(
//                     "See All",
//                     style: GoogleFonts.exo(
//                       fontSize: 14,
//                       color: Color(0xFF0D9488),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: 12),

//             // Patient List
//             ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: 6,
//               itemBuilder: (context, index) {
//                 return PatientCard(
//                   name: "Sarah Jenkins",
//                   sex: "F",
//                   age: "50 y",
//                   reason: "Hypertension",
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => PatientDetailsScreen()),
//                     );
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ------------------------------ 2222222222222222222222222 -----------------------------
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';
import 'package:wio_doctor/features/dashboard/widgets/appointment_state_card.dart';
import 'package:wio_doctor/features/dashboard/widgets/patient_card.dart';
import 'package:wio_doctor/features/patient/view/patient_details_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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

      // ✅ bKash-like top header (AppBar background changes by time)
      appBar: AppBar(
        toolbarHeight: 150,
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
                          child: const CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(
                              "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                            ),
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
                              Text(
                                "Dr. Alex Riveira",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.exo(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: onHeader,
                                ),
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

                        _CircleIconButton(
                          onTap: () {
                            // TODO: search
                          },
                          icon: LucideIcons.menu,
                          isDarkHeader: true,
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
                          Text(
                            "Cardiologist • WIO ID: XXXXXXXXX",
                            style: GoogleFonts.exo(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: onHeader,
                            ),
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
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return PatientCard(
                        name: "Sarah Jenkins",
                        sex: "F",
                        age: "50 y",
                        reason: "Hypertension",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PatientDetailsScreen(),
                            ),
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
