// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wio_doctor/shared/services/api_service.dart';

// class DashboardViewModel extends ChangeNotifier {
//   String? nidNumber;
//   String? clinicAddress;
//   String? role;
//   String? gender;
//   bool? isVerified;
//   bool? isBlocked;
//   String? bmdcRegistrationNumber;
//   String? bio;
//   String? experience;
//   String? uid;
//   List? qualifications;
//   String? hospital;
//   String? availableDays;
//   String? email;
//   String? currentPosition;
//   String? wioId;
//   String? mobile;
//   String? photo;
//   String? dob;
//   String? name;
//   String? educationDegree;
//   String? specialization;
//   Map<String, dynamic>? dashboardSummary;

//   Future fetchDoctorData() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? doctorId = prefs.getString("doctorId");

//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       print('User not authenticated');
//       return null;
//     }

//     final idToken = await user.getIdToken();

//     final String healthOverviewRoute =
//         "${ApiServices.baseUrl}api/dashboard-summary";

//     final response = await http.get(
//       Uri.parse(healthOverviewRoute),
//       headers: {"Authorization": "Bearer $idToken"},
//     );

//     final dashboardData = jsonDecode(response.body);

//     if (response.statusCode == 200) {
//       dashboardSummary = dashboardData;
//       notifyListeners();
//       print("Dashboard summary fetched successfully: ${response.body}");
//     } else {
//       print("Failed to fetch dashboard summary: ${response.statusCode}");
//     }

//     if (doctorId == null) {
//       Fluttertoast.showToast(
//         msg: "No doctorId found",
//         backgroundColor: Colors.red,
//         gravity: ToastGravity.BOTTOM,
//       );
//     }
//     try {
//       final DocumentSnapshot snapshot =
//           await FirebaseFirestore.instance
//               .collection("doctors")
//               .doc(doctorId)
//               .get();

//       final data = snapshot.data() as Map<String, dynamic>?;
//       nidNumber = data!["nidNumber"];
//       clinicAddress = data["clinicAddress"];
//       role = data["role"];
//       gender = data["gender"];
//       isVerified = data["isVerified"];
//       isBlocked = data["isBlocked"];
//       bmdcRegistrationNumber = data["bmdcRegistrationNumber"];
//       bio = data["bio"];
//       experience = data["experience"];
//       uid = data["uid"];
//       qualifications = data["qualifications"];
//       hospital = data["hospital"];
//       availableDays = data["availableDays"];
//       email = data["email"];
//       currentPosition = data["currentPosition"];
//       wioId = data["wioId"];
//       mobile = data["mobile"];
//       photo = data["photo"];
//       dob = data["dob"];
//       educationDegree = data["educationDegree"];
//       name = data["name"];
//       notifyListeners();

//       print("Dashboard data fetched : ${data}");
//     } catch (err) {
//     } finally {}
//   }

//   //  Patient Roaster
//   bool isLoadingPatientRoaster = false;
//   List roasterPatients = [];
//   Future fetchPatientRoaster() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? doctorId = prefs.getString("doctorId");

//     try {
//       isLoadingPatientRoaster = true;
//       notifyListeners();

//       final QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance
//               .collection("patientAccess")
//               .where("doctorId", isEqualTo: doctorId)
//               .where("status", isEqualTo: "granted")
//               .get();

//       print("Roastered Patient: ${querySnapshot.docs}");
//       roasterPatients =
//           querySnapshot.docs
//               .map((doc) => doc.data() as Map<String, dynamic>)
//               .toList();
//       notifyListeners();
//     } catch (err) {
//     } finally {
//       isLoadingPatientRoaster = false;
//       notifyListeners();
//     }
//   }
// }

// ---------------------------- 222222222222222222222 ----------------------------
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wio_doctor/shared/services/api_service.dart';

