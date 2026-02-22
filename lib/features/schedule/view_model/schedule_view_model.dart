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

    try {
      isScheduleFetchLoading = true;
      notifyListeners();

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
      ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"][i],
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
  Future<void> pickTime(
      {required BuildContext context, required TextEditingController controller}) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: now,
    );

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
          "${row.day}: Enabled=${row.enabled}, From=${row.fromController.text}, To=${row.toController.text}");
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
