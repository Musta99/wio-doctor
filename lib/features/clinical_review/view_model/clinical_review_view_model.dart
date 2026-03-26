import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:wio_doctor/shared/services/api_service.dart';

class ClinicalReviewViewModel extends ChangeNotifier {
  // ---------------- Load all the reports of that patient -----------------------
  bool isReportFetchLoading = false;
  List reportsList = [];
  Future fetchPatientReports(String patientId) async {
    reportsList.clear();
    notifyListeners();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not authenticated');
      return null;
    }

    final idToken = await user.getIdToken();
    try {
      isReportFetchLoading = true;
      notifyListeners();
      final patientReportsFetchRoute =
          "${ApiServices.baseUrl}api/patient-data?patientId=${patientId}&dataType=reports&page=1&pageSize=10";

      final response = await http.get(
        Uri.parse(patientReportsFetchRoute),
        headers: {"Authorization": "Bearer $idToken"},
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        reportsList = data["data"];
        notifyListeners();
        print("Data: $reportsList");
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (err) {
      print(err.toString());
      Fluttertoast.showToast(
        msg: "Error occured: $err",
        backgroundColor: Colors.red,
      );
    } finally {
      isReportFetchLoading = false;
      notifyListeners();
    }
  }

  // ---------------- Wio Report analyzer ----------------------
  bool isReportAnalyzing = false;
  Map? clinicalReviewData;
  Future analyzingReports(List reports) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('User not authenticated');
        return null;
      }

      final idToken = await user.getIdToken();
      isReportAnalyzing = true;
      notifyListeners();

      final reportsAnalyzingRoute = "${ApiServices.baseUrl}api/clinical-review";

      final response = await http.post(
        Uri.parse(reportsAnalyzingRoute),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $idToken",
        },
        body: jsonEncode({'reports': reports}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        clinicalReviewData = data["data"];
        notifyListeners();

        // print("Data: $clinicalReviewData");
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (err) {
      print(err.toString());
      Fluttertoast.showToast(
        msg: "Error occured: $err",
        backgroundColor: Colors.red,
      );
    } finally {
      isReportAnalyzing = false;
      notifyListeners();
    }
  }

  // ------------------- rsest ------
  void resetForNewPatient() {
    reportsList = [];
    clinicalReviewData = null;
    isReportAnalyzing = false;
    notifyListeners();
  }
}
