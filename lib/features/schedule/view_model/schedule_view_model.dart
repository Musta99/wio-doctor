// // -------------------------------------  22222222222222222222222222222222 ------------------------------
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:wio_doctor/shared/services/api_service.dart';
// import 'package:wio_doctor/view_model/auth_provider.dart';

// /// =======================
// /// Slot Row Model
// /// =======================
// class SlotRow {
//   final TextEditingController dayCtrl = TextEditingController();
//   final TextEditingController timeCtrl = TextEditingController();

//   void dispose() {
//     dayCtrl.dispose();
//     timeCtrl.dispose();
//   }
// }

// /// =======================
// /// Week Day Row Model
// /// =======================
// class WeekDayRow {
//   final String day;
//   bool enabled;
//   TextEditingController fromController = TextEditingController();
//   TextEditingController toController = TextEditingController();

//   WeekDayRow(this.day, {this.enabled = false});

//   void dispose() {
//     fromController.dispose();
//     toController.dispose();
//   }
// }

// /// =======================
// /// Schedule View Model
// /// =======================
// class ScheduleViewModel extends ChangeNotifier {
//   // ---------------- FETCH Schedule ----------------
//   bool isScheduleFetchLoading = false;
//   Map scheduleData = {};

//   Future<void> fetchDoctorSchedule(BuildContext context) async {
//     final authProvider = context.read<AuthenticationProvider>();
//     try {
//       isScheduleFetchLoading = true;
//       notifyListeners();

//       // Always request fresh token
//       final String? token = await authProvider.getFreshToken();
//       final String? doctorId = authProvider.userId;

//       if (doctorId == null || token == null) {
//         debugPrint("DoctorId or token missing");
//         return;
//       }

//       final scheduleFetchRoute =
//           "${ApiServices.baseUrl}api/doctor/availability?doctorId=$doctorId";

