// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:shadcn_ui/shadcn_ui.dart';
// import 'package:wio_doctor/core/theme/theme_provider.dart';
// import 'package:wio_doctor/features/schedule/view_model/schedule_view_model.dart';

// /// ✅ Slots managed inside ScheduleViewModel
// /// ✅ Removed DatePickerProvider (uses scheduleVM.pickDate)
// class UpdateWeeklyAvailabilityScreen extends StatefulWidget {
//   const UpdateWeeklyAvailabilityScreen({super.key});

//   @override
//   State<UpdateWeeklyAvailabilityScreen> createState() =>
//       _UpdateWeeklyAvailabilityScreenState();
// }

// class _UpdateWeeklyAvailabilityScreenState
//     extends State<UpdateWeeklyAvailabilityScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = context.read<ThemeViewModel>();
//     ;
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

//     InputDecoration niceInputDecoration({
//       required String hint,
//       required IconData icon,
//     }) {
//       return InputDecoration(
//         hintText: hint,
//         hintStyle: GoogleFonts.exo(
//           color: subtleText,
//           fontWeight: FontWeight.w600,
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

//     Widget cardWrap(Widget child) =>
//         Container(decoration: cardDecoration(), child: child);

//     Widget addCircleButton(VoidCallback onTap) {
//       return InkWell(
//         borderRadius: BorderRadius.circular(999),
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(999),
//             color:
//                 isDark
//                     ? Colors.white.withOpacity(0.06)
//                     : Colors.black.withOpacity(0.05),
//             border: Border.all(color: borderColor),
//           ),
//           child: Icon(
//             LucideIcons.plus,
//             size: 18,
//             color:
//                 isDark
//                     ? Colors.white.withOpacity(0.9)
//                     : Colors.black.withOpacity(0.8),
//           ),
//         ),
//       );
//     }

//     Widget minusButton(VoidCallback onTap) {
//       return InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.all(5),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             color: Colors.red.withOpacity(isDark ? 0.14 : 0.10),
//             border: Border.all(
//               color: Colors.red.withOpacity(isDark ? 0.35 : 0.22),
//             ),
//           ),
//           child: const Icon(LucideIcons.minus, size: 18, color: Colors.red),
//         ),
//       );
//     }

//     Widget emptyHint(String text) {
//       return Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color:
//               isDark ? Colors.white.withOpacity(0.03) : const Color(0xFFF3F4F8),
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: borderColor),
//         ),
//         child: Text(text, style: bodyStyle(13).copyWith(color: subtleText)),
//       );
//     }

//     Widget serviceTile({
//       required IconData icon,
//       required String title,
//       required bool value,
//       required ValueChanged<bool?> onChanged,
//     }) {
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//         decoration: BoxDecoration(
//           color:
//               isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF3F4F8),
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: borderColor),
//         ),
//         child: Row(
//           children: [
//             Checkbox(
//               value: value,
//               onChanged: onChanged,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(6),
//               ),
//             ),
//             const SizedBox(width: 6),
//             Icon(icon, size: 20),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 title,
//                 style: GoogleFonts.exo(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     final scheduleVM = context.watch<ScheduleViewModel>();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Update Weekly Availability', style: titleStyle(18)),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [bgTop, bgBottom],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   // ===========================
//                   // A) Services + Duration
//                   // ===========================
//                   cardWrap(
//                     Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Container(
//                                 height: 40,
//                                 width: 40,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(14),
//                                   color:
//                                       isDark
//                                           ? Colors.white.withOpacity(0.06)
//                                           : Colors.black.withOpacity(0.04),
//                                 ),
//                                 child: Icon(
//                                   LucideIcons.calendarClock,
//                                   size: 18,
//                                   color:
//                                       isDark
//                                           ? Colors.white.withOpacity(0.88)
//                                           : Colors.black.withOpacity(0.82),
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Weekly Availability",
//                                       style: sectionStyle(18),
//                                     ),
//                                     const SizedBox(height: 2),
//                                     Text(
//                                       "Choose services, duration, slots, and schedule.",
//                                       style: bodyStyle(
//                                         13,
//                                       ).copyWith(color: subtleText),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),

//                           const SizedBox(height: 16),

//                           Text("Service offered", style: sectionStyle(16)),
//                           const SizedBox(height: 10),

