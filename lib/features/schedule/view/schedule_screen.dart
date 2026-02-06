// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shadcn_ui/shadcn_ui.dart';
// import 'package:wio_doctor/core/theme/theme_provider.dart';

// class ScheduleScreen extends StatefulWidget {
//   const ScheduleScreen({super.key});

//   @override
//   State<ScheduleScreen> createState() => _ScheduleScreenState();
// }

// class _ScheduleScreenState extends State<ScheduleScreen> {
//   final List<TextEditingController> _slotDayControllers = [];
//   final List<TextEditingController> _slotTimeControllers = [];

//   @override
//   void dispose() {
//     for (final c in _slotDayControllers) {
//       c.dispose();
//     }
//     for (final c in _slotTimeControllers) {
//       c.dispose();
//     }
//     super.dispose();
//   }

//   Future<void> _pickTime(int index) async {
//     final now = TimeOfDay.now();
//     final picked = await showTimePicker(context: context, initialTime: now);
//     if (picked == null) return;

//     final formatted = picked.format(context);
//     setState(() {
//       _slotTimeControllers[index].text = formatted;
//     });
//   }

//   void _addSlotRow() {
//     setState(() {
//       _slotDayControllers.add(TextEditingController());
//       _slotTimeControllers.add(TextEditingController());
//     });
//   }

//   void _removeSlotRow(int index) {
//     setState(() {
//       _slotDayControllers[index].dispose();
//       _slotTimeControllers[index].dispose();
//       _slotDayControllers.removeAt(index);
//       _slotTimeControllers.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = ThemeProvider.of(context);
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
//       fontWeight: FontWeight.w700,
//       fontSize: size,
//       letterSpacing: -0.2,
//     );

//     TextStyle sectionStyle(double size) =>
//         GoogleFonts.exo(fontWeight: FontWeight.w700, fontSize: size);

//     TextStyle bodyStyle(double size) =>
//         GoogleFonts.exo(fontWeight: FontWeight.w500, fontSize: size);

//     InputDecoration niceInputDecoration({
//       required String hint,
//       required IconData icon,
//     }) {
//       return InputDecoration(
//         hintText: hint,
//         hintStyle: GoogleFonts.exo(
//           color: subtleText,
//           fontWeight: FontWeight.w500,
//         ),
//         prefixIcon: Icon(icon, size: 18),
//         filled: true,
//         fillColor:
//             isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF3F4F8),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 12,
//           vertical: 12,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: borderColor),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: borderColor),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             color:
//                 isDark
//                     ? Colors.white.withOpacity(0.18)
//                     : Colors.black.withOpacity(0.12),
//           ),
//         ),
//       );
//     }

//     BoxDecoration cardDecoration() {
//       return BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: borderColor),
//         boxShadow: [
//           BoxShadow(
//             color:
//                 isDark
//                     ? Colors.black.withOpacity(0.35)
//                     : Colors.black.withOpacity(0.06),
//             blurRadius: 18,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       );
//     }

