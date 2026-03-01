import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';

class PatientAccessViewModel extends ChangeNotifier {
  // ----------------------- GET Metadata -------------------------
  Future<Map<String, dynamic>> _buildParticipantsMetadata({
    required FirebaseFirestore firestore,
    required String patientId,
    required String doctorId,
  }) async {
    // ✅ Use try/catch instead of .catchError()
    DocumentSnapshot? doctorSnap;
    DocumentSnapshot? patientSnap;

    try {
      doctorSnap = await firestore.collection("doctors").doc(doctorId).get();
    } catch (_) {}

    try {
      patientSnap = await firestore.collection("patients").doc(patientId).get();
    } catch (_) {}

    final doctorData =
        (doctorSnap?.exists == true)
            ? doctorSnap!.data() as Map<String, dynamic>
            : <String, dynamic>{};

    final patientData =
        (patientSnap?.exists == true)
            ? patientSnap!.data() as Map<String, dynamic>
            : <String, dynamic>{};

    final metadata = <String, dynamic>{};

    final doctorName = doctorData['name'] ?? doctorData['displayName'];
    final doctorEmail = doctorData['email'];
    final doctorPhoto =
        doctorData['photo'] ??
        doctorData['photoURL'] ??
        doctorData['avatarUrl'];
    final doctorSpecialty = doctorData['specialty'] ?? doctorData['title'];

    if (doctorName != null) metadata['doctorName'] = doctorName;
    if (doctorEmail != null) metadata['doctorEmail'] = doctorEmail;
    if (doctorPhoto != null) metadata['doctorPhotoURL'] = doctorPhoto;
    if (doctorSpecialty != null) metadata['doctorSpecialty'] = doctorSpecialty;

    final patientName = patientData['name'] ?? patientData['displayName'];
    final patientEmail = patientData['email'];
    final patientPhoto =
        patientData['photo'] ??
        patientData['photoURL'] ??
        patientData['avatarUrl'];

    if (patientName != null) metadata['patientName'] = patientName;
    if (patientEmail != null) metadata['patientEmail'] = patientEmail;
    if (patientPhoto != null) metadata['patientPhotoURL'] = patientPhoto;

    return metadata;
  }

  // ----------------------  SEND REQUEST -----------------------------------
  bool isSendingRequest = false;
  Future<void> sendAccessRequest(BuildContext context, String patientId) async {
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    String? doctorId = authProvider.userId;

    if (doctorId == null) throw Exception("User not authenticated");

    try {
      isSendingRequest = true;
      notifyListeners();

      final firestore = FirebaseFirestore.instance;
      final docId = "${patientId}_$doctorId";
      final docRef = firestore.collection("patientAccess").doc(docId);
      final snapshot = await docRef.get();
      final now = FieldValue.serverTimestamp();

      // ✅ Fetch metadata from both collections in parallel
      final metadata = await _buildParticipantsMetadata(
        firestore: firestore,
        patientId: patientId,
        doctorId: doctorId,
      );

      final doctorName = metadata['doctorName'] as String? ?? 'Doctor';

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
          ...metadata, // ✅ Spread metadata
        });

        await createNotification(
          recipientId: patientId,
          titleKey: "Access Request",
          descriptionKey: "DoctorAccessRequestDescription",
          type: "access_request",
          link: "/patient/my-doctor",
          patientId: patientId,
          doctorId: doctorId,
          metadata: {
            "name": doctorName,
            "doctorId": doctorId,
            "patientId": patientId,
          },
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
        ...metadata, // ✅ Spread metadata
      });

      await createNotification(
        recipientId: patientId,
        titleKey: "Access Request",
        descriptionKey: "DoctorAccessRequestDescription",
        type: "access_request",
        link: "/patient/my-doctor",
        patientId: patientId,
        doctorId: doctorId,
        metadata: {
          "name": doctorName,
          "doctorId": doctorId,
          "patientId": patientId,
        },
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

  Future findPatient(String email, BuildContext context) async {
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );

    String? doctorId = authProvider.userId;

    if (doctorId == null) {
      throw Exception("User not authenticated");
    }
    try {
      isPatientsListLoading = true;
      notifyListeners();

      final firestore = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot =
          await firestore
              .collection("patients")
              .where("email", isGreaterThanOrEqualTo: email)
              .where("email", isLessThanOrEqualTo: "$email\uf8ff")
              .get();

      // ✅ Use Future.wait with .get() NOT .snapshots()
      patientList = await Future.wait(
        querySnapshot.docs.map((doc) async {
          final patientId = doc.id;
          final patientData = doc.data() as Map<String, dynamic>;

          String? accessStatus;
          try {
            final accessDoc =
                await firestore
                    .collection("patientAccess")
                    .doc("${patientId}_$doctorId")
                    .get(); // ✅ .get() not .snapshots()

            if (accessDoc.exists) {
              accessStatus = accessDoc.data()?['status'] as String?;
            }
          } catch (_) {
            // doc doesn't exist yet = no request sent
          }

          return {
            "id": patientId,
            ...patientData,
            "accessStatus": accessStatus,
          };
        }).toList(),
      );
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
