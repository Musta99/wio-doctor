// -------------------------------------  22222222222222222222222222222222 ------------------------------
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wio_doctor/shared/services/api_service.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';

/// =======================
/// Slot Row Model
/// =======================
class SlotRow {
  final TextEditingController dayCtrl = TextEditingController();
  final TextEditingController timeCtrl = TextEditingController();

  void dispose() {
    dayCtrl.dispose();
    timeCtrl.dispose();
  }
}

/// =======================
/// Week Day Row Model
/// =======================
class WeekDayRow {
  final String day;
  bool enabled;
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  WeekDayRow(this.day, {this.enabled = false});

  void dispose() {
    fromController.dispose();
    toController.dispose();
  }
}

/// =======================
/// Schedule View Model
/// =======================
class ScheduleViewModel extends ChangeNotifier {
  // ---------------- FETCH Schedule ----------------
  bool isScheduleFetchLoading = false;
  Map scheduleData = {};

  Future<void> fetchDoctorSchedule(BuildContext context) async {
    final authProvider = context.read<AuthenticationProvider>();
    try {
      isScheduleFetchLoading = true;
      notifyListeners();

      // Always request fresh token
      final String? token = await authProvider.getFreshToken();
      final String? doctorId = authProvider.userId;

      if (doctorId == null || token == null) {
        debugPrint("DoctorId or token missing");
        return;
      }

      final scheduleFetchRoute =
          "${ApiServices.baseUrl}api/doctor/availability?doctorId=$doctorId";

      final response = await http.get(
        Uri.parse(scheduleFetchRoute),
        headers: {"Authorization": "Bearer $token"},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        scheduleData = data["availability"] ?? {};
        notifyListeners();
        debugPrint("Schedule Data: $scheduleData");
      } else {
        debugPrint("Fetch failed: ${response.statusCode}");
        debugPrint("Body: ${response.body}");
      }
    } catch (err) {
      debugPrint(err.toString());
      Fluttertoast.showToast(msg: "Error occured: $err");
    } finally {
      isScheduleFetchLoading = false;
      notifyListeners();
    }
  }

  // ---------------- UPDATE Availability State ----------------

  // ---------- Services ----------
  bool instantVideo = false;
  bool onlineAppointment = false;
  bool inClinicAppointment = false;

  // ---------- Duration ----------
  int durationMinutes = 30;

  // ---------- Status ----------
  String status = "Offline";

  // ---------- Timezone ----------
  String timeZone = "Asia/Dhaka";

  // ---------- Next Available Date ----------
  DateTime? nextAvailableDate;

  // ---------- Weekly Schedule ----------
  final List<WeekDayRow> weekRows = List.generate(
    7,
    (i) => WeekDayRow(
      const [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
      ][i],
    ),
  );

  // ---------- Slots (Instant + Appointment) ----------
  final List<SlotRow> instantSlots = [];
  final List<SlotRow> appointmentSlots = [];

  // ---------- Services Toggle ----------
  void toggleInstantVideo(bool value) {
    instantVideo = value;
    notifyListeners();
  }

  void toggleOnlineAppointment(bool value) {
    onlineAppointment = value;
    notifyListeners();
  }

  void toggleClinicAppointment(bool value) {
    inClinicAppointment = value;
    notifyListeners();
  }

  // ---------- Duration ----------
  void setDuration(int minutes) {
    durationMinutes = minutes;
    notifyListeners();
  }

  // ---------- Status ----------
  void setStatus(String value) {
    status = value;
    notifyListeners();
  }

  // ---------- Timezone ----------
  void setTimeZone(String value) {
    timeZone = value;
    notifyListeners();
  }

  // ---------- Next Available Date ----------
  void setNextAvailableDate(DateTime date) {
    nextAvailableDate = date;
    notifyListeners();
  }

  // ---------- Weekly Toggle ----------
  void toggleWeekDay(int index) {
    weekRows[index].enabled = !weekRows[index].enabled;
    notifyListeners();
  }

  // ---------- Slots add/remove ----------
  void addInstantSlot() {
    instantSlots.add(SlotRow());
    notifyListeners();
  }

  void removeInstantSlot(int index) {
    if (index < 0 || index >= instantSlots.length) return;
    instantSlots[index].dispose();
    instantSlots.removeAt(index);
    notifyListeners();
  }

  void addAppointmentSlot() {
    appointmentSlots.add(SlotRow());
    notifyListeners();
  }

  void removeAppointmentSlot(int index) {
    if (index < 0 || index >= appointmentSlots.length) return;
    appointmentSlots[index].dispose();
    appointmentSlots.removeAt(index);
    notifyListeners();
  }

  void clearAllSlots() {
    for (final s in instantSlots) {
      s.dispose();
    }
    for (final s in appointmentSlots) {
      s.dispose();
    }
    instantSlots.clear();
    appointmentSlots.clear();
    notifyListeners();
  }

