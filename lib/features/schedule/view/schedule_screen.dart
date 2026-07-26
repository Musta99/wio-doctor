// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:shadcn_ui/shadcn_ui.dart';
// import 'package:wio_doctor/core/theme/theme_provider.dart';
// import 'package:wio_doctor/features/schedule/view/update_weekly_availability_screen.dart';
// import 'package:wio_doctor/features/schedule/view_model/schedule_view_model.dart';

// /// SCREEN 1 (KEEP ONLY): Current Availability
// class ScheduleScreen extends StatefulWidget {
//   const ScheduleScreen({super.key});

//   @override
//   State<ScheduleScreen> createState() => _ScheduleScreenState();
// }

// class _ScheduleScreenState extends State<ScheduleScreen> {
//   // Demo state (you can connect these to Provider/API later)
//   String status = "Offline"; // Online / Appointment only / Offline
//   bool instantEnabled = true;
//   bool appointmentEnabled = true;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ScheduleViewModel>(
//         context,
//         listen: false,
//       ).fetchDoctorSchedule(context);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = context.read<ThemeViewModel>();
//     final isDark = themeProvider.isDarkMode;

//     final bgTop = isDark ? const Color(0xFF0B1220) : const Color(0xFFF7F8FC);
//     final bgBottom = isDark ? const Color(0xFF060A12) : const Color(0xFFFFFFFF);

//     final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
//     final borderColor =
//         isDark
//             ? Colors.white.withOpacity(0.08)
//             : Colors.black.withOpacity(0.06);
//     final subtleText =
//         isDark
//             ? Colors.white.withOpacity(0.72)
//             : Colors.black.withOpacity(0.65);

//     TextStyle titleStyle(double size) => GoogleFonts.exo(
//       fontWeight: FontWeight.w800,
//       fontSize: size,
//       letterSpacing: -0.2,
//     );

//     TextStyle sectionStyle(double size) =>
//         GoogleFonts.exo(fontWeight: FontWeight.w800, fontSize: size);

//     TextStyle bodyStyle(double size) =>
//         GoogleFonts.exo(fontWeight: FontWeight.w500, fontSize: size);

//     BoxDecoration cardDecoration() {
//       return BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: borderColor),
//         boxShadow: [
//           BoxShadow(
//             color:
//                 isDark
//                     ? Colors.black.withOpacity(0.38)
//                     : Colors.black.withOpacity(0.07),
//             blurRadius: 22,
//             offset: const Offset(0, 12),
//           ),
//         ],
//       );
//     }

//     Color statusDotColor(String status) {
//       if (status == "online") return Colors.greenAccent;
//       if (status == "Appointment only") return Colors.orangeAccent;
//       return Colors.redAccent;
//     }

//     Color statusChipBg(String status) {
//       if (status == "online")
//         return Colors.green.withOpacity(isDark ? 0.18 : 0.12);
//       if (status == "Appointment only")
//         return Colors.orange.withOpacity(isDark ? 0.18 : 0.12);
//       return Colors.red.withOpacity(isDark ? 0.18 : 0.12);
//     }

//     Color statusChipBorder(String status) {
//       if (status == "Online")
//         return Colors.green.withOpacity(isDark ? 0.35 : 0.25);
//       if (status == "Appointment only")
//         return Colors.orange.withOpacity(isDark ? 0.35 : 0.25);
//       return Colors.red.withOpacity(isDark ? 0.35 : 0.25);
//     }

//     Color statusTextColor(String status) {
//       if (isDark) return Colors.white.withOpacity(0.92);
//       if (status == "online") return Colors.green.shade900;
//       if (status == "Appointment only") return Colors.orange.shade900;
//       return Colors.red.shade900;
//     }