//                           serviceTile(
//                             icon: LucideIcons.video,
//                             title: "Instant video consultations",
//                             value: scheduleVM.instantVideo,
//                             onChanged:
//                                 (value) => scheduleVM.toggleInstantVideo(
//                                   value ?? false,
//                                 ),
//                           ),
//                           const SizedBox(height: 10),
//                           serviceTile(
//                             icon: LucideIcons.calendar,
//                             title: "Online appointment",
//                             value: scheduleVM.onlineAppointment,
//                             onChanged:
//                                 (value) => scheduleVM.toggleOnlineAppointment(
//                                   value ?? false,
//                                 ),
//                           ),
//                           const SizedBox(height: 10),
//                           serviceTile(
//                             icon: LucideIcons.building,
//                             title: "In clinic appointment",
//                             value: scheduleVM.inClinicAppointment,
//                             onChanged:
//                                 (value) => scheduleVM.toggleClinicAppointment(
//                                   value ?? false,
//                                 ),
//                           ),

//                           const SizedBox(height: 18),

//                           Text(
//                             "Consultation Duration",
//                             style: sectionStyle(16),
//                           ),
//                           const SizedBox(height: 10),

//                           Wrap(
//                             spacing: 10,
//                             children:
//                                 [15, 30, 45, 60].map((minutes) {
//                                   final selected =
//                                       scheduleVM.durationMinutes == minutes;

//                                   return ChoiceChip(
//                                     label: Text("$minutes min"),
//                                     selected: selected,
//                                     onSelected:
//                                         (_) => scheduleVM.setDuration(minutes),
//                                   );
//                                 }).toList(),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 14),

//                   // ===========================
//                   // B) Instant Consultation Slots
//                   // ===========================
//                   cardWrap(
//                     Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Instant Consultation Slots",
//                                 style: sectionStyle(18),
//                               ),
//                               addCircleButton(scheduleVM.addInstantSlot),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             "Set your available time slots for instant consultations.",
//                             style: bodyStyle(14).copyWith(color: subtleText),
//                           ),
//                           const SizedBox(height: 12),

//                           if (scheduleVM.instantSlots.isEmpty)
//                             emptyHint(
//                               "No instant slots added yet. Tap + to add your first slot.",
//                             ),

