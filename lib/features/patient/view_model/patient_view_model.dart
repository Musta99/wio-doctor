import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PatientViewModel extends ChangeNotifier {
  // Fetch Patients Details including health overview, test history, prescription, report, patient trackers
  bool isLoadingPatientDetails = false;
  Future fetchPatientDetails(String patientId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? doctorId = prefs.getString("doctorId");

    try {
      final patientDetailsRoute =
          "https://www.wiocare.com/api/patient-data?patientId=${patientId}&doctorId=${doctorId}&dataType=all";

      final response = await http.get(Uri.parse(patientDetailsRoute));
      final data = response.body;
      if (response.statusCode == 200) {
        print("Data: $data");
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (err) {
      Fluttertoast.showToast(msg: "Error occured: $err");
    } finally {
      isLoadingPatientDetails = false;
      notifyListeners();
    }
  }
}