//     Widget pillFeature({
//       required IconData icon,
//       required String title,
//       required bool enabled,
//       required Color glow,
//     }) {
//       return Container(
//         decoration: cardDecoration(),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             children: [
//               Container(
//                 height: 34,
//                 width: 34,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: glow.withOpacity(isDark ? 0.12 : 0.10),
//                   border: Border.all(
//                     color: glow.withOpacity(isDark ? 0.25 : 0.18),
//                   ),
//                 ),
//                 child: Icon(
//                   enabled ? LucideIcons.check : LucideIcons.x,
//                   size: 18,
//                   color:
//                       enabled
//                           ? glow
//                           : (isDark ? Colors.white54 : Colors.black45),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: bodyStyle(14).copyWith(fontWeight: FontWeight.w800),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       backgroundColor: bgBottom,
//       appBar: AppBar(
//         title: Text('Availability', style: titleStyle(20)),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//       ),
//       body: Consumer<ScheduleViewModel>(
//         builder: (context, scheduleVM, child) {
//           // ✅ 1. Loading
//           if (scheduleVM.isScheduleFetchLoading &&
//               scheduleVM.scheduleData.isEmpty) {
//             return const Center(
//               child: CircularProgressIndicator(color: Color(0xFF14c7eb)),
//             );
//           }

//           // ✅ 2. No data / API failed
//           if (!scheduleVM.isScheduleFetchLoading &&
//               scheduleVM.scheduleData.isEmpty) {
//             return const Center(child: Text("No schedule available"));
//           }
//           final instantList =
//               scheduleVM.scheduleData["instantConsultation"]
//                   as List<dynamic>? ??
//               [];

//           final appointmentList =
//               scheduleVM.scheduleData["appointmentConsultation"]
//                   as List<dynamic>? ??
//               [];

//           // enabled if list has data
//           final instantEnabled = instantList.isNotEmpty;
//           final appointmentEnabled = appointmentList.isNotEmpty;
//           return Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [bgTop, bgBottom],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     // ==============================
//                     // Current Availability (ONLY)
//                     // ==============================
//                     Container(
//                       decoration: cardDecoration(),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Header
//                             Row(
//                               children: [
//                                 Container(
//                                   height: 40,
//                                   width: 40,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(14),
//                                     color:
//                                         isDark
//                                             ? Colors.white.withOpacity(0.06)
//                                             : Colors.black.withOpacity(0.04),
//                                   ),
//                                   child: Icon(
//                                     LucideIcons.activity,
//                                     size: 18,
//                                     color:
//                                         isDark
//                                             ? Colors.white.withOpacity(0.88)
//                                             : Colors.black.withOpacity(0.82),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "Current Availability",
//                                         style: sectionStyle(18),
//                                       ),
//                                       const SizedBox(height: 2),
//                                       Text(
//                                         "Manage your weekly schedule from the next screen.",
//                                         style: bodyStyle(
//                                           13,
//                                         ).copyWith(color: subtleText),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             const SizedBox(height: 14),

