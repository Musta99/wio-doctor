import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';

class DigitalPrescriptionViewModel extends ChangeNotifier {
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
  String? selectedPatient;
  void selectPatient(value) {
    selectedPatient = value;
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
    meds[index].morning = !meds[index].morning;
    notifyListeners();
  }

  void toggleNoon(int index) {
    meds[index].noon = !meds[index].noon;
    notifyListeners();
  }

  void toggleNight(int index) {
    meds[index].night = !meds[index].night;
    notifyListeners();
  }

  /// Instruction select
  void setInstruction(int index, String? value) {
    meds[index].instruction = value;
    notifyListeners();
  }
}

// -------------- MedRow Class -------------
class MedRow {
  final name = TextEditingController();
  final strength = TextEditingController();
  final duration = TextEditingController();

  bool morning = false;
  bool noon = false;
  bool night = false;

  String? instruction;

  void dispose() {
    name.dispose();
    strength.dispose();
    duration.dispose();
  }
}
