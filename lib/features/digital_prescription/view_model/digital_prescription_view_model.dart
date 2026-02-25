import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wio_doctor/features/profile/view_model/profile_view_model.dart';
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
    try {
      isLoadingMedicinesList = true;
      notifyListeners();

      final response = await http.get(
        Uri.parse("https://www.wiocare.com/api/medicines?q=${medicineName}"),
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

  // --------------------- Create a Prescription ---------------------
  bool isLoadingCreation = false;
  Future createPrescription(
    BuildContext context,
    String patientId,
    String testC,
    String suggestionCtrl,
    String patientName,
  ) async {
    try {
      isLoadingCreation = true;
      notifyListeners();

      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );

      String? token = await authProvider.getFreshToken();
      String? doctorId = authProvider.userId;

      if (doctorId == null || token == null) return;

      final medicinesJson = meds.map((e) => e.toJson()).toList();

      final prescriptionDate =
          "${DateTime.now().year.toString()}-${DateTime.now().month.toString()}-${DateTime.now().day.toString()}";

      final bodyData = {
        "fileInfo": null,
        "patientId": patientId,
        "manualData": {
          "patientId": patientId,
          "medicines": medicinesJson,
          "tests": testC.split(",").map((e) => e.trim()).toList(),
          "suggestions": suggestionCtrl,
          "doctorId": doctorId,
          "doctorName":
              Provider.of<ProfileViewModel>(
                context,
                listen: false,
              ).fullNameC.text,
          "patientName": patientName,
          "prescriptionDate": prescriptionDate,
          "language": "en",
        },
      };

      final response = await http.post(
        Uri.parse("https://www.wiocare.com/api/create-prescription"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        print(response.body);

        clearAllFields(); // ⭐ reset everything

        Fluttertoast.showToast(
          msg: "Prescription created succesfully",
          backgroundColor: Colors.green,
        );
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
