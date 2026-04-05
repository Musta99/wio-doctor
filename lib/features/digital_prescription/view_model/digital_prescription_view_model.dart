import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wio_doctor/features/profile/view_model/profile_view_model.dart';
import 'package:wio_doctor/shared/services/api_service.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';

class DigitalPrescriptionViewModel extends ChangeNotifier {
  // ---------------- Fetch granted patients List --------------------
  bool isLoadingPatientsList = false;
  List<Map<String, dynamic>> grantedPatientList = [];

  Future fetchGrantedPatientsList(BuildContext context) async {
    try {
      isLoadingPatientsList = true;
      notifyListeners();

      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );

      String? token = await authProvider.getFreshToken();
      String? doctorId = authProvider.userId;

      if (doctorId == null || token == null) return;

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance
              .collection("patientAccess")
              .where("doctorId", isEqualTo: doctorId)
              .where("status", isEqualTo: "granted")
              .get();

      /// ✅ Store fetched data
      grantedPatientList =
          querySnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
    } catch (err) {
      Fluttertoast.showToast(
        msg: "Error occured: $err",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoadingPatientsList = false;
      notifyListeners();
    }
  }

  // ----------- Select Patient from dropdown -----------
  Map? selectedPatient; // {"name": "...", "id": "..."}

  void selectPatient(Map patient) {
    selectedPatient = patient;
    notifyListeners();
  }

  // -------------------- Get Medicines Name ----------------------------
  bool isLoadingMedicinesList = false;
  List medicinesList = [];
  Future getMedicinesList(String medicineName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not authenticated');
      return null;
    }

    final idToken = await user.getIdToken();
    try {
      isLoadingMedicinesList = true;
      notifyListeners();

      final response = await http.get(
        Uri.parse("${ApiServices.baseUrl}api/medicines?q=${medicineName}"),
        headers: {"Authorization": "Bearer $idToken"},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        medicinesList = data["data"];
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (err) {
      Fluttertoast.showToast(
        msg: "Error occured: $err",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoadingMedicinesList = false;
      notifyListeners();
    }
  }

  //  -------------------- Clear medicine List ------------------
  void clearMedicinesList() {
    medicinesList = [];
    notifyListeners();
  }

  // ---------------------------------------
  List<MedRow> meds = [MedRow()];

  /// Add medicine
  void addMed() {
    meds.add(MedRow());
    notifyListeners();
  }

  /// Remove medicine
  void removeMed(int index) {
    if (meds.length == 1) return;
    meds[index].dispose();
    meds.removeAt(index);
    notifyListeners();
  }

  /// Toggle timing
  void toggleMorning(int index) {
    meds[index].morning = meds[index].morning + 1;
    notifyListeners();
  }

  void toggleNoon(int index) {
    meds[index].noon = meds[index].noon + 1;
    notifyListeners();
  }

  void toggleNight(int index) {
    meds[index].night = meds[index].night + 1;
    notifyListeners();
  }

  /// Instruction select
  void setInstruction(int index, String? value) {
    meds[index].instruction = value;
    notifyListeners();
  }

  // ---------------- Validation----------
  // Add this validation method above createPrescription
  String? validatePrescription(String testsText) {
    if (selectedPatient == null) {
      return "Please select a patient before saving.";
    }

    if (meds.isEmpty) {
      return "Please add at least one medicine.";
    }

    final hasEmptyMed = meds.any((m) => m.name.text.trim().isEmpty);
    if (hasEmptyMed) {
      return "Please fill in all medicine names.";
    }

    return null; // null means valid
  }

  // --------------------- Create a Prescription ---------------------
  bool isLoadingCreation = false;
  Future createPrescription(
    BuildContext context,
    String patientId,
    String testC,
    String suggestionCtrl,
    String patientName,
  ) async {
    // Capture before any await
    final authProvider = context.read<AuthenticationProvider>();
    final doctorName = context.read<ProfileViewModel>().fullNameC.text;

    try {
      isLoadingCreation = true;
      notifyListeners();

      final String? token = await authProvider.getFreshToken();
      final String? doctorId = authProvider.userId;

      if (doctorId == null || token == null) return;

      final medicinesJson = meds.map((e) => e.toJson()).toList();

      final prescriptionDate =
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

      final bodyData = {
        "fileInfo": null,
        "patientId": patientId,
        "manualData": {
          "patientId": patientId,
          "medicines": medicinesJson,
          "tests": testC.split(",").map((e) => e.trim()).toList(),
          "suggestions": suggestionCtrl,
          "doctorId": doctorId,
          "doctorName": doctorName, // ✅ captured before await
          "patientName": patientName,
          "prescriptionDate": prescriptionDate,
          "language": "en",
        },
      };

      final response = await http.post(
        Uri.parse("${ApiServices.baseUrl}api/create-prescription"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        clearAllFields();
        Fluttertoast.showToast(
          msg: "Prescription created successfully",
          backgroundColor: Colors.green,
        );
      } else {
        debugPrint("Error: ${response.statusCode} - ${response.body}");
        Fluttertoast.showToast(
          msg: "Failed to create prescription. Please try again.",
          backgroundColor: Colors.red,
        );
      }
    } catch (err) {
      debugPrint(err.toString());
      Fluttertoast.showToast(
        msg: "Error occurred: $err",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoadingCreation = false;
      notifyListeners();
    }
  }

  // ---------------- Clear full form after successfull creation --------------
  void clearAllFields() {
    /// Clear all medicine controllers
    for (final med in meds) {
      med.dispose();
    }

    /// Reset medicine list with one empty row
    meds = [MedRow()];

    /// Clear patient selection
    selectedPatient = null;

    /// Clear medicine search list
    medicinesList = [];

    notifyListeners();
  }
}

// -------------- MedRow Class -------------
class MedRow {
  final name = TextEditingController();
  final strength = TextEditingController();
  final duration = TextEditingController();

  int morning = 0;
  int noon = 0;
  int night = 0;

  String? instruction;

  void dispose() {
    name.dispose();
    strength.dispose();
    duration.dispose();
  }

  Map<String, dynamic> toJson() {
    // Compute timing string like "1-0-1"
    final timing = "${morning}-${noon}-${night}";

    return {
      "name": name.text,
      "strength": strength.text,
      "duration": duration.text,
      "instructions": instruction ?? "",
      "morning": morning,
      "noon": noon,
      "night": night,
      "timing": timing,
      "isVerified": true, // default, can be dynamic
    };
  }
}
