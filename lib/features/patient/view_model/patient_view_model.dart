import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PatientViewModel extends ChangeNotifier {
  // Fetch Patients Details including health overview, test history, prescription, report, patient trackers
  bool isLoadingPatientDetails = false;
  Map patientDetailsData = {};
  Future fetchPatientDetails(String patientId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? doctorId = prefs.getString("doctorId");

    try {
      isLoadingPatientDetails = true;
      notifyListeners();
      final patientDetailsRoute =
          "https://www.wiocare.com/api/patient-data?patientId=${patientId}&doctorId=${doctorId}&dataType=all";

      final response = await http.get(Uri.parse(patientDetailsRoute));
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        patientDetailsData = data["data"];
        notifyListeners();
        print("Data: $patientDetailsData");
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (err) {
      print(err.toString());
      Fluttertoast.showToast(msg: "Error occured: $err");
    } finally {
      isLoadingPatientDetails = false;
      notifyListeners();
    }
  }

  // Fetch report details
  bool isLoadingReportFetch = false;
  Map reportDetails = {};
  Future fetchReportDetails(String patientId, String reportId) async {
    try {
      isLoadingReportFetch = true;
      notifyListeners();

      final reportFetchRoute =
          "https://www.wiocare.com/api/patient-data?patientId=${patientId}&dataType=reports&reportId=${reportId}";
      final response = await http.get(Uri.parse(reportFetchRoute));
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        reportDetails = data;
        notifyListeners();
        print("Data: $reportDetails");
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (err) {
    } finally {
      isLoadingReportFetch = false;
      notifyListeners();
    }
  }
}
