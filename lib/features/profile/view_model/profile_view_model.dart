import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wio_doctor/features/auth/view/login_screen.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';

class ProfileViewModel extends ChangeNotifier {
  /// ---------------- STATES ----------------
  bool isLoadingDoctor = false;
  bool hasDoctorData = false;
  bool isProfileChanged = false;

  /// ---------------- CONTROLLERS ----------------
  /// Keep form state inside ViewModel (best practice)
  final fullNameC = TextEditingController();
  final emailC = TextEditingController();
  final genderC = TextEditingController();
  final mobileC = TextEditingController();
  final clinicAddressC = TextEditingController();
  final clinicNameC = TextEditingController();
  final bioC = TextEditingController();
  final yearsExpC = TextEditingController();
  final hospitalNameC = TextEditingController();
  final nidC = TextEditingController();
  final specialityC = TextEditingController();
  final regAuthorityC = TextEditingController();
  final regNumberC = TextEditingController();
  final educationDegreeC = TextEditingController();
  String photo = "";
  String? wioId;

  /// store original values for comparison
  Map<String, String> _originalValues = {};

  String _safe(dynamic value) {
    if (value == null) return "";
    if (value.toString().toLowerCase() == "null") return "";
    return value.toString();
  }

  /// ---------------- FETCH DOCTOR ----------------

  Future fetchDoctorData() async {
    try {
      isLoadingDoctor = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      String? doctorId = prefs.getString("doctorId");

      if (doctorId == null) {
        hasDoctorData = false;
        return;
      }

      final snapshot =
          await FirebaseFirestore.instance
              .collection("doctors")
              .doc(doctorId)
              .get();

      final data = snapshot.data();

      if (data == null) {
        hasDoctorData = false;
        return;
      }

      /// populate controllers safely
      fullNameC.text = _safe(data["name"]);
      emailC.text = _safe(data["email"]);
      genderC.text = _safe(data["gender"]);
      mobileC.text = _safe(data["mobile"]);
      clinicAddressC.text = _safe(data["clinicAddress"]);
      clinicNameC.text = _safe(data["worksAt"]?["name"]);
      bioC.text = _safe(data["bio"]);
      yearsExpC.text = _safe(data["experienceYears"]);
      hospitalNameC.text = _safe(data["hospital"]);

      // Nested fields
      nidC.text = _safe(data["nidNumber"]);
      specialityC.text = _safe(data["specialty"]?["name"]);
      regAuthorityC.text = _safe(data["registration"]?["authority"]);
      regNumberC.text = _safe(data["registration"]?["number"]);
      educationDegreeC.text = _safe(data["educationDegree"]);
      photo = data["photo"];
      wioId = data["wioId"];
      notifyListeners();

      // Save original snapshot for change tracking
      _originalValues = {
        "name": fullNameC.text,
        "email": emailC.text,
        "gender": genderC.text,
        "mobile": mobileC.text,
        "clinicAddress": clinicAddressC.text,
        "clinicName": clinicNameC.text,
        "bio": bioC.text,
        "experience": yearsExpC.text,
        "hospital": hospitalNameC.text,
        "nid": nidC.text,
        "specialty": specialityC.text,
        "regAuthority": regAuthorityC.text,
        "regNumber": regNumberC.text,
        "educationDegree": educationDegreeC.text,
      };

      _listenFormChanges();
      hasDoctorData = true;
    } catch (e) {
      hasDoctorData = false;
      print("Error fetching doctor data: $e");
    } finally {
      isLoadingDoctor = false;
      notifyListeners();
    }
  }

  /// ---------------- CHANGE TRACKING ----------------

  void _listenFormChanges() {
    final controllers = [
      fullNameC,
      emailC,
      genderC,
      mobileC,
      clinicAddressC,
      clinicNameC,
      bioC,
      yearsExpC,
      hospitalNameC,
      nidC,
      specialityC,
      regAuthorityC,
      regNumberC,
      educationDegreeC,
    ];

    for (var c in controllers) {
      c.addListener(_checkIfChanged);
    }
  }

  void _checkIfChanged() {
    final changed =
        fullNameC.text != _originalValues["name"] ||
        emailC.text != _originalValues["email"] ||
        genderC.text != _originalValues["gender"] ||
        mobileC.text != _originalValues["mobile"] ||
        clinicAddressC.text != _originalValues["clinicAddress"] ||
        clinicNameC.text != _originalValues["clinicName"] ||
        bioC.text != _originalValues["bio"] ||
        yearsExpC.text != _originalValues["experience"] ||
        hospitalNameC.text != _originalValues["hospital"] ||
        nidC.text != _originalValues["nid"] ||
        specialityC.text != _originalValues["specialty"] ||
        regAuthorityC.text != _originalValues["regAuthority"] ||
        regNumberC.text != _originalValues["regNumber"] ||
        educationDegreeC.text != _originalValues["educationDegree"];

    if (changed != isProfileChanged) {
      isProfileChanged = changed;
      notifyListeners();
    }
  }

  /// ---------------- RESET CHANGE STATE AFTER SAVE ----------------

  void markSaved() {
    _originalValues = {
      "name": fullNameC.text,
      "email": emailC.text,
      "gender": genderC.text,
      "mobile": mobileC.text,
      "clinicAddress": clinicAddressC.text,
      "clinicName": clinicNameC.text,
      "bio": bioC.text,
      "experience": yearsExpC.text,
      "hospital": hospitalNameC.text,
      "nid": nidC.text,
      "specialty": specialityC.text,
      "regAuthority": regAuthorityC.text,
      "regNumber": regNumberC.text,
      "educationDegree": educationDegreeC.text,
    };

    isProfileChanged = false;
    notifyListeners();
  }

