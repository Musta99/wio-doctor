import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';

class PatientAccessViewModel extends ChangeNotifier {
  bool isSendingRequest = false;

  Future<void> sendAccessRequest(BuildContext context, String patientId) async {
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );

    String? doctorId = authProvider.userId;

    if (doctorId == null) {
      throw Exception("User not authenticated");
    }

    try {
      isSendingRequest = true;
      notifyListeners();

      final firestore = FirebaseFirestore.instance;

      /// same as buildAccessDocId(patientId, doctorId)
      final docId = "${patientId}_$doctorId";
      final docRef = firestore.collection("access_requests").doc(docId);
      final snapshot = await docRef.get();
      final now = FieldValue.serverTimestamp();

      // -----------------------------
      // CASE 1 → document not exists
      // -----------------------------
      if (!snapshot.exists) {
        await docRef.set({
          "doctorId": doctorId,
          "patientId": patientId,
          "status": "pending",
          "requestedBy": "doctor",
          "createdAt": now,
          "updatedAt": now,
        });

        Fluttertoast.showToast(msg: "Access request sent");
        return;
      }

      // -----------------------------
      // CASE 2 → document exists
      // -----------------------------
      final data = snapshot.data() as Map<String, dynamic>? ?? {};

      if (data["status"] == "granted") {
        Fluttertoast.showToast(msg: "Access already granted");
        return;
      }

      if (data["status"] == "pending" && data["requestedBy"] == "doctor") {
        Fluttertoast.showToast(msg: "Request already pending");
        return;
      }

      // -----------------------------
      // CASE 3 → update request
      // -----------------------------
      await docRef.update({
        "status": "pending",
        "requestedBy": "doctor",
        "patientId": patientId,
        "doctorId": doctorId,
        "updatedAt": now,
      });

      Fluttertoast.showToast(msg: "Access request updated");
    } catch (err) {
      Fluttertoast.showToast(msg: "Error: $err", backgroundColor: Colors.red);
    } finally {
      isSendingRequest = false;
      notifyListeners();
    }
  }

  // ---------------------- Get Patients List ---------------------
  bool isPatientsListLoading = false;
  List<Map<String, dynamic>> patientList = [];

  Future findPatient(String email) async {
    try {
      isPatientsListLoading = true;
      notifyListeners();

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance
              .collection("patients")
              .where("email", isGreaterThanOrEqualTo: email)
              .where(
                "email",
                isLessThanOrEqualTo: "$email\uf8ff",
              ) // ✅ For prefix search
              .get();

      patientList =
          querySnapshot.docs
              .map(
                (doc) => {"id": doc.id, ...doc.data() as Map<String, dynamic>},
              )
              .toList();

      
    } catch (err) {
      Fluttertoast.showToast(msg: "Error: $err", backgroundColor: Colors.red);
    } finally {
      isPatientsListLoading = false;
      notifyListeners();
    }
  }
}