//                           for (
//                             int i = 0;
//                             i < scheduleVM.instantSlots.length;
//                             i++
//                           )
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 10),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: TextField(
//                                       controller:
//                                           scheduleVM.instantSlots[i].dayCtrl,
//                                       style: bodyStyle(14),
//                                       decoration: niceInputDecoration(
//                                         hint: "Day (e.g., Monday)",
//                                         icon: LucideIcons.calendarDays,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Expanded(
//                                     child: TextField(
//                                       controller:
//                                           scheduleVM.instantSlots[i].timeCtrl,
//                                       readOnly: true,
//                                       onTap:
//                                           () => scheduleVM.pickTime(
//                                             context: context,
//                                             controller:
//                                                 scheduleVM
//                                                     .instantSlots[i]
//                                                     .timeCtrl,
//                                           ),
//                                       style: bodyStyle(14),
//                                       decoration: niceInputDecoration(
//                                         hint: "Time (tap to pick)",
//                                         icon: LucideIcons.clock,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   minusButton(
//                                     () => scheduleVM.removeInstantSlot(i),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 14),

//                   // ===========================
//                   // C) Appointment Consultation Slots
//                   // ===========================
//                   cardWrap(
//                     Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Appointment Consultation Slots",
//                                 style: sectionStyle(18),
//                               ),
//                               addCircleButton(scheduleVM.addAppointmentSlot),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             "Set your available time slots for appointment consultations.",
//                             style: bodyStyle(14).copyWith(color: subtleText),
//                           ),
//                           const SizedBox(height: 12),

//                           if (scheduleVM.appointmentSlots.isEmpty)
//                             emptyHint(
//                               "No appointment slots added yet. Tap + to add your first slot.",
//                             ),

//                           for (
//                             int i = 0;
//                             i < scheduleVM.appointmentSlots.length;
//                             i++
//                           )
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 10),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: TextField(
//                                       controller:
//                                           scheduleVM
//                                               .appointmentSlots[i]
//                                               .dayCtrl,
//                                       style: bodyStyle(14),
//                                       decoration: niceInputDecoration(
//                                         hint: "Day (e.g., Thursday)",
//                                         icon: LucideIcons.calendarDays,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Expanded(
//                                     child: TextField(
//                                       controller:
//                                           scheduleVM
//                                               .appointmentSlots[i]
//                                               .timeCtrl,
//                                       readOnly: true,
//                                       onTap:
//                                           () => scheduleVM.pickTime(
//                                             context: context,
//                                             controller:
//                                                 scheduleVM
//                                                     .appointmentSlots[i]
//                                                     .timeCtrl,
//                                           ),
//                                       style: bodyStyle(14),
//                                       decoration: niceInputDecoration(
//                                         hint: "Time (tap to pick)",
//                                         icon: LucideIcons.clock,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   minusButton(
//                                     () => scheduleVM.removeAppointmentSlot(i),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 14),

//                   // ===========================
//                   // D) Status + Next availability + Timezone
//                   // ===========================
//                   cardWrap(
//                     Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Availability Settings",
//                             style: sectionStyle(18),
//                           ),
//                           const SizedBox(height: 12),

//                           Text("Status", style: sectionStyle(16)),
//                           const SizedBox(height: 10),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12),
//                             decoration: BoxDecoration(
//                               color:
//                                   isDark
//                                       ? Colors.white.withOpacity(0.04)
//                                       : const Color(0xFFF3F4F8),
//                               border: Border.all(color: borderColor),
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                             child: DropdownButtonHideUnderline(
//                               child: DropdownButton<String>(
//                                 value: scheduleVM.status,
//                                 isExpanded: true,
//                                 items: const [
//                                   DropdownMenuItem(
//                                     value: "Online",
//                                     child: Text("Online"),
//                                   ),
//                                   DropdownMenuItem(
//                                     value: "Appointment only",
//                                     child: Text("Appointment only"),
//                                   ),
//                                   DropdownMenuItem(
//                                     value: "Offline",
//                                     child: Text("Offline"),
//                                   ),
//                                 ],
//                                 onChanged: (v) {
//                                   if (v == null) return;
//                                   scheduleVM.setStatus(v);
//                                 },
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 14),

//                           Text("Next available date", style: sectionStyle(16)),
//                           const SizedBox(height: 10),
//                           InkWell(
//                             borderRadius: BorderRadius.circular(14),
//                             onTap: () => scheduleVM.pickDate(context: context),
//                             child: Container(
//                               width: double.infinity,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 12,
//                               ),
//                               decoration: BoxDecoration(
//                                 color:
//                                     isDark
//                                         ? Colors.white.withOpacity(0.04)
//                                         : const Color(0xFFF3F4F8),
//                                 border: Border.all(color: borderColor),
//                                 borderRadius: BorderRadius.circular(14),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Icon(LucideIcons.calendar, size: 18),
//                                   const SizedBox(width: 10),
//                                   Expanded(
//                                     child: Text(
//                                       scheduleVM.nextAvailableDate == null
//                                           ? "Tap to pick a date"
//                                           : "${scheduleVM.nextAvailableDate!.day.toString().padLeft(2, '0')}-"
//                                               "${scheduleVM.nextAvailableDate!.month.toString().padLeft(2, '0')}-"
//                                               "${scheduleVM.nextAvailableDate!.year}",
//                                       style: bodyStyle(
//                                         14,
//                                       ).copyWith(fontWeight: FontWeight.w900),
//                                     ),
//                                   ),
//                                   Icon(
//                                     LucideIcons.chevronRight,
//                                     size: 18,
//                                     color: subtleText,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 14),

//                           Text("Time zone", style: sectionStyle(16)),
//                           const SizedBox(height: 10),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12),
//                             decoration: BoxDecoration(
//                               color:
//                                   isDark
//                                       ? Colors.white.withOpacity(0.04)
//                                       : const Color(0xFFF3F4F8),
//                               border: Border.all(color: borderColor),
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                             child: DropdownButtonHideUnderline(
//                               child: DropdownButton<String>(
//                                 value: scheduleVM.timeZone,
//                                 isExpanded: true,
//                                 items: const [
//                                   DropdownMenuItem(
//                                     value: "Asia/Dhaka",
//                                     child: Text("Asia/Dhaka"),
//                                   ),
//                                   DropdownMenuItem(
//                                     value: "Asia/Kolkata",
//                                     child: Text("Asia/Kolkata"),
//                                   ),
//                                   DropdownMenuItem(
//                                     value: "Asia/Dubai",
//                                     child: Text("Asia/Dubai"),
//                                   ),
//                                   DropdownMenuItem(
//                                     value: "Europe/London",
//                                     child: Text("Europe/London"),
//                                   ),
//                                   DropdownMenuItem(
//                                     value: "America/New_York",
//                                     child: Text("America/New_York"),
//                                   ),
//                                 ],
//                                 onChanged: (v) {
//                                   if (v == null) return;
//                                   scheduleVM.setTimeZone(v);
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 14),

//                   // ===========================
//                   // E) Weekly Schedule (7 days) From-To + enable toggle
//                   // ===========================
//                   cardWrap(
//                     Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Weekly Schedule", style: sectionStyle(18)),
//                           const SizedBox(height: 8),
//                           Text(
//                             "Enable each day and set From–To time.",
//                             style: bodyStyle(14).copyWith(color: subtleText),
//                           ),
//                           const SizedBox(height: 12),

//                           ...List.generate(scheduleVM.weekRows.length, (i) {
//                             final row = scheduleVM.weekRows[i];

//                             return Container(
//                               margin: const EdgeInsets.only(bottom: 10),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 12,
//                               ),
//                               decoration: BoxDecoration(
//                                 color:
//                                     isDark
//                                         ? Colors.white.withOpacity(0.04)
//                                         : const Color(0xFFF3F4F8),
//                                 borderRadius: BorderRadius.circular(14),
//                                 border: Border.all(color: borderColor),
//                               ),
//                               child: Row(
//                                 children: [
//                                   InkWell(
//                                     borderRadius: BorderRadius.circular(999),
//                                     onTap: () => scheduleVM.toggleWeekDay(i),
//                                     child: Container(
//                                       height: 22,
//                                       width: 22,
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         border: Border.all(
//                                           width: 2,
//                                           color:
//                                               row.enabled
//                                                   ? Colors.green
//                                                   : (isDark
//                                                       ? Colors.white
//                                                           .withOpacity(0.25)
//                                                       : Colors.black
//                                                           .withOpacity(0.25)),
//                                         ),
//                                       ),
//                                       child:
//                                           row.enabled
//                                               ? Center(
//                                                 child: Container(
//                                                   height: 10,
//                                                   width: 10,
//                                                   decoration:
//                                                       const BoxDecoration(
//                                                         color: Colors.green,
//                                                         shape: BoxShape.circle,
//                                                       ),
//                                                 ),
//                                               )
//                                               : const SizedBox.shrink(),
//                                     ),
//                                   ),

//                                   const SizedBox(width: 10),

//                                   Expanded(
//                                     child: Text(
//                                       row.day,
//                                       style: bodyStyle(
//                                         14,
//                                       ).copyWith(fontWeight: FontWeight.w900),
//                                     ),
//                                   ),

//                                   Column(
//                                     children: [
//                                       SizedBox(
//                                         width: 120,
//                                         child: TextField(
//                                           controller: row.fromController,
//                                           readOnly: true,
//                                           onTap:
//                                               row.enabled
//                                                   ? () => scheduleVM.pickTime(
//                                                     context: context,
//                                                     controller:
//                                                         row.fromController,
//                                                   )
//                                                   : null,
//                                           decoration: niceInputDecoration(
//                                             hint: "From",
//                                             icon: LucideIcons.clock,
//                                           ),
//                                           style: bodyStyle(13).copyWith(
//                                             fontWeight: FontWeight.w900,
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       SizedBox(
//                                         width: 120,
//                                         child: TextField(
//                                           controller: row.toController,
//                                           readOnly: true,
//                                           onTap:
//                                               row.enabled
//                                                   ? () => scheduleVM.pickTime(
//                                                     context: context,
//                                                     controller:
//                                                         row.toController,
//                                                   )
//                                                   : null,
//                                           decoration: niceInputDecoration(
//                                             hint: "To",
//                                             icon: LucideIcons.clock,
//                                           ),
//                                           style: bodyStyle(13).copyWith(
//                                             fontWeight: FontWeight.w900,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   // ===========================
//                   // Save button
//                   // ===========================
//                   ShadButton(
//                     width: double.infinity,
//                     height: 46,
//                     backgroundColor: Color(0xFF14c7eb),
//                     pressedBackgroundColor: Color(0xFF14c7eb),
//                     onPressed: () async {
//                       scheduleVM.printAllData();
//                       await scheduleVM.updateWeeklyAvailability(context);
//                     },
//                     child:
//                         scheduleVM.isWeeklyAvailabilityUpdateLoading
//                             ? const Icon(
//                               LucideIcons.loader,
//                               color: Colors.white,
//                               size: 22,
//                             )
//                             : Text(
//                               "Save changes",
//                               style: GoogleFonts.exo(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w900,
//                               ),
//                             ),
//                   ),

//                   const SizedBox(height: 24),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ----------------------------- 222222222222222222222222222 -----------------------------------
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/features/schedule/view_model/schedule_view_model.dart';

class UpdateWeeklyAvailabilityScreen extends StatefulWidget {
  const UpdateWeeklyAvailabilityScreen({super.key});

  @override
  State<UpdateWeeklyAvailabilityScreen> createState() =>
      _UpdateWeeklyAvailabilityScreenState();
}

class _UpdateWeeklyAvailabilityScreenState
    extends State<UpdateWeeklyAvailabilityScreen> {
  @override
  void initState() {
    super.initState();
    // Pre-populate data if editing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<ScheduleViewModel>(context, listen: false);
      vm.hydrateFromExistingData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = Provider.of<ScheduleViewModel>(context);

    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.06);
    final subtleText =
        isDark ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.5);

    InputDecoration inputDecoration({
      required String hint,
      required IconData icon,
    }) {
      return InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.exo(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: subtleText,
        ),
        prefixIcon: Icon(icon, size: 18, color: subtleText),
        filled: true,
        fillColor:
            isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF3F4F6),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF14c7eb)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Update Weekly Availability',
          style: GoogleFonts.exo(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              "Configure your availability",
              style: GoogleFonts.exo(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: subtleText,
              ),
            ),
            const SizedBox(height: 24),

            // Services Offered Card
            _buildCard(
              isDark: isDark,
              borderColor: borderColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _sectionHeader(
                    isDark: isDark,
                    icon: LucideIcons.briefcase,
                    title: "Services Offered",
                    subtitle: "Select the services you provide",
                  ),
                  const SizedBox(height: 16),
                  _serviceCheckbox(
                    isDark: isDark,
                    icon: LucideIcons.video,
                    label: "Instant video consultations",
                    value: vm.instantVideo,
                    onChanged: vm.toggleInstantVideo,
                  ),
                  const SizedBox(height: 12),
                  _serviceCheckbox(
                    isDark: isDark,
                    icon: LucideIcons.calendar,
                    label: "Online appointment",
                    value: vm.onlineAppointment,
                    onChanged: vm.toggleOnlineAppointment,
                  ),
                  const SizedBox(height: 12),
                  _serviceCheckbox(
                    isDark: isDark,
                    icon: LucideIcons.building2,
                    label: "In clinic appointment",
                    value: vm.inClinicAppointment,
                    onChanged: vm.toggleClinicAppointment,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Consultation Duration",
                    style: GoogleFonts.exo(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children:
                        [30, 60].map((minutes) {
                          final isSelected = vm.durationMinutes == minutes;
                          return InkWell(
                            onTap: () => vm.setDuration(minutes),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? const Color(0xFF14c7eb)
                                        : (isDark
                                            ? Colors.white.withOpacity(0.05)
                                            : const Color(0xFFF3F4F6)),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? const Color(0xFF14c7eb)
                                          : borderColor,
                                ),
                              ),
                              child: Text(
                                "$minutes min",
                                style: GoogleFonts.exo(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : (isDark
                                              ? Colors.white
                                              : Colors.black87),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Instant Consultation Slots
            _buildCard(
              isDark: isDark,
              borderColor: borderColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _sectionHeader(
                          isDark: isDark,
                          icon: LucideIcons.zap,
                          title: "Instant Consultation Slots",
                          subtitle: "Add your instant consultation times",
                          iconColor: const Color(0xFFEF4444),
                        ),
                      ),
                      _iconButton(
                        isDark: isDark,
                        icon: LucideIcons.plus,
                        onTap: vm.addInstantSlot,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (vm.instantSlots.isEmpty)
                    _emptyState(
                      isDark: isDark,
                      text:
                          "No instant slots added. Tap + to add your first slot.",
                    )
                  else
                    ...List.generate(vm.instantSlots.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: vm.instantSlots[index].dayCtrl,
                                    decoration: inputDecoration(
                                      hint: "e.g., Mon-Fri",
                                      icon: LucideIcons.calendarDays,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: vm.instantSlots[index].timeCtrl,
                                    decoration: inputDecoration(
                                      hint: "e.g., 9:00 AM - 5:00 PM",
                                      icon: LucideIcons.clock,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _deleteButton(
                                  isDark: isDark,
                                  onTap: () => vm.removeInstantSlot(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Appointment Consultation Slots
            _buildCard(
              isDark: isDark,
              borderColor: borderColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _sectionHeader(
                          isDark: isDark,
                          icon: LucideIcons.calendar,
                          title: "Appointment Consultation Slots",
                          subtitle: "Add your appointment times",
                          iconColor: const Color(0xFF6366F1),
                        ),
                      ),
                      _iconButton(
                        isDark: isDark,
                        icon: LucideIcons.plus,
                        onTap: vm.addAppointmentSlot,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (vm.appointmentSlots.isEmpty)
                    _emptyState(
                      isDark: isDark,
                      text:
                          "No appointment slots added. Tap + to add your first slot.",
                    )
                  else
                    ...List.generate(vm.appointmentSlots.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller:
                                        vm.appointmentSlots[index].dayCtrl,
                                    decoration: inputDecoration(
                                      hint: "e.g., Mon-Fri",
                                      icon: LucideIcons.calendarDays,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller:
                                        vm.appointmentSlots[index].timeCtrl,
                                    decoration: inputDecoration(
                                      hint: "e.g., 9:00 AM - 5:00 PM",
                                      icon: LucideIcons.clock,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _deleteButton(
                                  isDark: isDark,
                                  onTap: () => vm.removeAppointmentSlot(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Availability Settings
            _buildCard(
              isDark: isDark,
              borderColor: borderColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _sectionHeader(
                    isDark: isDark,
                    icon: LucideIcons.settings,
                    title: "Availability Settings",
                    subtitle: "Set your status and timezone",
                  ),
                  const SizedBox(height: 16),

                  // Status
                  Text(
                    "Status",
                    style: GoogleFonts.exo(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.05)
                              : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: vm.status,
                        isExpanded: true,
                        dropdownColor: cardColor,
                        style: GoogleFonts.exo(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "online",
                            child: Text("Online"),
                          ),
                          DropdownMenuItem(
                            value: "appointment",
                            child: Text("Appointment only"),
                          ),
                          DropdownMenuItem(
                            value: "offline",
                            child: Text("Offline"),
                          ),
                        ],
                        onChanged: (v) => vm.setStatus(v ?? "offline"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Next Available Date
                  Text(
                    "Next available date",
                    style: GoogleFonts.exo(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => vm.pickDate(context: context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.05)
                                : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            LucideIcons.calendar,
                            size: 18,
                            color: subtleText,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              vm.nextAvailableDate == null
                                  ? "Select a date"
                                  : "${vm.nextAvailableDate!.day.toString().padLeft(2, '0')}-${vm.nextAvailableDate!.month.toString().padLeft(2, '0')}-${vm.nextAvailableDate!.year}",
                              style: GoogleFonts.exo(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color:
                                    vm.nextAvailableDate == null
                                        ? subtleText
                                        : (isDark
                                            ? Colors.white
                                            : Colors.black87),
                              ),
                            ),
                          ),
                          Icon(
                            LucideIcons.chevronRight,
                            size: 18,
                            color: subtleText,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Timezone
                  Text(
                    "Timezone",
                    style: GoogleFonts.exo(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.05)
                              : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: vm.timeZone,
                        isExpanded: true,
                        dropdownColor: cardColor,
                        style: GoogleFonts.exo(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "Asia/Dhaka",
                            child: Text("Asia/Dhaka"),
                          ),
                          DropdownMenuItem(
                            value: "Asia/Kolkata",
                            child: Text("Asia/Kolkata"),
                          ),
                          DropdownMenuItem(
                            value: "Asia/Dubai",
                            child: Text("Asia/Dubai"),
                          ),
                          DropdownMenuItem(
                            value: "Europe/London",
                            child: Text("Europe/London"),
                          ),
                          DropdownMenuItem(
                            value: "America/New_York",
                            child: Text("America/New_York"),
                          ),
                        ],
                        onChanged: (v) => vm.setTimeZone(v ?? "Asia/Dhaka"),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Weekly Schedule
            _buildCard(
              isDark: isDark,
              borderColor: borderColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _sectionHeader(
                    isDark: isDark,
                    icon: LucideIcons.calendarClock,
                    title: "Weekly Schedule",
                    subtitle: "Enable days and set working hours",
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(vm.weekRows.length, (index) {
                    final row = vm.weekRows[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.03)
                                : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              InkWell(
                                onTap: () => vm.toggleWeekDay(index),
                                child: Container(
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          row.enabled
                                              ? const Color(0xFF10B981)
                                              : (isDark
                                                  ? Colors.white.withOpacity(
                                                    0.3,
                                                  )
                                                  : Colors.black.withOpacity(
                                                    0.3,
                                                  )),
                                      width: 2,
                                    ),
                                  ),
                                  child:
                                      row.enabled
                                          ? Center(
                                            child: Container(
                                              height: 12,
                                              width: 12,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF10B981),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          )
                                          : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _capitalize(row.day),
                                  style: GoogleFonts.exo(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        row.enabled
                                            ? (isDark
                                                ? Colors.white
                                                : Colors.black87)
                                            : (isDark
                                                ? Colors.white.withOpacity(0.4)
                                                : Colors.black.withOpacity(
                                                  0.4,
                                                )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (row.enabled) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: row.fromController,
                                    readOnly: true,
                                    onTap:
                                        () => vm.pickTime(
                                          context: context,
                                          controller: row.fromController,
                                        ),
                                    decoration: inputDecoration(
                                      hint: "From",
                                      icon: LucideIcons.clock,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    "–",
                                    style: GoogleFonts.exo(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: subtleText,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: row.toController,
                                    readOnly: true,
                                    onTap:
                                        () => vm.pickTime(
                                          context: context,
                                          controller: row.toController,
                                        ),
                                    decoration: inputDecoration(
                                      hint: "To",
                                      icon: LucideIcons.clock,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Save Button
            ShadButton(
              width: double.infinity,
              height: 50,
              backgroundColor: const Color(0xFF14c7eb),
              pressedBackgroundColor: const Color(0xFF0EA5C9),
              onPressed:
                  vm.isWeeklyAvailabilityUpdateLoading
                      ? null
                      : () => vm.updateWeeklyAvailability(context),
              child:
                  vm.isWeeklyAvailabilityUpdateLoading
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : Text(
                        "Save Changes",
                        style: GoogleFonts.exo(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Widget _buildCard({
    required bool isDark,
    required Widget child,
    required Color borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionHeader({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    Color? iconColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: (iconColor ?? const Color(0xFF14c7eb)).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: iconColor ?? const Color(0xFF14c7eb),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.exo(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.exo(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color:
                      isDark
                          ? Colors.white.withOpacity(0.6)
                          : Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _serviceCheckbox({
    required bool isDark,
    required IconData icon,
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withOpacity(0.03) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:
              isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.06),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
            activeColor: const Color(0xFF14c7eb),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Icon(icon, size: 20, color: isDark ? Colors.white70 : Colors.black54),
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
        ],
      ),
    );
  }

  Widget _iconButton({
    required bool isDark,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.06),
          ),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _deleteButton({required bool isDark, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.withOpacity(0.2)),
        ),
        child: const Icon(LucideIcons.trash2, size: 18, color: Colors.red),
      ),
    );
  }

  Widget _emptyState({required bool isDark, required String text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withOpacity(0.03) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:
              isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.06),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.exo(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color:
              isDark
                  ? Colors.white.withOpacity(0.5)
                  : Colors.black.withOpacity(0.5),
        ),
      ),
    );
  }
}