  // ---------- Reusable Time Picker ----------
  Future<void> pickTime({
    required BuildContext context,
    required TextEditingController controller,
  }) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: now);

    if (picked != null) {
      controller.text = picked.format(context);
      notifyListeners(); // updates UI
    }
  }

  // ---------- Reusable Date Picker ----------
  Future<void> pickDate({required BuildContext context}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: nextAvailableDate ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      nextAvailableDate = picked;
      notifyListeners();
    }
  }

  // ---------- Helper to print all selected data ----------
  void printAllData() {
    debugPrint("========== Availability ==========");
    debugPrint("Services:");
    debugPrint("Instant Video: $instantVideo");
    debugPrint("Online Appointment: $onlineAppointment");
    debugPrint("In Clinic: $inClinicAppointment");
    debugPrint("Duration: $durationMinutes minutes");
    debugPrint("Status: $status");
    debugPrint("TimeZone: $timeZone");
    debugPrint("Next Available Date: $nextAvailableDate");

    debugPrint("Weekly Schedule:");
    for (final row in weekRows) {
      debugPrint(
        "${row.day}: Enabled=${row.enabled}, From=${row.fromController.text}, To=${row.toController.text}",
      );
    }

    debugPrint("Instant Slots:");
    for (final s in instantSlots) {
      debugPrint("Day=${s.dayCtrl.text}, Time=${s.timeCtrl.text}");
    }

    debugPrint("Appointment Slots:");
    for (final s in appointmentSlots) {
      debugPrint("Day=${s.dayCtrl.text}, Time=${s.timeCtrl.text}");
    }
  }

  // ------------------------ UPDATE WEEKLY AVAILABILITY -------------------------
  bool isWeeklyAvailabilityUpdateLoading = false;

  Future<void> updateWeeklyAvailability(BuildContext context) async {
    try {
      isWeeklyAvailabilityUpdateLoading = true;
      notifyListeners();

      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );

      // Always request fresh token
      final String? token = await authProvider.getFreshToken();
      final String? doctorId = authProvider.userId;

      if (doctorId == null || token == null) {
        Fluttertoast.showToast(msg: "DoctorId or token missing");
        return;
      }

      // ----- 1) Build weekly map -----
      final Map<String, Map<String, dynamic>> weeklyMap = {};
      for (final row in weekRows) {
        weeklyMap[row.day.toLowerCase()] = {
          "enabled": row.enabled,
          "from": row.fromController.text,
          "to": row.toController.text,
        };
      }

      // ----- 2) Services -----
      final List<String> services = [];
      if (instantVideo) services.add("instantVideo");
      if (onlineAppointment) services.add("onlineAppointment");
      if (inClinicAppointment) services.add("inClinic");

      // ----- 3) Instant Consultation -----
      final List<Map<String, String>> instantConsultation =
          instantSlots
              .map(
                (s) => {
                  "label": s.dayCtrl.text.trim(),
                  "time": s.timeCtrl.text.trim(),
                },
              )
              .where((m) => m["label"]!.isNotEmpty || m["time"]!.isNotEmpty)
              .toList();

      // ----- 4) Appointment Consultation -----
      final List<Map<String, String>> appointmentConsultation =
          appointmentSlots
              .map(
                (s) => {
                  "label": s.dayCtrl.text.trim(),
                  "time": s.timeCtrl.text.trim(),
                },
              )
              .where((m) => m["label"]!.isNotEmpty || m["time"]!.isNotEmpty)
              .toList();

      // ----- 5) Available days -----
      final List<String> availableDays =
          weekRows.where((row) => row.enabled).map((row) => row.day).toList();

      // ----- 6) Next available date -----
      final String nextAvailable =
          nextAvailableDate != null ? nextAvailableDate!.toIso8601String() : "";

      // ----- 7) Build body -----
      final Map<String, dynamic> body = {
        "status": status.toLowerCase(),
        "services": services,
        "weekly": weeklyMap,
        "instantConsultation": instantConsultation,
        "appointmentConsultation": appointmentConsultation,
        "availableDays": availableDays,
        "nextAvailable": nextAvailable,
        "timezone": timeZone,
        // "durationMinutes": durationMinutes, // ✅ include if your API supports it
      };

      // ----- 8) Call API -----
      final url =
          "${ApiServices.baseUrl}api/doctor/availability?doctorId=$doctorId";

      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Weekly availability updated!",
          backgroundColor: Colors.green,
        );
        debugPrint("Update Response: ${response.body}");
        await fetchDoctorSchedule(context);
      } else {
        debugPrint("Update failed: ${response.statusCode}");
        debugPrint("Error Response: ${response.body}");
        Fluttertoast.showToast(msg: "Failed: ${response.statusCode}");
      }
    } catch (err) {
      Fluttertoast.showToast(msg: "Error occurred: $err");
    } finally {
      isWeeklyAvailabilityUpdateLoading = false;
      notifyListeners();
    }
  }

  // ------------------ Optional: load UI state from fetched scheduleData ------------------
  // Call this after fetchDoctorSchedule if you want to auto-fill the form.
  void hydrateFromScheduleData() {
    try {
      // Implement if your backend returns availability in a known format.
      // Keeping empty to avoid breaking your current API format.
      notifyListeners();
    } catch (_) {}
  }

  @override
  void dispose() {
    for (final row in weekRows) {
      row.dispose();
    }
    for (final s in instantSlots) {
      s.dispose();
    }
    for (final s in appointmentSlots) {
      s.dispose();
    }
    super.dispose();
  }
}
