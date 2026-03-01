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
      final docRef = firestore.collection("patientAccess").doc(docId);
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

        // Notify the patient
        await createNotification(
          recipientId: patientId,
          titleKey: "access_request_received",
          descriptionKey: "access_request_received_desc",
          type: "access_request",
          patientId: patientId,
          doctorId: doctorId,
        );

        Fluttertoast.showToast(msg: "Access request sent");
        return;
      }

      // -----------------------------
      // CASE 2 → document exists
      // -----------------------------
      final data = snapshot.data() as Map<String, dynamic>? ?? {};

      if (data["status"] == "granted") {
        Fluttertoast.showToast(
          msg: "Access already granted",
          backgroundColor: Colors.orange,
        );
        return;
      }

      if (data["status"] == "pending" && data["requestedBy"] == "doctor") {
        Fluttertoast.showToast(
          msg: "Request already pending",
          backgroundColor: Colors.yellowAccent,
        );
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

      // ✅ Notify the patient
      await createNotification(
        recipientId: patientId,
        titleKey: "access_request_received",
        descriptionKey: "access_request_updated_desc",
        type: "access_request",
        patientId: patientId,
        doctorId: doctorId,
      );

      Fluttertoast.showToast(
        msg: "Access request updated",
        backgroundColor: Colors.green,
      );
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

  // -------------------------------
  void clearPatients() {
    patientList.clear();
    notifyListeners();
  }

  // ----------------- Add to Notification Collection --------------------
  Future<void> createNotification({
    required String recipientId,
    required String titleKey,
    String? descriptionKey,
    String? type,
    String? link,
    String? patientId,
    String? doctorId,
    Map<String, dynamic>? metadata,
  }) async {
    final collectionRef = FirebaseFirestore.instance
        .collection("notifications")
        .doc(recipientId)
        .collection("items");

    await collectionRef.add({
      "titleKey": titleKey,
      if (descriptionKey != null) "descriptionKey": descriptionKey,
      if (type != null) "type": type,
      if (link != null) "link": link,
      if (patientId != null) "patientId": patientId,
      if (doctorId != null) "doctorId": doctorId,
      if (metadata != null) "metadata": metadata,
      "status": "unread",
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }
}
