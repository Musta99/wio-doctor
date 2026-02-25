import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';

class DigitalPrescriptionViewModel extends ChangeNotifier {
  // -------------- Get all patients list granted by doctor -------------------
  bool isLoadingPatientsList = false;
  List grantedPatientList = [];

  Future fetchGrantedPatientsList(BuildContext context) async {
    try {
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
     
    } catch (err) {
      Fluttertoast.showToast(
        msg: "Error occured: $err",
        backgroundColor: Colors.red,
      );
      print("Upload error: $err");
    } finally {
      isLoadingPatientsList = false;
      notifyListeners();
    }
  }
}
