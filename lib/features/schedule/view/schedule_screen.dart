// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shadcn_ui/shadcn_ui.dart';
// import 'package:wio_doctor/core/theme/theme_provider.dart';

// class ScheduleScreen extends StatelessWidget {
//   const ScheduleScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = ThemeProvider.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Schedule & Availability',
//           style: GoogleFonts.exo(fontWeight: FontWeight.w600, fontSize: 20),
//         ),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
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
//       body: Container(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Current Availability Section
//                 ShadCard(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     spacing: 16,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Current Availability",
//                         style: GoogleFonts.exo(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 18,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Text("Status: "),
//                           SizedBox(width: 8),
//                           Chip(
//                             label: Text(
//                               "Offline",
//                               style: GoogleFonts.exo(color: Colors.white),
//                             ),
//                             backgroundColor: Colors.red,
//                           ),
//                         ],
//                       ),

//                       Row(
//                         spacing: 12,
//                         children: [
//                           Expanded(
//                             child: ShadCard(
//                               padding: EdgeInsets.all(12),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     LucideIcons.check,
//                                     size: 20,
//                                     color: Colors.green,
//                                   ),
//                                   SizedBox(width: 8),
//                                   Expanded(
//                                     child: Text(
//                                       "Instant Consultations",
//                                       style: GoogleFonts.exo(fontSize: 14),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: ShadCard(
//                               padding: EdgeInsets.all(12),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     LucideIcons.check,
//                                     size: 20,
//                                     color: Colors.green,
//                                   ),
//                                   SizedBox(width: 8),
//                                   Expanded(
//                                     child: Text(
//                                       "Appointment Consultations",
//                                       style: GoogleFonts.exo(fontSize: 14),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Available days",
//                             style: GoogleFonts.exo(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 16,
//                             ),
//                           ),

//                           SizedBox(height: 8),
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 8,
//                             children: [
//                               Chip(label: Text("Monday")),
//                               Chip(label: Text("Tuesday")),
//                               Chip(label: Text("Wednesday")),
//                               Chip(label: Text("Thursday")),
//                               Chip(label: Text("Friday")),
//                               Chip(label: Text("Saturday")),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Update weekly Availability
//                 ShadCard(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     spacing: 16,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Update Weekly Availability",
//                         style: GoogleFonts.exo(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 18,
//                         ),
//                       ),

//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Service offered",
//                             style: GoogleFonts.exo(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Checkbox(value: false, onChanged: (val) {}),
//                               Row(
//                                 spacing: 5,
//                                 children: [
//                                   Icon(LucideIcons.video, size: 25),
//                                   Text(
//                                     "Instant video Consultations",
//                                     style: GoogleFonts.exo(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),

//                           Row(
//                             children: [
//                               Checkbox(value: false, onChanged: (val) {}),
//                               Row(
//                                 spacing: 5,
//                                 children: [
//                                   Icon(LucideIcons.calendar, size: 25),
//                                   Text(
//                                     "Online Appointment",
//                                     style: GoogleFonts.exo(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),

//                           Row(
//                             children: [
//                               Checkbox(value: false, onChanged: (val) {}),
//                               Row(
//                                 spacing: 5,
//                                 children: [
//                                   Icon(LucideIcons.building, size: 25),
//                                   Text(
//                                     "In Clinic Appointment",
//                                     style: GoogleFonts.exo(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),

//                       Column(
//                         spacing: 12,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Consultation Duration",
//                             style: GoogleFonts.exo(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),

//                           Row(
//                             spacing: 10,
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     border: Border.all(),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text("30 Minutes"),
//                                         Visibility(
//                                           visible: true,
//                                           child: Icon(
//                                             LucideIcons.circleCheck,
//                                             color: Colors.green,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),

//                               Expanded(
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     border: Border.all(),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text("60 Minutes"),
//                                         Visibility(
//                                           visible: true,
//                                           child: Icon(
//                                             LucideIcons.circleCheck,
//                                             color: Colors.green,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Instant Consultation slots
//                 ShadCard(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     spacing: 16,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Instant Consultation Slots",
//                             style: GoogleFonts.exo(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 18,
//                             ),
//                           ),