// class DashboardViewModel extends ChangeNotifier {
//   String? nidNumber;
//   String? clinicAddress;
//   String? role;
//   String? gender;
//   bool? isVerified;
//   bool? isBlocked;
//   String? bmdcRegistrationNumber;
//   String? bio;
//   String? experience;
//   String? uid;
//   List? qualifications;
//   String? hospital;
//   String? availableDays;
//   String? email;
//   String? currentPosition;
//   String? wioId;
//   String? mobile;
//   String? photo;
//   String? dob;
//   String? name;
//   String? educationDegree;
//   String? specialization;
//   Map<String, dynamic>? dashboardSummary;

//   // ── Email verification banner ──────────────────────────
//   bool isEmailVerified = false;
//   bool isRefreshingVerification = false;

//   void _syncEmailVerificationStatus() {
//     final user = FirebaseAuth.instance.currentUser;
//     isEmailVerified = user?.emailVerified ?? false;
//     notifyListeners();
//   }

//   Future<void> refreshEmailVerification() async {
//     isRefreshingVerification = true;
//     notifyListeners();
//     try {
//       await FirebaseAuth.instance.currentUser?.reload();
//       _syncEmailVerificationStatus();
//     } catch (_) {
//     } finally {
//       isRefreshingVerification = false;
//       notifyListeners();
//     }
//   }
//   // ───────────────────────────────────────────────────────

//   Future fetchDoctorData() async {
//     // Sync verification status on every dashboard load
//     _syncEmailVerificationStatus();

//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? doctorId = prefs.getString("doctorId");
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       print('User not authenticated');
//       return null;
//     }
//     final idToken = await user.getIdToken();
//     final String healthOverviewRoute =
//         "${ApiServices.baseUrl}api/dashboard-summary";
//     final response = await http.get(
//       Uri.parse(healthOverviewRoute),
//       headers: {"Authorization": "Bearer $idToken"},
//     );
//     final dashboardData = jsonDecode(response.body);
//     if (response.statusCode == 200) {
//       dashboardSummary = dashboardData;
//       notifyListeners();
//       print("Dashboard summary fetched successfully: ${response.body}");
//     } else {
//       print("Failed to fetch dashboard summary: ${response.statusCode}");
//     }
//     if (doctorId == null) {
//       Fluttertoast.showToast(
//         msg: "No doctorId found",
//         backgroundColor: Colors.red,
//         gravity: ToastGravity.BOTTOM,
//       );
//     }
//     try {
//       final DocumentSnapshot snapshot =
//           await FirebaseFirestore.instance
//               .collection("doctors")
//               .doc(doctorId)
//               .get();
//       final data = snapshot.data() as Map<String, dynamic>?;
//       nidNumber = data!["nidNumber"];
//       clinicAddress = data["clinicAddress"];
//       role = data["role"];
//       gender = data["gender"];
//       isVerified = data["isVerified"];
//       isBlocked = data["isBlocked"];
//       bmdcRegistrationNumber = data["bmdcRegistrationNumber"];
//       bio = data["bio"];
//       experience = data["experience"];
//       uid = data["uid"];
//       qualifications = data["qualifications"];
//       hospital = data["hospital"];
//       availableDays = data["availableDays"];
//       email = data["email"];
//       currentPosition = data["currentPosition"];
//       wioId = data["wioId"];
//       mobile = data["mobile"];
//       photo = data["photo"];
//       dob = data["dob"];
//       educationDegree = data["educationDegree"];
//       name = data["name"];
//       notifyListeners();
//       print("Dashboard data fetched : ${data}");
//     } catch (err) {
//     } finally {}
//   }

//   // ── Patient Roaster ────────────────────────────────────
//   bool isLoadingPatientRoaster = false;
//   List roasterPatients = [];

