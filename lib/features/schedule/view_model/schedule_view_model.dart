import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';

class ScheduleViewModel extends ChangeNotifier {
  bool isScheduleFetchLoading = false;
  Future fetchDoctorSchedule(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? doctorId = prefs.getString("doctorId");

    if (doctorId == null) {
      return;
    }

    final token = Provider.of<AuthenticationProvider>(context).token;
    print("Doctor ID is-------- $doctorId");
    print("Bearer token is ---------  $token");
  }
}
