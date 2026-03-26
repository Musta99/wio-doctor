// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class PatientViewModel extends ChangeNotifier {
//   // Fetch Patients Details including health overview, test history, prescription, report, patient trackers
//   bool isLoadingPatientDetails = false;
//   Map patientDetailsData = {};
//   Future fetchPatientDetails(String patientId) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? doctorId = prefs.getString("doctorId");

//     try {
//       isLoadingPatientDetails = true;
//       notifyListeners();
//       final patientDetailsRoute =
//           "https://www.wiocare.com/api/patient-data?patientId=${patientId}&doctorId=${doctorId}&dataType=all";

//       final response = await http.get(Uri.parse(patientDetailsRoute));
//       final data = jsonDecode(response.body);
//       if (response.statusCode == 200) {
//         patientDetailsData = data["data"];
//         notifyListeners();
//         print("----------------Data: $patientDetailsData");
//       } else {
//         print(response.statusCode);
//         print(response.body);
//       }
//     } catch (err) {
//       print(err.toString());
//       Fluttertoast.showToast(msg: "Error occured: $err");
//     } finally {
//       isLoadingPatientDetails = false;
//       notifyListeners();
//     }
//   }

//   // Fetch report details
//   bool isLoadingReportFetch = false;
//   Map reportDetails = {};
//   Future fetchReportDetails(String patientId, String reportId) async {
//     try {
//       isLoadingReportFetch = true;
//       notifyListeners();

//       final reportFetchRoute =
//           "https://www.wiocare.com/api/patient-data?patientId=${patientId}&dataType=reports&reportId=${reportId}";
//       final response = await http.get(Uri.parse(reportFetchRoute));
//       final data = jsonDecode(response.body);
//       if (response.statusCode == 200) {
//         reportDetails = data;
//         notifyListeners();
//         print("Data: $reportDetails");
//       } else {
//         print(response.statusCode);
//         print(response.body);
//       }
//     } catch (err) {
//       Fluttertoast.showToast(msg: "Error occured: $err");
//     } finally {
//       isLoadingReportFetch = false;
//       notifyListeners();
//     }
//   }

//   // Fetch prescription details
//   bool isLoadingPrescriptionFetch = false;
//   Map prescriptionDetails = {};
//   Future fetchPrescriptionDetails(
//     String patientId,
//     String prescriptionId,
//   ) async {
//     try {
//       isLoadingPrescriptionFetch = true;
//       notifyListeners();

//       final prescriptionFetchRoute =
//           "https://www.wiocare.com/api/patient-data?patientId=${patientId}&dataType=prescriptions&prescriptionId=${prescriptionId}";
//       final response = await http.get(Uri.parse(prescriptionFetchRoute));
//       final data = jsonDecode(response.body);
//       if (response.statusCode == 200) {
//         prescriptionDetails = data;
//         notifyListeners();
//         print("Data: $prescriptionDetails");
//       } else {
//         print(response.statusCode);
//         print(response.body);
//       }
//     } catch (err) {
//       Fluttertoast.showToast(msg: "Error occured: $err");
//     } finally {
//       isLoadingPrescriptionFetch = false;
//       notifyListeners();
//     }
//   }

//   // Add Vitals to specific patient
//   bool isPatientVitalsAddLoading = false;
//   Future addNewVitals(
//     String patientId,
//     String bp,
//     int sugar,
//     String date,
//     String? note,
//   ) async {
//     try {
//       isPatientVitalsAddLoading = true;
//       notifyListeners();

//       final String patientVitalsAddRoute =
//           "https://www.wiocare.com/api/patient-data?patientId=${patientId}&dataType=vitals";
//       final response = await http.post(
//         Uri.parse(patientVitalsAddRoute),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//         },
//         body: jsonEncode({
//           "bp": bp,
//           "sugar": sugar,
//           "date": date,
//           "notes": note,
//         }),
//       );

//       if (response.statusCode == 201) {
//         print("Succesfully Saved");
//         Fluttertoast.showToast(
//           msg: "Vitals saved successfully",
//           backgroundColor: Colors.green,
//         );

//         await fetchPatientDetails(patientId);
//       } else {
//         print(response.statusCode);
//         print(response.body);
//       }
//     } catch (err) {
//       Fluttertoast.showToast(msg: "Error occured: $err");
//     } finally {
//       isPatientVitalsAddLoading = false;
//       notifyListeners();
//     }
//   }

//   // Synthasize patient data for health overview
// bool isSynthasizingHealthOverview = false;
// Map healthOverviewData = {};