//       final response = await http.get(
//         Uri.parse(scheduleFetchRoute),
//         headers: {"Authorization": "Bearer $token"},
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200) {
//         scheduleData = data["availability"] ?? {};
//         notifyListeners();
//         debugPrint("Schedule Data: $scheduleData");
//       } else {
//         debugPrint("Fetch failed: ${response.statusCode}");
//         debugPrint("Body: ${response.body}");
//       }
//     } catch (err) {
//       debugPrint(err.toString());
//       Fluttertoast.showToast(msg: "Error occured: $err");
//     } finally {
//       isScheduleFetchLoading = false;
//       notifyListeners();
//     }
//   }

//   // ---------------- UPDATE Availability State ----------------

//   // ---------- Services ----------
//   bool instantVideo = false;
//   bool onlineAppointment = false;
//   bool inClinicAppointment = false;

//   // ---------- Duration ----------
//   int durationMinutes = 30;

//   // ---------- Status ----------
//   String status = "Offline";

//   // ---------- Timezone ----------
//   String timeZone = "Asia/Dhaka";

//   // ---------- Next Available Date ----------
//   DateTime? nextAvailableDate;

//   // ---------- Weekly Schedule ----------
//   final List<WeekDayRow> weekRows = List.generate(
//     7,
//     (i) => WeekDayRow(
//       const [
//         "Sunday",
//         "Monday",
//         "Tuesday",
//         "Wednesday",
//         "Thursday",
//         "Friday",
//         "Saturday",
//       ][i],
//     ),
//   );

//   // ---------- Slots (Instant + Appointment) ----------
//   final List<SlotRow> instantSlots = [];
//   final List<SlotRow> appointmentSlots = [];

//   // ---------- Services Toggle ----------
//   void toggleInstantVideo(bool value) {
//     instantVideo = value;
//     notifyListeners();
//   }

//   void toggleOnlineAppointment(bool value) {
//     onlineAppointment = value;
//     notifyListeners();
//   }

//   void toggleClinicAppointment(bool value) {
//     inClinicAppointment = value;
//     notifyListeners();
//   }

//   // ---------- Duration ----------
//   void setDuration(int minutes) {
//     durationMinutes = minutes;
//     notifyListeners();
//   }

//   // ---------- Status ----------
//   void setStatus(String value) {
//     status = value;
//     notifyListeners();
//   }

//   // ---------- Timezone ----------
//   void setTimeZone(String value) {
//     timeZone = value;
//     notifyListeners();
//   }

//   // ---------- Next Available Date ----------
//   void setNextAvailableDate(DateTime date) {
//     nextAvailableDate = date;
//     notifyListeners();
//   }

//   // ---------- Weekly Toggle ----------
//   void toggleWeekDay(int index) {
//     weekRows[index].enabled = !weekRows[index].enabled;
//     notifyListeners();
//   }

//   // ---------- Slots add/remove ----------
//   void addInstantSlot() {
//     instantSlots.add(SlotRow());
//     notifyListeners();
//   }

//   void removeInstantSlot(int index) {
//     if (index < 0 || index >= instantSlots.length) return;
//     instantSlots[index].dispose();
//     instantSlots.removeAt(index);
//     notifyListeners();
//   }

//   void addAppointmentSlot() {
//     appointmentSlots.add(SlotRow());
//     notifyListeners();
//   }

//   void removeAppointmentSlot(int index) {
//     if (index < 0 || index >= appointmentSlots.length) return;
//     appointmentSlots[index].dispose();
//     appointmentSlots.removeAt(index);
//     notifyListeners();
//   }

//   void clearAllSlots() {
//     for (final s in instantSlots) {
//       s.dispose();
//     }
//     for (final s in appointmentSlots) {
//       s.dispose();
//     }
//     instantSlots.clear();
//     appointmentSlots.clear();
//     notifyListeners();
//   }

//   // ---------- Reusable Time Picker ----------
//   Future<void> pickTime({
//     required BuildContext context,
//     required TextEditingController controller,
//   }) async {
//     final now = TimeOfDay.now();
//     final picked = await showTimePicker(context: context, initialTime: now);

//     if (picked != null) {
//       controller.text = picked.format(context);
//       notifyListeners(); // updates UI
//     }
//   }

//   // ---------- Reusable Date Picker ----------
//   Future<void> pickDate({required BuildContext context}) async {
//     final now = DateTime.now();
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: nextAvailableDate ?? now,
//       firstDate: DateTime(now.year - 10),
//       lastDate: DateTime(now.year + 2),
//     );

//     if (picked != null) {
//       nextAvailableDate = picked;
//       notifyListeners();
//     }
//   }

//   // ---------- Helper to print all selected data ----------
//   void printAllData() {
//     debugPrint("========== Availability ==========");
//     debugPrint("Services:");
//     debugPrint("Instant Video: $instantVideo");
//     debugPrint("Online Appointment: $onlineAppointment");
//     debugPrint("In Clinic: $inClinicAppointment");
//     debugPrint("Duration: $durationMinutes minutes");
//     debugPrint("Status: $status");
//     debugPrint("TimeZone: $timeZone");
//     debugPrint("Next Available Date: $nextAvailableDate");

//     debugPrint("Weekly Schedule:");
//     for (final row in weekRows) {
//       debugPrint(
//         "${row.day}: Enabled=${row.enabled}, From=${row.fromController.text}, To=${row.toController.text}",
//       );
//     }

//     debugPrint("Instant Slots:");
//     for (final s in instantSlots) {
//       debugPrint("Day=${s.dayCtrl.text}, Time=${s.timeCtrl.text}");
//     }

//     debugPrint("Appointment Slots:");
//     for (final s in appointmentSlots) {
//       debugPrint("Day=${s.dayCtrl.text}, Time=${s.timeCtrl.text}");
//     }
//   }

//   // ------------------------ UPDATE WEEKLY AVAILABILITY -------------------------
//   bool isWeeklyAvailabilityUpdateLoading = false;

//   Future<void> updateWeeklyAvailability(BuildContext context) async {
//     try {
//       isWeeklyAvailabilityUpdateLoading = true;
//       notifyListeners();

//       final authProvider = Provider.of<AuthenticationProvider>(
//         context,
//         listen: false,
//       );

//       // Always request fresh token
//       final String? token = await authProvider.getFreshToken();
//       final String? doctorId = authProvider.userId;

//       if (doctorId == null || token == null) {
//         Fluttertoast.showToast(msg: "DoctorId or token missing");
//         return;
//       }

//       // ----- 1) Build weekly map -----
//       final Map<String, Map<String, dynamic>> weeklyMap = {};
//       for (final row in weekRows) {
//         weeklyMap[row.day.toLowerCase()] = {
//           "enabled": row.enabled,
//           "from": row.fromController.text,
//           "to": row.toController.text,
//         };
//       }

//       // ----- 2) Services -----
//       final List<String> services = [];
//       if (instantVideo) services.add("instantVideo");
//       if (onlineAppointment) services.add("onlineAppointment");
//       if (inClinicAppointment) services.add("inClinic");

//       // ----- 3) Instant Consultation -----
//       final List<Map<String, String>> instantConsultation =
//           instantSlots
//               .map(
//                 (s) => {
//                   "label": s.dayCtrl.text.trim(),
//                   "time": s.timeCtrl.text.trim(),
//                 },
//               )
//               .where((m) => m["label"]!.isNotEmpty || m["time"]!.isNotEmpty)
//               .toList();

//       // ----- 4) Appointment Consultation -----
//       final List<Map<String, String>> appointmentConsultation =
//           appointmentSlots
//               .map(
//                 (s) => {
//                   "label": s.dayCtrl.text.trim(),
//                   "time": s.timeCtrl.text.trim(),
//                 },
//               )
//               .where((m) => m["label"]!.isNotEmpty || m["time"]!.isNotEmpty)
//               .toList();

//       // ----- 5) Available days -----
//       final List<String> availableDays =
//           weekRows.where((row) => row.enabled).map((row) => row.day).toList();

//       // ----- 6) Next available date -----
//       final String nextAvailable =
//           nextAvailableDate != null ? nextAvailableDate!.toIso8601String() : "";

//       // ----- 7) Build body -----
//       final Map<String, dynamic> body = {
//         "status": status.toLowerCase(),
//         "services": services,
//         "weekly": weeklyMap,
//         "instantConsultation": instantConsultation,
//         "appointmentConsultation": appointmentConsultation,
//         "availableDays": availableDays,
//         "nextAvailable": nextAvailable,
//         "timezone": timeZone,
//         // "durationMinutes": durationMinutes, // ✅ include if your API supports it
//       };

//       // ----- 8) Call API -----
//       final url =
//           "${ApiServices.baseUrl}api/doctor/availability?doctorId=$doctorId";

//       final response = await http.put(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode(body),
//       );

//       if (response.statusCode == 200) {
//         Fluttertoast.showToast(
//           msg: "Weekly availability updated!",
//           backgroundColor: Colors.green,
//         );
//         debugPrint("Update Response: ${response.body}");
//         await fetchDoctorSchedule(context);
//       } else {
//         debugPrint("Update failed: ${response.statusCode}");
//         debugPrint("Error Response: ${response.body}");
//         Fluttertoast.showToast(msg: "Failed: ${response.statusCode}");
//       }
//     } catch (err) {
//       Fluttertoast.showToast(msg: "Error occurred: $err");
//     } finally {
//       isWeeklyAvailabilityUpdateLoading = false;
//       notifyListeners();
//     }
//   }

//   // ------------------ Optional: load UI state from fetched scheduleData ------------------
//   // Call this after fetchDoctorSchedule if you want to auto-fill the form.
//   void hydrateFromScheduleData() {
//     try {
//       // Implement if your backend returns availability in a known format.
//       // Keeping empty to avoid breaking your current API format.
//       notifyListeners();
//     } catch (_) {}
//   }

//   @override
//   void dispose() {
//     for (final row in weekRows) {
//       row.dispose();
//     }
//     for (final s in instantSlots) {
//       s.dispose();
//     }
//     for (final s in appointmentSlots) {
//       s.dispose();
//     }
//     super.dispose();
//   }
// }

// ---------------------------- 22222222222222222222222 --------------------------------
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

      final String? token = await authProvider.getFreshToken();
      final String? doctorId = authProvider.userId;

      if (doctorId == null || token == null) {
        debugPrint("❌ DoctorId or token missing");
        return;
      }

      final scheduleFetchRoute =
          "${ApiServices.baseUrl}api/doctor/availability?doctorId=$doctorId";

      debugPrint("📡 Fetching schedule from: $scheduleFetchRoute");

      final response = await http.get(
        Uri.parse(scheduleFetchRoute),
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("📥 Schedule Response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['availability'] != null) {
          scheduleData = data["availability"] ?? {};
          notifyListeners();
          debugPrint("✅ Schedule Data loaded: ${scheduleData.keys}");
        } else if (response.statusCode == 404) {
          // No schedule configured yet
          scheduleData = {};
          notifyListeners();
          debugPrint("⚠️ No schedule configured");
        }
      } else {
        debugPrint("❌ Fetch failed: ${response.statusCode}");
        debugPrint("Body: ${response.body}");
      }
    } catch (err) {
      debugPrint("❌ Error: $err");
      Fluttertoast.showToast(
        msg: "Failed to load schedule",
        backgroundColor: Colors.red,
      );
    } finally {
      isScheduleFetchLoading = false;
      notifyListeners();
    }
  }

  // ---------------- UPDATE Availability State ----------------

  // ---------- Services (matching web: instantVideo, onlineAppointment, inClinic) ----------
  bool instantVideo = false;
  bool onlineAppointment = false;
  bool inClinicAppointment = false;

  // ---------- Duration (matching web: 30 or 60) ----------
  int durationMinutes = 30;

  // ---------- Status (matching web: online, appointment, offline) ----------
  String status = "offline";

  // ---------- Timezone ----------
  String timeZone = "Asia/Dhaka";

  // ---------- Next Available Date ----------
  DateTime? nextAvailableDate;

  // ---------- Weekly Schedule (matching web structure: monday, tuesday, etc.) ----------
  final List<WeekDayRow> weekRows = List.generate(
    7,
    (i) => WeekDayRow(
      const [
        "monday",
        "tuesday",
        "wednesday",
        "thursday",
        "friday",
        "saturday",
        "sunday",
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
      // Format as "HH:mm AM/PM" to match web format
      final hour = picked.hourOfPeriod;
      final minute = picked.minute.toString().padLeft(2, '0');
      final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
      controller.text = "$hour:$minute $period";
      notifyListeners();
    }
  }

  // ---------- Reusable Date Picker ----------
  // ---------- Reusable Date Picker with better handling ----------
  Future<void> pickDate({required BuildContext context}) async {
    final now = DateTime.now();

    // Normalize nextAvailableDate to remove time component
    DateTime? existingDate = nextAvailableDate;
    if (existingDate != null) {
      existingDate = DateTime(
        existingDate.year,
        existingDate.month,
        existingDate.day,
      );
    }

    // Normalize now
    final today = DateTime(now.year, now.month, now.day);

    // Determine initialDate: use existing date if it's in future, otherwise use today
    DateTime initialDate;
    if (existingDate != null && existingDate.isAfter(today)) {
      initialDate = existingDate;
    } else {
      initialDate = today;
    }

    try {
      final picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: today, // Don't allow past dates
        lastDate: DateTime(today.year + 2), // 2 years into future
        helpText: 'Select next available date',
        confirmText: 'Set Date',
        cancelText: 'Cancel',
        fieldLabelText: 'Next Available',
      );

      if (picked != null) {
        nextAvailableDate = picked;
        debugPrint("📅 Date picked: $picked");
        notifyListeners();
      }
    } catch (e) {
      debugPrint("❌ Date picker error: $e");
    }
  }

  // ---------- Helper to print all selected data ----------
  void printAllData() {
    debugPrint("========== Availability ==========");
    debugPrint("Services:");
    debugPrint("  Instant Video: $instantVideo");
    debugPrint("  Online Appointment: $onlineAppointment");
    debugPrint("  In Clinic: $inClinicAppointment");
    debugPrint("Duration: $durationMinutes minutes");
    debugPrint("Status: $status");
    debugPrint("TimeZone: $timeZone");
    debugPrint("Next Available Date: $nextAvailableDate");

    debugPrint("Weekly Schedule:");
    for (final row in weekRows) {
      debugPrint(
        "  ${row.day}: Enabled=${row.enabled}, From=${row.fromController.text}, To=${row.toController.text}",
      );
    }

    debugPrint("Instant Slots:");
    for (final s in instantSlots) {
      debugPrint("  Day=${s.dayCtrl.text}, Time=${s.timeCtrl.text}");
    }

    debugPrint("Appointment Slots:");
    for (final s in appointmentSlots) {
      debugPrint("  Day=${s.dayCtrl.text}, Time=${s.timeCtrl.text}");
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

      final String? token = await authProvider.getFreshToken();
      final String? doctorId = authProvider.userId;

      if (doctorId == null || token == null) {
        Fluttertoast.showToast(msg: "Authentication required");
        return;
      }

      // ----- 1) Build weekly map (matching web structure) -----
      final Map<String, Map<String, dynamic>> weeklyMap = {};
      for (final row in weekRows) {
        weeklyMap[row.day.toLowerCase()] = {
          "enabled": row.enabled,
          "from": row.fromController.text,
          "to": row.toController.text,
        };
      }

      // ----- 2) Services (matching web format) -----
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
              .where((m) => m["label"]!.isNotEmpty && m["time"]!.isNotEmpty)
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
              .where((m) => m["label"]!.isNotEmpty && m["time"]!.isNotEmpty)
              .toList();

      // ----- 5) Available days (days that are enabled) -----
      final List<String> availableDays =
          weekRows
              .where((row) => row.enabled)
              .map((row) => row.day.toLowerCase())
              .toList();

      // ----- 6) Next available date (ISO format) -----
      final String nextAvailable =
          nextAvailableDate != null ? nextAvailableDate!.toIso8601String() : "";

      // ----- 7) Build body (matching web API structure) -----
      final Map<String, dynamic> body = {
        "status": status.toLowerCase(),
        "services": services,
        "weekly": weeklyMap,
        "instantConsultation": instantConsultation,
        "appointmentConsultation": appointmentConsultation,
        "availableDays": availableDays,
        "nextAvailable": nextAvailable,
        "timezone": timeZone,
      };

      debugPrint("📤 Updating availability: ${jsonEncode(body)}");

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

      debugPrint("📥 Update Response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          Fluttertoast.showToast(
            msg: "Weekly availability updated successfully!",
            backgroundColor: Colors.green,
          );
          debugPrint("✅ Update successful");

          // Refresh schedule data
          await fetchDoctorSchedule(context);

          // Navigate back
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        } else {
          throw Exception(data['error'] ?? 'Update failed');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to update availability');
      }
    } catch (err) {
      debugPrint("❌ Error: $err");
      Fluttertoast.showToast(
        msg: "Failed to update: $err",
        backgroundColor: Colors.red,
      );
    } finally {
      isWeeklyAvailabilityUpdateLoading = false;
      notifyListeners();
    }
  }

  // ------------------ Load existing data into form ------------------
  void hydrateFromExistingData() {
    if (scheduleData.isEmpty) return;

    try {
      // Status
      if (scheduleData["status"] != null) {
        status = scheduleData["status"].toString().toLowerCase();
      }

      // Services
      final services = scheduleData["services"] as List<dynamic>? ?? [];
      instantVideo = services.contains("instantVideo");
      onlineAppointment = services.contains("onlineAppointment");
      inClinicAppointment = services.contains("inClinic");

      // Timezone
      if (scheduleData["timezone"] != null) {
        timeZone = scheduleData["timezone"].toString();
      }

      // Next Available
      if (scheduleData["nextAvailable"] != null &&
          scheduleData["nextAvailable"].toString().isNotEmpty) {
        try {
          nextAvailableDate = DateTime.parse(scheduleData["nextAvailable"]);
        } catch (e) {
          debugPrint("Failed to parse nextAvailable: $e");
        }
      }

      // Weekly Schedule
      final weekly = scheduleData["weekly"] as Map<String, dynamic>? ?? {};
      for (int i = 0; i < weekRows.length; i++) {
        final dayKey = weekRows[i].day.toLowerCase();
        if (weekly.containsKey(dayKey)) {
          final dayData = weekly[dayKey] as Map<String, dynamic>;
          weekRows[i].enabled = dayData["enabled"] == true;
          weekRows[i].fromController.text = dayData["from"]?.toString() ?? "";
          weekRows[i].toController.text = dayData["to"]?.toString() ?? "";
        }
      }

      // Instant Consultation Slots
      clearAllSlots();
      final instantList =
          scheduleData["instantConsultation"] as List<dynamic>? ?? [];
      for (final slot in instantList) {
        if (slot is Map) {
          final row = SlotRow();
          row.dayCtrl.text = slot["label"]?.toString() ?? "";
          row.timeCtrl.text = slot["time"]?.toString() ?? "";
          instantSlots.add(row);
        }
      }

      // Appointment Consultation Slots
      final appointmentList =
          scheduleData["appointmentConsultation"] as List<dynamic>? ?? [];
      for (final slot in appointmentList) {
        if (slot is Map) {
          final row = SlotRow();
          row.dayCtrl.text = slot["label"]?.toString() ?? "";
          row.timeCtrl.text = slot["time"]?.toString() ?? "";
          appointmentSlots.add(row);
        }
      }

      notifyListeners();
      debugPrint("✅ Form hydrated with existing data");
    } catch (e) {
      debugPrint("❌ Error hydrating form: $e");
    }
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