//                           GestureDetector(
//                             onTap: () {
//                               // Add new time slot
//                             },
//                             child: Icon(LucideIcons.plus),
//                           ),
//                         ],
//                       ),
//                       Text(
//                         "Set your available time slots for instant consultations.",
//                         style: GoogleFonts.exo(fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ---------------------------------- 222222222222222222222222222 -----------------------------
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final List<TextEditingController> _slotDayControllers = [];
  final List<TextEditingController> _slotTimeControllers = [];

  @override
  void dispose() {
    for (final c in _slotDayControllers) {
      c.dispose();
    }
    for (final c in _slotTimeControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickTime(int index) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: now);
    if (picked == null) return;

    final formatted = picked.format(context);
    setState(() {
      _slotTimeControllers[index].text = formatted;
    });
  }

  void _addSlotRow() {
    setState(() {
      _slotDayControllers.add(TextEditingController());
      _slotTimeControllers.add(TextEditingController());
    });
  }

  void _removeSlotRow(int index) {
    setState(() {
      _slotDayControllers[index].dispose();
      _slotTimeControllers[index].dispose();
      _slotDayControllers.removeAt(index);
      _slotTimeControllers.removeAt(index);
    });
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
      fontWeight: FontWeight.w700,
      fontSize: size,
      letterSpacing: -0.2,
    );

    TextStyle sectionStyle(double size) =>
        GoogleFonts.exo(fontWeight: FontWeight.w700, fontSize: size);

    TextStyle bodyStyle(double size) =>
        GoogleFonts.exo(fontWeight: FontWeight.w500, fontSize: size);

    InputDecoration niceInputDecoration({
      required String hint,
      required IconData icon,
    }) {
      return InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.exo(
          color: subtleText,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, size: 18),
        filled: true,
        fillColor:
            isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF3F4F8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color:
                isDark
                    ? Colors.white.withOpacity(0.18)
                    : Colors.black.withOpacity(0.12),
          ),
        ),
      );
    }

    BoxDecoration cardDecoration() {
      return BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withOpacity(0.35)
                    : Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      );
    }

    Widget cardWrapper({required Widget child}) {
      return Container(decoration: cardDecoration(), child: child);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule & Availability', style: titleStyle(20)),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Current Availability Section
                cardWrapper(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
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
                                        ? Colors.white.withOpacity(0.85)
                                        : Colors.black.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Current Availability",
                              style: sectionStyle(18),
                            ),
                          ],
                        ),
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
                                color: Colors.red.withOpacity(
                                  isDark ? 0.18 : 0.12,
                                ),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: Colors.red.withOpacity(
                                    isDark ? 0.35 : 0.25,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Offline",
                                    style: GoogleFonts.exo(
                                      color:
                                          isDark
                                              ? Colors.white.withOpacity(0.9)
                                              : Colors.red.shade900,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              child: cardWrapper(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 34,
                                        width: 34,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: Colors.green.withOpacity(
                                            isDark ? 0.12 : 0.10,
                                          ),
                                          border: Border.all(
                                            color: Colors.green.withOpacity(
                                              isDark ? 0.25 : 0.18,
                                            ),
                                          ),
                                        ),
                                        child: const Icon(
                                          LucideIcons.check,
                                          size: 18,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "Instant Consultations",
                                          style: bodyStyle(14).copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: cardWrapper(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 34,
                                        width: 34,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: Colors.green.withOpacity(
                                            isDark ? 0.12 : 0.10,
                                          ),
                                          border: Border.all(
                                            color: Colors.green.withOpacity(
                                              isDark ? 0.25 : 0.18,
                                            ),
                                          ),
                                        ),
                                        child: const Icon(
                                          LucideIcons.check,
                                          size: 18,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "Appointment Consultations",
                                          style: bodyStyle(14).copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Update weekly Availability
                cardWrapper(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
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
                                        ? Colors.white.withOpacity(0.85)
                                        : Colors.black.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Update Weekly Availability",
                              style: sectionStyle(18),
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Service offered", style: sectionStyle(16)),
                            const SizedBox(height: 10),

                            _serviceRow(
                              isDark: isDark,
                              checked: false,
                              onChanged: (val) {},
                              icon: LucideIcons.video,
                              title: "Instant video Consultations",
                            ),
                            const SizedBox(height: 8),
                            _serviceRow(
                              isDark: isDark,
                              checked: false,
                              onChanged: (val) {},
                              icon: LucideIcons.calendar,
                              title: "Online Appointment",
                            ),
                            const SizedBox(height: 8),
                            _serviceRow(
                              isDark: isDark,
                              checked: false,
                              onChanged: (val) {},
                              icon: LucideIcons.building,
                              title: "In Clinic Appointment",
                            ),
                          ],
                        ),

                        Column(
                          spacing: 12,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Consultation Duration",
                              style: sectionStyle(16),
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          isDark
                                              ? Colors.white.withOpacity(0.04)
                                              : const Color(0xFFF3F4F8),
                                      border: Border.all(color: borderColor),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "30 Minutes",
                                            style: bodyStyle(14).copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Icon(
                                            LucideIcons.circleCheck,
                                            color: Colors.green,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          isDark
                                              ? Colors.white.withOpacity(0.04)
                                              : const Color(0xFFF3F4F8),
                                      border: Border.all(color: borderColor),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "60 Minutes",
                                            style: bodyStyle(14).copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Icon(
                                            LucideIcons.circleCheck,
                                            color: Colors.green,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Instant Consultation slots
                cardWrapper(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      spacing: 14,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Instant Consultation Slots",
                              style: sectionStyle(18),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(999),
                              onTap: _addSlotRow,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color:
                                      isDark
                                          ? Colors.white.withOpacity(0.06)
                                          : Colors.black.withOpacity(0.05),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Icon(
                                  LucideIcons.plus,
                                  size: 18,
                                  color:
                                      isDark
                                          ? Colors.white.withOpacity(0.9)
                                          : Colors.black.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Set your available time slots for instant consultations.",
                          style: bodyStyle(14).copyWith(color: subtleText),
                        ),

                        if (_slotDayControllers.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color:
                                  isDark
                                      ? Colors.white.withOpacity(0.03)
                                      : const Color(0xFFF3F4F8),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: borderColor),
                            ),
                            child: Text(
                              "No slots added yet. Tap + to add your first slot.",
                              style: bodyStyle(13).copyWith(color: subtleText),
                            ),
                          ),

                        for (int i = 0; i < _slotDayControllers.length; i++)
                          Row(
                            spacing: 6,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _slotDayControllers[i],
                                  style: bodyStyle(14),
                                  decoration: niceInputDecoration(
                                    hint: "Day (e.g., Monday)",
                                    icon: LucideIcons.calendarDays,
                                  ),
                                ),
                              ),

                              Expanded(
                                child: TextField(
                                  controller: _slotTimeControllers[i],
                                  readOnly: true,
                                  onTap: () => _pickTime(i),
                                  style: bodyStyle(14),
                                  decoration: niceInputDecoration(
                                    hint: "Time (tap to pick)",
                                    icon: LucideIcons.clock,
                                  ),
                                ),
                              ),

                              InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => _removeSlotRow(i),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.red.withOpacity(
                                      isDark ? 0.14 : 0.10,
                                    ),
                                    border: Border.all(
                                      color: Colors.red.withOpacity(
                                        isDark ? 0.35 : 0.22,
                                      ),
                                    ),
                                  ),
                                  child: const Icon(
                                    LucideIcons.minus,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
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

  // kept inline style helpers (not reusable widgets elsewhere)
  Widget _serviceRow({
    required bool isDark,
    required bool checked,
    required ValueChanged<bool?> onChanged,
    required IconData icon,
    required String title,
  }) {
    final borderColor =
        isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.06);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF3F4F8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Checkbox(
            value: checked,
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
              style: GoogleFonts.exo(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ],
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
          fontWeight: FontWeight.w700,
          color:
              isDark
                  ? Colors.white.withOpacity(0.85)
                  : Colors.black.withOpacity(0.8),
        ),
      ),
    );
  }
}