// Future synthasizeHealthOverview(
//   Map vitals,
//   List keyDiagnoses,
//   Map medicationAdherence,
// ) async {
//   try {
//     isSynthasizingHealthOverview = true;
//     notifyListeners();

//     final String healthOverviewRoute =
//         "https://www.wiocare.com/api/synthesize-patient-data";

//     final response = await http.post(
//       Uri.parse(healthOverviewRoute),
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode({
//         "vitals": jsonEncode(vitals), // same as JSON.stringify(vitals)
//         "keyDiagnoses": keyDiagnoses,
//         "medicationAdherence": medicationAdherence,
//       }),
//     );

//     final data = jsonDecode(response.body);

//     if (response.statusCode == 200) {
//       healthOverviewData = data["data"];
//       notifyListeners();

//       print("Health Overview: $healthOverviewData");
//     } else {
//       print(response.statusCode);
//       print(response.body);
//     }
//   } catch (err) {
//     Fluttertoast.showToast(msg: "Error occurred: $err");
//   } finally {
//     isSynthasizingHealthOverview = false;
//     notifyListeners();
//   }
// }
// }

// ---------------------------- 2222222222222222222222222222222 ---------------------------
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wio_doctor/shared/services/api_service.dart';

class PatientViewModel extends ChangeNotifier {
  // ===============================
  // Fetch Patients Details
  // ===============================
  bool isLoadingPatientDetails = false;
  Map<String, dynamic> patientDetailsData = {};

  Future<void> fetchPatientDetails(String patientId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? doctorId = prefs.getString("doctorId");
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not authenticated');
      return null;
    }

    final idToken = await user.getIdToken();

    try {
      isLoadingPatientDetails = true;
      notifyListeners();

      final patientDetailsRoute =
          "${ApiServices.baseUrl}api/patient-data"
          "?patientId=$patientId&doctorId=$doctorId&dataType=all";

      final response = await http.get(
        Uri.parse(patientDetailsRoute),
        headers: {"Authorization": "Bearer $idToken"},
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        patientDetailsData =
            (data["data"] is Map)
                ? Map<String, dynamic>.from(data["data"])
                : {};
        notifyListeners();
        debugPrint("----------------Data: $patientDetailsData");
      } else {
        debugPrint("${response.statusCode}");
        debugPrint(response.body);
      }
    } catch (err) {
      debugPrint(err.toString());
      Fluttertoast.showToast(msg: "Error occured: $err");
    } finally {
      isLoadingPatientDetails = false;
      notifyListeners();
    }
  }

  // ===============================
  // Fetch report details
  // ===============================
  bool isLoadingReportFetch = false;
  Map<String, dynamic> reportDetails = {};

  Future<void> fetchReportDetails(String patientId, String reportId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not authenticated');
      return null;
    }

    final idToken = await user.getIdToken();
    try {
      isLoadingReportFetch = true;
      notifyListeners();

      final reportFetchRoute =
          "${ApiServices.baseUrl}api/patient-data"
          "?patientId=$patientId&dataType=reports&reportId=$reportId";

      final response = await http.get(
        Uri.parse(reportFetchRoute),
        headers: {"Authorization": "Bearer $idToken"},
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        reportDetails = (data is Map) ? Map<String, dynamic>.from(data) : {};
        notifyListeners();
        debugPrint("Data: $reportDetails");
      } else {
        debugPrint("${response.statusCode}");
        debugPrint(response.body);
      }
    } catch (err) {
      Fluttertoast.showToast(msg: "Error occured: $err");
    } finally {
      isLoadingReportFetch = false;
      notifyListeners();
    }
  }

  // ===============================
  // Fetch prescription details
  // ===============================
  bool isLoadingPrescriptionFetch = false;
  Map<String, dynamic> prescriptionDetails = {};

  Future<void> fetchPrescriptionDetails(
    String patientId,
    String prescriptionId,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not authenticated');
      return null;
    }

    final idToken = await user.getIdToken();
    try {
      isLoadingPrescriptionFetch = true;
      notifyListeners();

      final prescriptionFetchRoute =
          "${ApiServices.baseUrl}api/patient-data"
          "?patientId=$patientId&dataType=prescriptions&prescriptionId=$prescriptionId";

      final response = await http.get(
        Uri.parse(prescriptionFetchRoute),
        headers: {"Authorization": "Bearer $idToken"},
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        prescriptionDetails =
            (data is Map) ? Map<String, dynamic>.from(data) : {};
        notifyListeners();
        debugPrint("Data: $prescriptionDetails");
      } else {
        debugPrint("${response.statusCode}");
        debugPrint(response.body);
      }
    } catch (err) {
      Fluttertoast.showToast(msg: "Error occured: $err");
    } finally {
      isLoadingPrescriptionFetch = false;
      notifyListeners();
    }
  }

  // ===============================
  // Add Vitals
  // ===============================
  bool isPatientVitalsAddLoading = false;

  Future<void> addNewVitals(
    String patientId,
    String bp,
    int sugar,
    String date,
    String? note,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not authenticated');
      return null;
    }

    final idToken = await user.getIdToken();
    try {
      isPatientVitalsAddLoading = true;
      notifyListeners();

      final String patientVitalsAddRoute =
          "${ApiServices.baseUrl}api/patient-data?patientId=$patientId&dataType=vitals";

      final response = await http.post(
        Uri.parse(patientVitalsAddRoute),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $idToken",
        },
        body: jsonEncode({
          "bp": bp,
          "sugar": sugar,
          "date": date,
          "notes": note,
        }),
      );

      if (response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: "Vitals saved successfully",
          backgroundColor: Colors.green,
        );

        await fetchPatientDetails(patientId);
      } else {
        debugPrint("${response.statusCode}");
        debugPrint(response.body);
      }
    } catch (err) {
      Fluttertoast.showToast(msg: "Error occured: $err");
    } finally {
      isPatientVitalsAddLoading = false;
      notifyListeners();
    }
  }

  // ===============================
  // Synthesize patient data (Health overview)
  // ===============================
  bool isSynthasizingHealthOverview = false;
  Map<String, dynamic> healthOverviewData = {};

  /// Pass only medicationAdherence from UI.
  /// vitals + keyDiagnoses will be derived from patientDetailsData.
  Future<void> synthasizeHealthOverview(
    // required dynamic medicationAdherence,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not authenticated');
      return null;
    }

    final idToken = await user.getIdToken();
    try {
      isSynthasizingHealthOverview = true;
      healthOverviewData = {};
      notifyListeners();

      // 1) vitals (from patientDetailsData["vitals"])
      final List<dynamic> vitals =
          (patientDetailsData["vitals"] as List?)?.cast<dynamic>() ?? [];

      // 2) keyDiagnoses (from reports[].analysis.majorIssues)
      final List<String> keyDiagnoses = _extractKeyDiagnoses(
        patientDetailsData,
      );

      // 3) POST request (same as your web)
      final String healthOverviewRoute =
          "${ApiServices.baseUrl}api/synthesize-patient-data";

      final response = await http.post(
        Uri.parse(healthOverviewRoute),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken",
        },
        body: jsonEncode({
          "vitals": jsonEncode(
            vitals,
          ), // ✅ like JSON.stringify(patientData.vitals)
          "keyDiagnoses": keyDiagnoses,
          // "medicationAdherence": medicationAdherence,
        }),
      );

      final decoded = _safeJsonDecode(response.body);

      if (response.statusCode == 200) {
        if (decoded is Map && decoded["data"] != null) {
          healthOverviewData = Map<String, dynamic>.from(decoded["data"]);
        } else if (decoded is Map) {
          healthOverviewData = Map<String, dynamic>.from(decoded);
        } else {
          healthOverviewData = {"data": decoded};
        }

        notifyListeners();
        debugPrint("✅ Health Overview: $healthOverviewData");
      } else {
        debugPrint("❌ ${response.statusCode}");
        debugPrint(response.body);
        Fluttertoast.showToast(msg: "Failed: ${response.statusCode}");
      }
    } catch (err) {
      Fluttertoast.showToast(msg: "Error occurred: $err");
    } finally {
      isSynthasizingHealthOverview = false;
      notifyListeners();
    }
  }

  // ===============================
  // Helpers
  // ===============================
  List<String> _extractKeyDiagnoses(Map<String, dynamic> data) {
    final reports = data["reports"];
    final Set<String> unique = {};

    if (reports is List) {
      for (final r in reports) {
        if (r is! Map) continue;
        final analysis = r["analysis"];
        if (analysis is! Map) continue;

        final majorIssues = analysis["majorIssues"];
        if (majorIssues is! List) continue;

        for (final issue in majorIssues) {
          final s = _issueToString(issue).trim();
          if (s.isNotEmpty) unique.add(s);
        }
      }
    }

    return unique.toList();
  }

  String _issueToString(dynamic issue) {
    if (issue == null) return "";
    if (issue is String) return issue;

    if (issue is Map) {
      final en = issue["en"];
      if (en is String && en.trim().isNotEmpty) return en;

      final name = issue["name"];
      if (name is String && name.trim().isNotEmpty) return name;

      final description = issue["description"];
      if (description is String && description.trim().isNotEmpty) {
        return description;
      }
    }
    return "";
  }

  dynamic _safeJsonDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }
}