  /// dispose controllers
  @override
  void dispose() {
    fullNameC.dispose();
    emailC.dispose();
    genderC.dispose();
    mobileC.dispose();
    clinicAddressC.dispose();
    bioC.dispose();
    yearsExpC.dispose();
    hospitalNameC.dispose();
    nidC.dispose();
    super.dispose();
  }

  // ----------------- Profile picture update ------------------
  bool isUploadingPhoto = false;
  Future pickAndUploadProfileImage(BuildContext context) async {
    try {
      final picker = ImagePicker();

      /// Pick image
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (picked == null) return;

      isUploadingPhoto = true;
      notifyListeners();

      final file = File(picked.path);

      /// Get Firebase UID (userId)
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString("doctorId");
      // OR use FirebaseAuth.instance.currentUser?.uid
      // Use whichever stores Firebase UID in your app

      if (userId == null || userId.isEmpty) {
        print("UserId missing");
        return;
      }

      /// Create multipart request
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("https://www.wiocare.com/api/upload-profile-image"),
      );

      /// If your API requires token
      try {
        final authProvider = context.read<AuthenticationProvider>();
        final token = await authProvider.getFreshToken();

        if (token != null) {
          request.headers["Authorization"] = "Bearer $token";
        }
      } catch (_) {}

      /// Required body fields
      request.fields["userId"] = userId; // ✅ REQUIRED
      request.files.add(
        await http.MultipartFile.fromPath(
          "file", // backend field name
          file.path,
        ),
      );

      /// Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Upload status: ${response.statusCode}");
      print("Upload response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        /// Backend should return image URL
        final imageUrl = data["url"] ?? data["photoUrl"] ?? "";

        print("----------- $imageUrl");

        if (imageUrl.isNotEmpty) {
          photo = imageUrl; // update provider state
          notifyListeners();

          // -------- save to firebase firestore -------------
          await FirebaseFirestore.instance
              .collection("doctors")
              .doc(userId)
              .update({"photo": imageUrl});

          Fluttertoast.showToast(
            msg: "Successfully updated profile picture",
            backgroundColor: Colors.green,
          );
        }
      } else {
        print("Upload failed: ${response.body}");
      }
    } catch (err) {
      Fluttertoast.showToast(
        msg: "Error occured: $err",
        backgroundColor: Colors.red,
      );
      print("Upload error: $err");
    } finally {
      isUploadingPhoto = false;
      notifyListeners();
    }
  }

  // --------------------- Update Profile data -----------------------
  bool isUpdatingData = false;
  Future updateProfileData() async {
    try {
      /// Prevent unnecessary update
      if (!isProfileChanged) return;

      isUpdatingData = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString("doctorId");

      if (userId == null || userId.isEmpty) {
        Fluttertoast.showToast(msg: "User not found");
        return;
      }

      /// Detect only changed fields
      Map<String, dynamic> updateData = {};

      if (fullNameC.text != _originalValues["name"]) {
        updateData["name"] = fullNameC.text.trim();
      }

      // if (emailC.text != _originalValues["email"]) {
      //   updateData["email"] = emailC.text.trim();
      // }

      if (genderC.text != _originalValues["gender"]) {
        updateData["gender"] = genderC.text.trim();
      }

      if (mobileC.text != _originalValues["mobile"]) {
        updateData["mobile"] = mobileC.text.trim();
      }

      if (clinicAddressC.text != _originalValues["clinicAddress"]) {
        updateData["clinicAddress"] = clinicAddressC.text.trim();
      }

      if (bioC.text != _originalValues["bio"]) {
        updateData["bio"] = bioC.text.trim();
      }

      if (yearsExpC.text != _originalValues["experience"]) {
        updateData["experienceYears"] = yearsExpC.text.trim();
      }

      if (hospitalNameC.text != _originalValues["hospital"]) {
        updateData["hospital"] = hospitalNameC.text.trim();
      }

      if (nidC.text != _originalValues["nid"]) {
        updateData["nidNumber"] = nidC.text.trim();
      }

      /// If nothing changed → stop
      if (updateData.isEmpty) return;

      /// Update firestore
      await FirebaseFirestore.instance
          .collection("doctors")
          .doc(userId)
          .update(updateData);

      Fluttertoast.showToast(
        msg: "Profile updated successfully",
        backgroundColor: Colors.green,
      );

      /// Reset change tracking
      markSaved();
    } catch (err) {
      Fluttertoast.showToast(
        msg: "Update failed: $err",
        backgroundColor: Colors.red,
      );
    } finally {
      isUpdatingData = false;
      notifyListeners();
    }
  }

  // -------------------- Logout function -------------------
  bool isLogoutLoading = false;
  Future userLogout(BuildContext context) async {
    try {
      isLogoutLoading = true;
      notifyListeners();
      await FirebaseAuth.instance.signOut();

      await context.read<AuthenticationProvider>().clearCredentials();

      // Remove all screens and go to login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false, // removes all previous routes
      );
    } catch (err) {
      Fluttertoast.showToast(
        msg: "Error occured: $err",
        backgroundColor: Colors.red,
      );
    } finally {
      isLogoutLoading = false;
      notifyListeners();
    }
  }
}
