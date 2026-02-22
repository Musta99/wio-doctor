import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';
import 'package:http/http.dart' as http;

class ScheduleViewModel extends ChangeNotifier {
  bool isScheduleFetchLoading = false;
  Map scheduleData = {};
  Future fetchDoctorSchedule(BuildContext context) async {
    try {
      isScheduleFetchLoading = true;
      notifyListeners();

      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );

      // Always request fresh token
      String? token = await authProvider.getFreshToken();
      String? doctorId = authProvider.userId; // or however you store doctorId

      if (doctorId == null || token == null) {
        print("DoctorId or token missing");
        return;
      }

      if (doctorId == null || token == null) {
        return;
      }

      final scheduleFetchRoute =
          "https://www.wiocare.com/api/doctor/availability?doctorId=$doctorId";
      final response = await http.get(
        Uri.parse(scheduleFetchRoute),
        headers: {"Authorization": "Bearer $token"},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        scheduleData = data["availability"];
        notifyListeners();
        print("Data: $scheduleData");
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (err) {
      print(err.toString());
      Fluttertoast.showToast(msg: "Error occured: $err");
    } finally {
      isScheduleFetchLoading = false;
      notifyListeners();
    }
  }

  // ----------- UPDATE Schedule Availability ------------------
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
  List<WeekDayRow> weekRows = List.generate(
    7,
    (i) => WeekDayRow(
      [
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

  void setDuration(int minutes) {
    durationMinutes = minutes;
    notifyListeners();
  }

  void setStatus(String value) {
    status = value;
    notifyListeners();
  }

  void setTimeZone(String value) {
    timeZone = value;
    notifyListeners();
  }

  void setNextAvailableDate(DateTime date) {
    nextAvailableDate = date;
    notifyListeners();
  }

  void toggleWeekDay(int index) {
    weekRows[index].enabled = !weekRows[index].enabled;
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
    print("Services:");
    print("Instant Video: $instantVideo");
    print("Online Appointment: $onlineAppointment");
    print("In Clinic: $inClinicAppointment");
    print("Duration: $durationMinutes minutes");
    print("Status: $status");
    print("TimeZone: $timeZone");
    print("Next Available Date: $nextAvailableDate");

    print("Weekly Schedule:");
    for (var row in weekRows) {
      print(
        "${row.day}: Enabled=${row.enabled}, From=${row.fromController.text}, To=${row.toController.text}",
      );
    }
  }

  // ------------------------ UPDATE WEEKLY AVAILABILITY OF A DOCTOR -------------------------
  bool isWeeklyAvailabilityUpdateLoading = false;

  Future<void> updateWeeklyAvailability(
    BuildContext context, {
    required List<TextEditingController> instantDayControllers,
    required List<TextEditingController> instantTimeControllers,
    required List<TextEditingController> apptDayControllers,
    required List<TextEditingController> apptTimeControllers,
  }) async {
    try {
      isWeeklyAvailabilityUpdateLoading = true;
      notifyListeners();

      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );

      // Always request fresh token
      String? token = await authProvider.getFreshToken();
      String? doctorId = authProvider.userId;
      if (doctorId == null || token == null) {
        Fluttertoast.showToast(msg: "DoctorId or token missing");
        return;
      }

      // ----- 1. Build weekly map -----
      Map<String, Map<String, dynamic>> weeklyMap = {};
      for (var row in weekRows) {
        weeklyMap[row.day.toLowerCase()] = {
          "enabled": row.enabled,
          "from": row.fromController.text,
          "to": row.toController.text,
        };
      }

      // ----- 2. Services -----
      List<String> services = [];
      if (instantVideo) services.add("instantVideo");
      if (onlineAppointment) services.add("onlineAppointment");
      if (inClinicAppointment) services.add("inClinic");

      // ----- 3. Instant Consultation -----
      List<Map<String, String>> instantConsultation = [];
      for (int i = 0; i < instantDayControllers.length; i++) {
        instantConsultation.add({
          "label": instantDayControllers[i].text,
          "time": instantTimeControllers[i].text,
        });
      }

      // ----- 4. Appointment Consultation -----
      List<Map<String, String>> appointmentConsultation = [];
      for (int i = 0; i < apptDayControllers.length; i++) {
        appointmentConsultation.add({
          "label": apptDayControllers[i].text,
          "time": apptTimeControllers[i].text,
        });
      }

      // ----- 5. Available days -----
      List<String> availableDays =
          weekRows.where((row) => row.enabled).map((row) => row.day).toList();

      // ----- 6. Next available date -----
      String nextAvailable =
          nextAvailableDate != null ? nextAvailableDate!.toIso8601String() : "";

      // ----- 7. Build body -----
      Map<String, dynamic> body = {
        "status": status.toLowerCase(),
        "services": services,
        "weekly": weeklyMap,
        "instantConsultation": instantConsultation,
        "appointmentConsultation": appointmentConsultation,
        "availableDays": availableDays,
        "nextAvailable": nextAvailable,
        "timezone": timeZone,
      };

      // ----- 8. Call API -----
      final url =
          "https://www.wiocare.com/api/doctor/availability?doctorId=$doctorId";
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
        print("Response: ${response.body}");
        await fetchDoctorSchedule(context);
      } else {
        // Fluttertoast.showToast(
        //     msg:
        //         "Failed: ${response.statusCode} ${response.reasonPhrase}");

        print(response.statusCode);
        print("Error Response: ${response.body}");
      }
    } catch (err) {
      Fluttertoast.showToast(msg: "Error occurred: $err");
    } finally {
      isWeeklyAvailabilityUpdateLoading = false;
      notifyListeners();
    }
  }
}

// ------------- Class for Weekdays ---------------
class WeekDayRow {
  final String day;
  bool enabled;
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  WeekDayRow(this.day, {this.enabled = false});
}
