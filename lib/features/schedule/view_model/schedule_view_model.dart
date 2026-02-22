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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? doctorId = prefs.getString("doctorId");
    String? token = prefs.getString("auth_token");

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
}
