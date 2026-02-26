import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ClinicalReviewViewModel extends ChangeNotifier {
  // ---------------- Load all the reports of that patient -----------------------
  bool isReportFetchLoading = false;
  Future fetchPatientReports(String patientId) async {
    try {
      isReportFetchLoading = true;
      notifyListeners();
      final patientReportsFetchRoute =
          "/api/patient-data?patientId=${patientId}&dataType=reports&page=1&pageSize=10";

      final response = await http.get(Uri.parse(patientReportsFetchRoute));
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // patientDetailsData = data["data"];
        // notifyListeners();
        print("Data: $data");
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
