import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardViewModel extends ChangeNotifier {
  Future fetchDoctorData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? doctorId = prefs.getString("doctorId");

    if (doctorId == null) {
      Fluttertoast.showToast(
        msg: "No doctorId found",
        backgroundColor: Colors.red,
        gravity: ToastGravity.BOTTOM,
      );
    }
    try {
      final DocumentSnapshot snapshot =
          await FirebaseFirestore.instance
              .collection("doctors")
              .doc(doctorId)
              .get();
      print(snapshot.data);
    } catch (err) {
    } finally {}
  }
}
