import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ClinicalReviewViewModel extends ChangeNotifier {
  // ---------------- Load all the reports of that patient -----------------------
  bool isReportFetchLoading = false;
  List reportsList = [];
  Future fetchPatientReports(String patientId) async {
    reportsList.clear();
    notifyListeners();
    try {
      isReportFetchLoading = true;
      notifyListeners();
      final patientReportsFetchRoute =
          "https://www.wiocare.com/api/patient-data?patientId=${patientId}&dataType=reports&page=1&pageSize=10";

      final response = await http.get(Uri.parse(patientReportsFetchRoute));
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
}
