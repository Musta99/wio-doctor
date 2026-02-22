import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';
import 'package:wio_doctor/features/schedule/view_model/schedule_view_model.dart';

class UpdateWeeklyAvailabilityScreen extends StatefulWidget {
  const UpdateWeeklyAvailabilityScreen({super.key});

  @override
  State<UpdateWeeklyAvailabilityScreen> createState() =>
      _UpdateWeeklyAvailabilityScreenState();
}

class _UpdateWeeklyAvailabilityScreenState
    extends State<UpdateWeeklyAvailabilityScreen> {
  // Services (connect to Provider later)
  bool instantVideo = false;
  bool onlineAppointment = false;
  bool inClinicAppointment = false;

  int durationMinutes = 30; // 30 or 60

  // Slots
  final List<TextEditingController> _instantDayControllers = [];
  final List<TextEditingController> _instantTimeControllers = [];

  final List<TextEditingController> _apptDayControllers = [];
  final List<TextEditingController> _apptTimeControllers = [];

  // Status / Next availability / Timezone
  String _status = "Offline"; // Online / Appointment only / Offline
  DateTime? _nextAvailableDate;
  String _timeZone = "Asia/Dhaka";

  // Weekly schedule
  final List<_WeekDayRow> _weekRows = [
    _WeekDayRow("Sunday"),
    _WeekDayRow("Monday"),
    _WeekDayRow("Tuesday"),
    _WeekDayRow("Wednesday"),
    _WeekDayRow("Thursday"),
    _WeekDayRow("Friday"),
    _WeekDayRow("Saturday"),
  ];

  @override
  void dispose() {
    for (final c in _instantDayControllers) {
      c.dispose();
    }
    for (final c in _instantTimeControllers) {
      c.dispose();
    }
    for (final c in _apptDayControllers) {
      c.dispose();
    }
    for (final c in _apptTimeControllers) {
      c.dispose();
    }
    for (final d in _weekRows) {
      d.fromController.dispose();
      d.toController.dispose();
    }
    super.dispose();
  }

  // -------- pickers ----------
  Future<void> _pickTimeToController(TextEditingController controller) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: now);
    if (picked == null) return;
    controller.text = picked.format(context);
    setState(() {});
  }

  Future<void> _pickNextAvailableDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextAvailableDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() => _nextAvailableDate = picked);
  }

  // -------- add/remove slot rows ----------
  void _addInstantSlot() {
    setState(() {
      _instantDayControllers.add(TextEditingController());
      _instantTimeControllers.add(TextEditingController());
    });
  }

  void _removeInstantSlot(int index) {
    setState(() {
      _instantDayControllers[index].dispose();
      _instantTimeControllers[index].dispose();
      _instantDayControllers.removeAt(index);
      _instantTimeControllers.removeAt(index);
    });
  }

  void _addApptSlot() {
    setState(() {
      _apptDayControllers.add(TextEditingController());
      _apptTimeControllers.add(TextEditingController());
    });
  }

  void _removeApptSlot(int index) {
    setState(() {
      _apptDayControllers[index].dispose();
      _apptTimeControllers[index].dispose();
      _apptDayControllers.removeAt(index);
      _apptTimeControllers.removeAt(index);
    });
  }

  void _saveAll() {
    // TODO: collect and send to Provider/API/Firestore
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Saved (demo).")));
    Navigator.pop(context);
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

    InputDecoration niceInputDecoration({
      required String hint,
      required IconData icon,
    }) {
      return InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.exo(
          color: subtleText,
          fontWeight: FontWeight.w600,
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

    Widget cardWrap(Widget child) =>
        Container(decoration: cardDecoration(), child: child);

    Widget addCircleButton(VoidCallback onTap) {
      return InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
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
      );
    }

    Widget minusButton(VoidCallback onTap) {
      return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.red.withOpacity(isDark ? 0.14 : 0.10),
            border: Border.all(
              color: Colors.red.withOpacity(isDark ? 0.35 : 0.22),
            ),
          ),
          child: const Icon(LucideIcons.minus, size: 18, color: Colors.red),
        ),
      );
    }

    Widget emptyHint(String text) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:
              isDark ? Colors.white.withOpacity(0.03) : const Color(0xFFF3F4F8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Text(text, style: bodyStyle(13).copyWith(color: subtleText)),
      );
    }

    // ---- existing: service tiles + duration tiles ----
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

    final scheduleVM = context.watch<ScheduleViewModel>();

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
      body: SafeArea(
        child: Container(
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
                  // ===========================
                  // A) Services + Duration
                  // ===========================
                  cardWrap(
                    Padding(
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
                                      "Choose services, duration, slots, and schedule.",
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
                            value: scheduleVM.instantVideo,
                            onChanged: (value) {
                              scheduleVM.toggleInstantVideo(value!);
                              print(scheduleVM.instantVideo);
                            },
                          ),
                          const SizedBox(height: 10),
                          serviceTile(
                            icon: LucideIcons.calendar,
                            title: "Online appointment",
                            value: scheduleVM.onlineAppointment,
                            onChanged: (value) {
                              scheduleVM.toggleOnlineAppointment(value!);
                              print(scheduleVM.onlineAppointment);
                            },
                          ),
                          const SizedBox(height: 10),
                          serviceTile(
                            icon: LucideIcons.building,
                            title: "In clinic appointment",
                            value: scheduleVM.inClinicAppointment,
                            onChanged: (value) {
                              scheduleVM.toggleClinicAppointment(value!);
                            },
                          ),

                          const SizedBox(height: 18),

                          // -------  Consultation Duration -----------
                          Text(
                            "Consultation Duration",
                            style: sectionStyle(16),
                          ),
                          const SizedBox(height: 10),

                          Wrap(
                            spacing: 10,
                            children:
                                [15, 30, 45, 60].map((minutes) {
                                  final selected =
                                      scheduleVM.durationMinutes == minutes;

                                  return ChoiceChip(
                                    label: Text("$minutes min"),
                                    selected: selected,
                                    onSelected:
                                        (_) => scheduleVM.setDuration(minutes),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ===========================
                  // B) Instant Consultation Slots
                  // ===========================
                  cardWrap(
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Instant Consultation Slots",
                                style: sectionStyle(18),
                              ),
                              addCircleButton(_addInstantSlot),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Set your available time slots for instant consultations.",
                            style: bodyStyle(14).copyWith(color: subtleText),
                          ),
                          const SizedBox(height: 12),

                          if (_instantDayControllers.isEmpty)
                            emptyHint(
                              "No instant slots added yet. Tap + to add your first slot.",
                            ),

                          for (
                            int i = 0;
                            i < _instantDayControllers.length;
                            i++
                          )
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _instantDayControllers[i],
                                      style: bodyStyle(14),
                                      decoration: niceInputDecoration(
                                        hint: "Day (e.g., Monday)",
                                        icon: LucideIcons.calendarDays,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: _instantTimeControllers[i],
                                      readOnly: true,
                                      onTap:
                                          () => _pickTimeToController(
                                            _instantTimeControllers[i],
                                          ),
                                      style: bodyStyle(14),
                                      decoration: niceInputDecoration(
                                        hint: "Time (tap to pick)",
                                        icon: LucideIcons.clock,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  minusButton(() => _removeInstantSlot(i)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ===========================
                  // C) Appointment Consultation Slots
                  // ===========================
                  cardWrap(
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Appointment Consultation Slots",
                                style: sectionStyle(18),
                              ),
                              addCircleButton(_addApptSlot),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Set your available time slots for appointment consultations.",
                            style: bodyStyle(14).copyWith(color: subtleText),
                          ),
                          const SizedBox(height: 12),

                          if (_apptDayControllers.isEmpty)
                            emptyHint(
                              "No appointment slots added yet. Tap + to add your first slot.",
                            ),

                          for (int i = 0; i < _apptDayControllers.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _apptDayControllers[i],
                                      style: bodyStyle(14),
                                      decoration: niceInputDecoration(
                                        hint: "Day (e.g., Thursday)",
                                        icon: LucideIcons.calendarDays,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: _apptTimeControllers[i],
                                      readOnly: true,
                                      onTap:
                                          () => _pickTimeToController(
                                            _apptTimeControllers[i],
                                          ),
                                      style: bodyStyle(14),
                                      decoration: niceInputDecoration(
                                        hint: "Time (tap to pick)",
                                        icon: LucideIcons.clock,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  minusButton(() => _removeApptSlot(i)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ===========================
                  // D) Status + Next availability + Timezone
                  // ===========================
                  cardWrap(
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Availability Settings",
                            style: sectionStyle(18),
                          ),
                          const SizedBox(height: 12),

                          Text("Status", style: sectionStyle(16)),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color:
                                  isDark
                                      ? Colors.white.withOpacity(0.04)
                                      : const Color(0xFFF3F4F8),
                              border: Border.all(color: borderColor),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: scheduleVM.status,
                                isExpanded: true,
                                items: const [
                                  DropdownMenuItem(
                                    value: "Online",
                                    child: Text("Online"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Appointment only",
                                    child: Text("Appointment only"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Offline",
                                    child: Text("Offline"),
                                  ),
                                ],
                                onChanged: (v) {
                                  scheduleVM.setStatus(v!);
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          Text("Next available date", style: sectionStyle(16)),
                          const SizedBox(height: 10),
                          InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: _pickNextAvailableDate,
                            child: Container(
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
                                border: Border.all(color: borderColor),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  const Icon(LucideIcons.calendar, size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      _nextAvailableDate == null
                                          ? "Tap to pick a date"
                                          : "${_nextAvailableDate!.day.toString().padLeft(2, '0')}-"
                                              "${_nextAvailableDate!.month.toString().padLeft(2, '0')}-"
                                              "${_nextAvailableDate!.year}",
                                      style: bodyStyle(
                                        14,
                                      ).copyWith(fontWeight: FontWeight.w900),
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

                          const SizedBox(height: 14),

                          Text("Time zone", style: sectionStyle(16)),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color:
                                  isDark
                                      ? Colors.white.withOpacity(0.04)
                                      : const Color(0xFFF3F4F8),
                              border: Border.all(color: borderColor),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _timeZone,
                                isExpanded: true,
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
                                onChanged: (v) {
                                  if (v == null) return;
                                  setState(() => _timeZone = v);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ===========================
                  // E) Weekly Schedule (7 days) From-To + radio toggle
                  // ===========================
                  cardWrap(
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Weekly Schedule", style: sectionStyle(18)),
                          const SizedBox(height: 8),
                          Text(
                            "Enable each day and set From–To time.",
                            style: bodyStyle(14).copyWith(color: subtleText),
                          ),
                          const SizedBox(height: 12),

                          for (int i = 0; i < _weekRows.length; i++)
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isDark
                                        ? Colors.white.withOpacity(0.04)
                                        : const Color(0xFFF3F4F8),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: borderColor),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(999),
                                    onTap: () {
                                      setState(() {
                                        _weekRows[i].enabled =
                                            !_weekRows[i].enabled;
                                      });
                                    },
                                    child: Container(
                                      height: 22,
                                      width: 22,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 2,
                                          color:
                                              _weekRows[i].enabled
                                                  ? Colors.green
                                                  : (isDark
                                                      ? Colors.white
                                                          .withOpacity(0.25)
                                                      : Colors.black
                                                          .withOpacity(0.25)),
                                        ),
                                      ),
                                      child:
                                          _weekRows[i].enabled
                                              ? Center(
                                                child: Container(
                                                  height: 10,
                                                  width: 10,
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.green,
                                                        shape: BoxShape.circle,
                                                      ),
                                                ),
                                              )
                                              : const SizedBox.shrink(),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      _weekRows[i].day,
                                      style: bodyStyle(
                                        14,
                                      ).copyWith(fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 110,
                                    child: TextField(
                                      controller: _weekRows[i].fromController,
                                      readOnly: true,
                                      onTap:
                                          _weekRows[i].enabled
                                              ? () => _pickTimeToController(
                                                _weekRows[i].fromController,
                                              )
                                              : null,
                                      decoration: niceInputDecoration(
                                        hint: "From",
                                        icon: LucideIcons.clock,
                                      ),
                                      style: bodyStyle(
                                        13,
                                      ).copyWith(fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 110,
                                    child: TextField(
                                      controller: _weekRows[i].toController,
                                      readOnly: true,
                                      onTap:
                                          _weekRows[i].enabled
                                              ? () => _pickTimeToController(
                                                _weekRows[i].toController,
                                              )
                                              : null,
                                      decoration: niceInputDecoration(
                                        hint: "To",
                                        icon: LucideIcons.clock,
                                      ),
                                      style: bodyStyle(
                                        13,
                                      ).copyWith(fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ===========================
                  // Save button
                  // ===========================
                  ShadButton(
                    width: double.infinity,
                    height: 46,
                    backgroundColor: Colors.teal,
                    onPressed: () {},
                    child: Text(
                      "Save changes",
                      style: GoogleFonts.exo(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WeekDayRow {
  final String day;
  bool enabled;
  final TextEditingController fromController;
  final TextEditingController toController;

  _WeekDayRow(this.day)
    : enabled = false,
      fromController = TextEditingController(),
      toController = TextEditingController();
}
