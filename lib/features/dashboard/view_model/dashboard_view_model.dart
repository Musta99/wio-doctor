import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      final data = snapshot.data() as Map<String, dynamic>?;

      nidNumber = data!["nidNumber"];
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
      notifyListeners();


      print("Dashboard data fetched and name is: ${name}");
    } catch (err) {
    } finally {}
  }
}
