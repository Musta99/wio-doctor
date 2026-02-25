import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("patientAccess")
          .where("doctorId", isEqualTo: doctorId)
          .where("status", isEqualTo: "granted")
          .get();

      /// ✅ Store fetched data
      grantedPatientList = querySnapshot.docs
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
}