//   Future fetchPatientRoaster() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? doctorId = prefs.getString("doctorId");
//     try {
//       isLoadingPatientRoaster = true;
//       notifyListeners();
//       final QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance
//               .collection("patientAccess")
//               .where("doctorId", isEqualTo: doctorId)
//               .where("status", isEqualTo: "granted")
//               .orderBy("createdAt", descending: true)
//               .get();
//       print("Roastered Patient: ${querySnapshot.docs}");
//       roasterPatients =
//           querySnapshot.docs
//               .map((doc) => doc.data() as Map<String, dynamic>)
//               .toList();
//       notifyListeners();
//     } catch (err) {
//       print("fetchPatientRoaster error: $err");
//     } finally {
//       isLoadingPatientRoaster = false;
//       notifyListeners();
//     }
//   }
// }

// -------------------------------- 333333333333333333333333333333 ---------------------------
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wio_doctor/shared/services/api_service.dart';

class DashboardViewModel extends ChangeNotifier {
  String? nidNumber;
  String? clinicAddress;
  String? role;
  String? gender;
  bool? isVerified;
  bool? isBlocked;
  String? bmdcRegistrationNumber;
  String? bio;
  String? experience;
  String? uid;
  List? qualifications;
  String? hospital;
  String? availableDays;
  String? email;
  String? currentPosition;
  String? wioId;
  String? mobile;
  String? photo;
  String? dob;
  String? name;
  String? educationDegree;
  String? specialization;
  Map<String, dynamic>? dashboardSummary;

  // New KPIs from web version
  int? pendingReports;
  int? consultationsToday;
  int? completedToday;
  int? remainingToday;

  // Pagination state
  int currentPage = 1;
  int itemsPerPage = 5;
  int totalPages = 1;
  int totalPatients = 0;
  bool isLoadingPatientRoaster = false;
  bool isPaginationLoading = false;
  List roasterPatients = [];

  // ── Email verification banner ──────────────────────────
  bool isEmailVerified = false;
  bool isRefreshingVerification = false;

  void _syncEmailVerificationStatus() {
    final user = FirebaseAuth.instance.currentUser;
    isEmailVerified = user?.emailVerified ?? false;
    notifyListeners();
  }