//     Widget cardWrapper({required Widget child}) {
//       return Container(decoration: cardDecoration(), child: child);
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Schedule & Availability', style: titleStyle(20)),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             tooltip: isDark ? "Switch to light" : "Switch to dark",
//             icon: Icon(isDark ? LucideIcons.sun : LucideIcons.moon),
//             onPressed: () {
//               themeProvider.setThemeMode(
//                 isDark ? ThemeMode.light : ThemeMode.dark,
//               );
//             },
//           ),
//           const SizedBox(width: 6),
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [bgTop, bgBottom],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Current Availability Section
//                 cardWrapper(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       spacing: 16,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               height: 36,
//                               width: 36,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 color:
//                                     isDark
//                                         ? Colors.white.withOpacity(0.06)
//                                         : Colors.black.withOpacity(0.04),
//                               ),
//                               child: Icon(
//                                 LucideIcons.activity,
//                                 size: 18,
//                                 color:
//                                     isDark
//                                         ? Colors.white.withOpacity(0.85)
//                                         : Colors.black.withOpacity(0.8),
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Text(
//                               "Current Availability",
//                               style: sectionStyle(18),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               "Status:",
//                               style: bodyStyle(14).copyWith(color: subtleText),
//                             ),
//                             const SizedBox(width: 10),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 7,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.red.withOpacity(
//                                   isDark ? 0.18 : 0.12,
//                                 ),
//                                 borderRadius: BorderRadius.circular(999),
//                                 border: Border.all(
//                                   color: Colors.red.withOpacity(
//                                     isDark ? 0.35 : 0.25,
//                                   ),
//                                 ),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Container(
//                                     height: 8,
//                                     width: 8,
//                                     decoration: BoxDecoration(
//                                       color: Colors.redAccent,
//                                       borderRadius: BorderRadius.circular(99),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Text(
//                                     "Offline",
//                                     style: GoogleFonts.exo(
//                                       color:
//                                           isDark
//                                               ? Colors.white.withOpacity(0.9)
//                                               : Colors.red.shade900,
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 13,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           spacing: 12,
//                           children: [
//                             Expanded(
//                               child: cardWrapper(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(12),
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         height: 34,
//                                         width: 34,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                             12,
//                                           ),
//                                           color: Colors.green.withOpacity(
//                                             isDark ? 0.12 : 0.10,
//                                           ),
//                                           border: Border.all(
//                                             color: Colors.green.withOpacity(
//                                               isDark ? 0.25 : 0.18,
//                                             ),
//                                           ),
//                                         ),
//                                         child: const Icon(
//                                           LucideIcons.check,
//                                           size: 18,
//                                           color: Colors.green,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 10),
//                                       Expanded(
//                                         child: Text(
//                                           "Instant Consultations",
//                                           style: bodyStyle(14).copyWith(
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: cardWrapper(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(12),
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         height: 34,
//                                         width: 34,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                             12,
//                                           ),
//                                           color: Colors.green.withOpacity(
//                                             isDark ? 0.12 : 0.10,
//                                           ),
//                                           border: Border.all(
//                                             color: Colors.green.withOpacity(
//                                               isDark ? 0.25 : 0.18,
//                                             ),
//                                           ),
//                                         ),
//                                         child: const Icon(
//                                           LucideIcons.check,
//                                           size: 18,
//                                           color: Colors.green,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 10),
//                                       Expanded(
//                                         child: Text(
//                                           "Appointment Consultations",
//                                           style: bodyStyle(14).copyWith(
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Available days", style: sectionStyle(16)),
//                             const SizedBox(height: 10),
//                             Wrap(
//                               spacing: 10,
//                               runSpacing: 10,
//                               children: [
//                                 _prettyChip("Monday", isDark),
//                                 _prettyChip("Tuesday", isDark),
//                                 _prettyChip("Wednesday", isDark),
//                                 _prettyChip("Thursday", isDark),
//                                 _prettyChip("Friday", isDark),
//                                 _prettyChip("Saturday", isDark),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 14),

//                 // Update weekly Availability
//                 cardWrapper(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       spacing: 16,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               height: 36,
//                               width: 36,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 color:
//                                     isDark
//                                         ? Colors.white.withOpacity(0.06)
//                                         : Colors.black.withOpacity(0.04),
//                               ),
//                               child: Icon(
//                                 LucideIcons.calendarClock,
//                                 size: 18,
//                                 color:
//                                     isDark
//                                         ? Colors.white.withOpacity(0.85)
//                                         : Colors.black.withOpacity(0.8),
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Text(
//                               "Update Weekly Availability",
//                               style: sectionStyle(18),
//                             ),
//                           ],
//                         ),

//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Service offered", style: sectionStyle(16)),
//                             const SizedBox(height: 10),

//                             _serviceRow(
//                               isDark: isDark,
//                               checked: false,
//                               onChanged: (val) {},
//                               icon: LucideIcons.video,
//                               title: "Instant video Consultations",
//                             ),
//                             const SizedBox(height: 8),
//                             _serviceRow(
//                               isDark: isDark,
//                               checked: false,
//                               onChanged: (val) {},
//                               icon: LucideIcons.calendar,
//                               title: "Online Appointment",
//                             ),
//                             const SizedBox(height: 8),
//                             _serviceRow(
//                               isDark: isDark,
//                               checked: false,
//                               onChanged: (val) {},
//                               icon: LucideIcons.building,
//                               title: "In Clinic Appointment",
//                             ),
//                           ],
//                         ),

//                         Column(
//                           spacing: 12,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Consultation Duration",
//                               style: sectionStyle(16),
//                             ),
//                             Row(
//                               spacing: 10,
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color:
//                                           isDark
//                                               ? Colors.white.withOpacity(0.04)
//                                               : const Color(0xFFF3F4F8),
//                                       border: Border.all(color: borderColor),
//                                       borderRadius: BorderRadius.circular(14),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 12,
//                                         vertical: 12,
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             "30 Minutes",
//                                             style: bodyStyle(14).copyWith(
//                                               fontWeight: FontWeight.w700,
//                                             ),
//                                           ),
//                                           Icon(
//                                             LucideIcons.circleCheck,
//                                             color: Colors.green,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color:
//                                           isDark
//                                               ? Colors.white.withOpacity(0.04)
//                                               : const Color(0xFFF3F4F8),
//                                       border: Border.all(color: borderColor),
//                                       borderRadius: BorderRadius.circular(14),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 12,
//                                         vertical: 12,
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             "60 Minutes",
//                                             style: bodyStyle(14).copyWith(
//                                               fontWeight: FontWeight.w700,
//                                             ),
//                                           ),
//                                           Icon(
//                                             LucideIcons.circleCheck,
//                                             color: Colors.green,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 14),

//                 // Instant Consultation slots
//                 cardWrapper(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       spacing: 14,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Instant Consultation Slots",
//                               style: sectionStyle(18),
//                             ),
//                             InkWell(
//                               borderRadius: BorderRadius.circular(999),
//                               onTap: _addSlotRow,
//                               child: Container(
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(999),
//                                   color:
//                                       isDark
//                                           ? Colors.white.withOpacity(0.06)
//                                           : Colors.black.withOpacity(0.05),
//                                   border: Border.all(color: borderColor),
//                                 ),
//                                 child: Icon(
//                                   LucideIcons.plus,
//                                   size: 18,
//                                   color:
//                                       isDark
//                                           ? Colors.white.withOpacity(0.9)
//                                           : Colors.black.withOpacity(0.8),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Text(
//                           "Set your available time slots for instant consultations.",
//                           style: bodyStyle(14).copyWith(color: subtleText),
//                         ),

//                         if (_slotDayControllers.isEmpty)
//                           Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.all(14),
//                             decoration: BoxDecoration(
//                               color:
//                                   isDark
//                                       ? Colors.white.withOpacity(0.03)
//                                       : const Color(0xFFF3F4F8),
//                               borderRadius: BorderRadius.circular(14),
//                               border: Border.all(color: borderColor),
//                             ),
//                             child: Text(
//                               "No slots added yet. Tap + to add your first slot.",
//                               style: bodyStyle(13).copyWith(color: subtleText),
//                             ),
//                           ),

//                         for (int i = 0; i < _slotDayControllers.length; i++)
//                           Row(
//                             spacing: 6,
//                             children: [
//                               Expanded(
//                                 child: TextField(
//                                   controller: _slotDayControllers[i],
//                                   style: bodyStyle(14),
//                                   decoration: niceInputDecoration(
//                                     hint: "Day (e.g., Monday)",
//                                     icon: LucideIcons.calendarDays,
//                                   ),
//                                 ),
//                               ),

//                               Expanded(
//                                 child: TextField(
//                                   controller: _slotTimeControllers[i],
//                                   readOnly: true,
//                                   onTap: () => _pickTime(i),
//                                   style: bodyStyle(14),
//                                   decoration: niceInputDecoration(
//                                     hint: "Time (tap to pick)",
//                                     icon: LucideIcons.clock,
//                                   ),
//                                 ),
//                               ),

//                               InkWell(
//                                 borderRadius: BorderRadius.circular(12),
//                                 onTap: () => _removeSlotRow(i),
//                                 child: Container(
//                                   padding: const EdgeInsets.all(5),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(12),
//                                     color: Colors.red.withOpacity(
//                                       isDark ? 0.14 : 0.10,
//                                     ),
//                                     border: Border.all(
//                                       color: Colors.red.withOpacity(
//                                         isDark ? 0.35 : 0.22,
//                                       ),
//                                     ),
//                                   ),
//                                   child: const Icon(
//                                     LucideIcons.minus,
//                                     size: 18,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 24),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // kept inline style helpers (not reusable widgets elsewhere)
//   Widget _serviceRow({
//     required bool isDark,
//     required bool checked,
//     required ValueChanged<bool?> onChanged,
//     required IconData icon,
//     required String title,
//   }) {
//     final borderColor =
//         isDark
//             ? Colors.white.withOpacity(0.08)
//             : Colors.black.withOpacity(0.06);

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//       decoration: BoxDecoration(
//         color:
//             isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF3F4F8),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: borderColor),
//       ),
//       child: Row(
//         children: [
//           Checkbox(
//             value: checked,
//             onChanged: onChanged,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(6),
//             ),
//           ),
//           const SizedBox(width: 6),
//           Icon(icon, size: 20),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               title,
//               style: GoogleFonts.exo(fontSize: 15, fontWeight: FontWeight.w700),
//             ),
//           ),
//         ],
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
//           fontWeight: FontWeight.w700,
//           color:
//               isDark
//                   ? Colors.white.withOpacity(0.85)
//                   : Colors.black.withOpacity(0.8),
//         ),
//       ),
//     );
//   }
// }

// --------------------------- 222222222222222222222222222222 ----------------------------------
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';
import 'package:wio_doctor/features/schedule/view/update_weekly_availability_screen.dart';

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

                        const SizedBox(height: 16),

                        // CTA Button -> New screen
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          const UpdateWeeklyAvailabilityScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              "Update weekly availability",
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
