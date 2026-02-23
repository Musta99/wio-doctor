import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';

class AppointmentViewModel extends ChangeNotifier {
  // ----------  Fetch appointments --------------
  bool isLoadingAppointmentsFetch = false;
  Future fetchDoctorsAppointments(BuildContext context) async {
    try {
      isLoadingAppointmentsFetch = true;
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

      final appointmentsFetchRoute =
          "https://www.wiocare.com/api/doctor/appointments?doctorId=${doctorId}";
      final response = await http.get(
        Uri.parse(appointmentsFetchRoute),
        headers: {"Authorization": "Bearer $token"},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // scheduleData = data["availability"];
        // notifyListeners();
        print("Data: $data");
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (err) {
      print(err.toString());
      Fluttertoast.showToast(msg: "Error occured: $err");
    } finally {
      isLoadingAppointmentsFetch = false;
      notifyListeners();
    }
  }
}