//                             // Status Row
//                             Row(
//                               children: [
//                                 Text(
//                                   "Status:",
//                                   style: bodyStyle(
//                                     14,
//                                   ).copyWith(color: subtleText),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 12,
//                                     vertical: 7,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: statusChipBg(
//                                       scheduleVM.scheduleData?["status"],
//                                     ),
//                                     borderRadius: BorderRadius.circular(999),
//                                     border: Border.all(
//                                       color: statusChipBorder(
//                                         scheduleVM.scheduleData?["status"],
//                                       ),
//                                     ),
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Container(
//                                         height: 8,
//                                         width: 8,
//                                         decoration: BoxDecoration(
//                                           color: statusDotColor(
//                                             scheduleVM.scheduleData?["status"],
//                                           ),
//                                           borderRadius: BorderRadius.circular(
//                                             99,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Text(
//                                         scheduleVM.scheduleData?["status"] ??
//                                             "",
//                                         style: GoogleFonts.exo(
//                                           color: statusTextColor(
//                                             scheduleVM.scheduleData?["status"],
//                                           ),
//                                           fontWeight: FontWeight.w800,
//                                           fontSize: 13,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const Spacer(),
//                               ],
//                             ),

//                             const SizedBox(height: 14),

//                             // Services
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: pillFeature(
//                                     icon: LucideIcons.video,
//                                     title: "Instant Consultations",
//                                     enabled: instantEnabled,
//                                     glow:
//                                         instantEnabled
//                                             ? Colors.green
//                                             : Colors.red,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: pillFeature(
//                                     icon: LucideIcons.calendar,
//                                     title: "Appointment Consultations",
//                                     enabled: appointmentEnabled,
//                                     glow:
//                                         appointmentEnabled
//                                             ? Colors.green
//                                             : Colors.red,
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             const SizedBox(height: 14),

//                             // Days chips
//                             Text("Available days", style: sectionStyle(16)),
//                             const SizedBox(height: 10),
//                             Wrap(
//                               spacing: 10,
//                               runSpacing: 10,
//                               children:
//                                   (scheduleVM.scheduleData["availableDays"]
//                                               as List<dynamic>? ??
//                                           [])
//                                       .map(
//                                         (day) =>
//                                             _prettyChip(day.toString(), isDark),
//                                       )
//                                       .toList(),
//                             ),

//                             const SizedBox(height: 36),

//                             // CTA Button -> New screen
//                             ShadButton(
//                               width: double.infinity,
//                               height: 46,
//                               pressedBackgroundColor: Color(0xFF14c7eb),
//                               backgroundColor: Color(0xFF14c7eb),
//                               onPressed: () {
//                                 Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                     builder:
//                                         (_) =>
//                                             const UpdateWeeklyAvailabilityScreen(),
//                                   ),
//                                 );
//                               },
//                               child: Text(
//                                 "Update weekly availability",
//                                 style: GoogleFonts.exo(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w900,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 24),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _prettyChip(String text, bool isDark) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(999),
//         color:
//             isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF3F4F8),
//         border: Border.all(
//           color:
//               isDark
//                   ? Colors.white.withOpacity(0.10)
//                   : Colors.black.withOpacity(0.06),
//         ),
//       ),
//       child: Text(
//         text,
//         style: GoogleFonts.exo(
//           fontSize: 13,
//           fontWeight: FontWeight.w800,
//           color:
//               isDark
//                   ? Colors.white.withOpacity(0.85)
//                   : Colors.black.withOpacity(0.8),
//         ),
//       ),
//     );
//   }
// }

// ------------------------------------ 2222222222222222222222222222 --------------------
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/features/schedule/view/update_weekly_availability_screen.dart';
import 'package:wio_doctor/features/schedule/view_model/schedule_view_model.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ScheduleViewModel>(
        context,
        listen: false,
      ).fetchDoctorSchedule(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.06);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Availability',
          style: GoogleFonts.exo(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<ScheduleViewModel>(
        builder: (context, scheduleVM, child) {
          // Loading state
          if (scheduleVM.isScheduleFetchLoading &&
              scheduleVM.scheduleData.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF14c7eb)),
            );
          }

          // No data state
          if (!scheduleVM.isScheduleFetchLoading &&
              scheduleVM.scheduleData.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.calendar,
                    size: 64,
                    color:
                        isDark
                            ? Colors.white.withOpacity(0.3)
                            : Colors.black.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No schedule configured",
                    style: GoogleFonts.exo(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.7)
                              : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Set up your availability to start accepting appointments",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.exo(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.5)
                              : Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ShadButton(
                    backgroundColor: const Color(0xFF14c7eb),
                    pressedBackgroundColor: const Color(0xFF0EA5C9),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => const UpdateWeeklyAvailabilityScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Set up availability",
                      style: GoogleFonts.exo(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Extract data
          final status =
              scheduleVM.scheduleData["status"]?.toString() ?? "offline";
          final services =
              scheduleVM.scheduleData["services"] as List<dynamic>? ?? [];
          final instantList =
              scheduleVM.scheduleData["instantConsultation"]
                  as List<dynamic>? ??
              [];
          final appointmentList =
              scheduleVM.scheduleData["appointmentConsultation"]
                  as List<dynamic>? ??
              [];
          final availableDays =
              scheduleVM.scheduleData["availableDays"] as List<dynamic>? ?? [];
          final nextAvailable =
              scheduleVM.scheduleData["nextAvailable"]?.toString() ?? "";

          // Check if services are enabled
          final instantEnabled = instantList.isNotEmpty;
          final appointmentEnabled = appointmentList.isNotEmpty;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  "Current Availability",
                  style: GoogleFonts.exo(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "View your current schedule and availability settings",
                  style: GoogleFonts.exo(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color:
                        isDark ? Colors.white.withOpacity(0.7) : Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),

                // Main Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _getStatusColor(status).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                color: _getStatusColor(status),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Status",
                                    style: GoogleFonts.exo(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          isDark
                                              ? Colors.white.withOpacity(0.6)
                                              : Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatStatus(status),
                                    style: GoogleFonts.exo(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color:
                                          isDark
                                              ? Colors.white
                                              : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Services Offered
                      Text(
                        "Services Offered",
                        style: GoogleFonts.exo(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _serviceCard(
                              isDark: isDark,
                              icon: LucideIcons.video,
                              title: "Instant Video",
                              enabled: instantEnabled,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _serviceCard(
                              isDark: isDark,
                              icon: LucideIcons.calendar,
                              title: "Appointments",
                              enabled: appointmentEnabled,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Next Available
                      if (nextAvailable.isNotEmpty) ...[
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF14c7eb).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                LucideIcons.calendar,
                                color: Color(0xFF14c7eb),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Next Available",
                                    style: GoogleFonts.exo(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          isDark
                                              ? Colors.white.withOpacity(0.6)
                                              : Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatDate(nextAvailable),
                                    style: GoogleFonts.exo(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          isDark
                                              ? Colors.white
                                              : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Available Days
                      Text(
                        "Available Days",
                        style: GoogleFonts.exo(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (availableDays.isEmpty)
                        Text(
                          "No days configured",
                          style: GoogleFonts.exo(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                isDark
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.black45,
                          ),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              availableDays
                                  .map(
                                    (day) => _dayChip(isDark, day.toString()),
                                  )
                                  .toList(),
                        ),

                      const SizedBox(height: 24),

                      // Consultation Slots
                      if (instantList.isNotEmpty) ...[
                        _slotsSection(
                          isDark: isDark,
                          title: "Instant Consultation Slots",
                          icon: LucideIcons.zap,
                          slots: instantList,
                          color: const Color(0xFFEF4444),
                        ),
                        const SizedBox(height: 16),
                      ],

                      if (appointmentList.isNotEmpty) ...[
                        _slotsSection(
                          isDark: isDark,
                          title: "Appointment Slots",
                          icon: LucideIcons.calendar,
                          slots: appointmentList,
                          color: const Color(0xFF6366F1),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Update Button
                      ShadButton(
                        width: double.infinity,
                        height: 50,
                        backgroundColor: const Color(0xFF14c7eb),
                        pressedBackgroundColor: const Color(0xFF0EA5C9),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => const UpdateWeeklyAvailabilityScreen(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              LucideIcons.pencil,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Update Availability",
                              style: GoogleFonts.exo(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _serviceCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required bool enabled,
  }) {
    final color = enabled ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            enabled ? LucideIcons.circleCheck : LucideIcons.x,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.exo(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dayChip(bool isDark, String day) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color:
              isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.06),
        ),
      ),
      child: Text(
        day,
        style: GoogleFonts.exo(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _slotsSection({
    required bool isDark,
    required String title,
    required IconData icon,
    required List<dynamic> slots,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.exo(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...slots.map((slot) {
          final label = slot['label']?.toString() ?? '';
          final time = slot['time']?.toString() ?? '';

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  isDark
                      ? Colors.white.withOpacity(0.04)
                      : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color:
                    isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.black.withOpacity(0.06),
              ),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.clock, size: 16, color: color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.exo(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.exo(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color:
                        isDark ? Colors.white.withOpacity(0.7) : Colors.black54,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return const Color(0xFF10B981);
      case 'appointment':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFFEF4444);
    }
  }

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'online':
        return 'Online';
      case 'appointment':
        return 'Appointment Only';
      default:
        return 'Offline';
    }
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return "${months[date.month - 1]} ${date.day}, ${date.year}";
    } catch (e) {
      return isoDate;
    }
  }
}