  Future<void> refreshEmailVerification() async {
    isRefreshingVerification = true;
    notifyListeners();
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      _syncEmailVerificationStatus();
    } catch (_) {
    } finally {
      isRefreshingVerification = false;
      notifyListeners();
    }
  }
  // ───────────────────────────────────────────────────────

  Future<void> fetchDashboardData({int? page, int? limit}) async {
    // Sync verification status on every dashboard load
    _syncEmailVerificationStatus();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('❌ User not authenticated');
      return;
    }

    final idToken = await user.getIdToken();
    if (idToken == null) {
      print('❌ Failed to get ID token');
      return;
    }

    final targetPage = page ?? currentPage;
    final targetLimit = limit ?? itemsPerPage;

    // Determine if this is a pagination request
    final isPaginating = page != null && roasterPatients.isNotEmpty;

    try {
      // Use different loading states for initial load vs pagination
      if (isPaginating) {
        isPaginationLoading = true;
      } else {
        isLoadingPatientRoaster = true;
      }
      notifyListeners();

      print('🔄 Fetching dashboard data: page=$targetPage, limit=$targetLimit');

      // Use combined dashboard endpoint (same as web)
      final url =
          "${ApiServices.baseUrl}api/doctor/dashboard?page=$targetPage&limit=$targetLimit";
      print('📡 API URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $idToken",
          "Content-Type": "application/json",
        },
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Check if response has success flag and data
        if (responseData['success'] == true && responseData['data'] != null) {
          final data = responseData['data'];
          final dashboard = data['dashboard'];
          final pagination = data['pagination'];
          final kpis = dashboard['kpis'];

          print('✅ Dashboard data parsed successfully');
          print('👥 Patients count: ${dashboard['patients']?.length ?? 0}');

          // Update KPIs (matching web version)
          totalPatients = kpis['totalPatients'] ?? 0;
          pendingReports = kpis['pendingReports'] ?? 0;
          consultationsToday = kpis['consultationsToday'] ?? 0;
          completedToday = kpis['completedToday'] ?? 0;
          remainingToday = kpis['remainingToday'] ?? 0;

          // Update pagination
          currentPage = pagination['page'] ?? 1;
          totalPages = pagination['totalPages'] ?? 1;
          itemsPerPage = pagination['limit'] ?? 5;

          // Update patient roster (paginated from server)
          roasterPatients = dashboard['patients'] ?? [];

          print('✅ Updated patients list: ${roasterPatients.length} patients');

          // Update legacy dashboard summary for backward compatibility
          dashboardSummary = {
            'totalAccess': totalPatients,
            'grantedAccessCount': totalPatients,
            'pendingAccessCount': kpis['pendingPatientCount'] ?? 0,
            'pendingReports': pendingReports,
            'consultationsToday': consultationsToday,
            'completedToday': completedToday,
            'remainingToday': remainingToday,
          };

          notifyListeners();
          print("✅ Dashboard data fetched successfully");
        } else {
          print('❌ Invalid response structure');
          Fluttertoast.showToast(
            msg: "Invalid response from server",
            backgroundColor: Colors.red,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized - Token may be invalid');
        Fluttertoast.showToast(
          msg: "Session expired. Please login again.",
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        print("❌ Failed to fetch dashboard: ${response.statusCode}");
        Fluttertoast.showToast(
          msg: "Failed to load dashboard data (${response.statusCode})",
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (err, stackTrace) {
      print("❌ fetchDashboardData error: $err");
      print("📍 Stack trace: $stackTrace");
      Fluttertoast.showToast(
        msg: "Error loading dashboard",
        backgroundColor: Colors.red,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      isLoadingPatientRoaster = false;
      isPaginationLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDoctorProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? doctorId = prefs.getString("doctorId");

    if (doctorId == null) {
      print("❌ No doctorId found in prefs");
      return;
    }

    print('🔄 Fetching doctor profile for ID: $doctorId');

    try {
      final DocumentSnapshot snapshot =
          await FirebaseFirestore.instance
              .collection("doctors")
              .doc(doctorId)
              .get();

      if (!snapshot.exists) {
        print("❌ Doctor document does not exist");
        return;
      }

      final data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        nidNumber = data["nidNumber"];
        clinicAddress = data["clinicAddress"];
        role = data["role"];
        gender = data["gender"];
        isVerified = data["isVerified"];
        isBlocked = data["isBlocked"];
        bmdcRegistrationNumber = data["bmdcRegistrationNumber"];
        bio = data["bio"];
        experience = data["experience"];
        uid = data["uid"];
        qualifications = data["qualifications"];
        hospital = data["hospital"];
        availableDays = data["availableDays"];
        email = data["email"];
        currentPosition = data["currentPosition"];
        wioId = data["wioId"];
        mobile = data["mobile"];
        photo = data["photo"];
        dob = data["dob"];
        educationDegree = data["educationDegree"];
        name = data["name"];
        specialization = data["specialization"];
        notifyListeners();
        print("✅ Doctor profile fetched: $name");
      }
    } catch (err, stackTrace) {
      print("❌ fetchDoctorProfile error: $err");
      print("📍 Stack trace: $stackTrace");
    }
  }

  // Pagination control
  Future<void> goToPage(int page) async {
    if (page >= 1 && page <= totalPages && page != currentPage) {
      print('📄 Navigating to page $page');
      await fetchDashboardData(page: page);
    }
  }

  // Legacy method for backward compatibility
  Future<void> fetchDoctorData() async {
    print('🔄 fetchDoctorData called');
    await fetchDoctorProfile();
    await fetchDashboardData();
  }

  // Legacy method - now uses combined endpoint
  Future<void> fetchPatientRoaster() async {
    print('🔄 fetchPatientRoaster called (legacy)');
    // This is now handled by fetchDashboardData
    // Keeping for compatibility if called elsewhere
    if (roasterPatients.isEmpty) {
      await fetchDashboardData();
    }
  }
}
