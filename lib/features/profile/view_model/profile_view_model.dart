import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final bioC = TextEditingController();
  final yearsExpC = TextEditingController();
  final hospitalNameC = TextEditingController();
  final nidC = TextEditingController();

  /// store original values for comparison
  Map<String, String> _originalValues = {};

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

      /// populate controllers
      fullNameC.text = data["name"] ?? "";
      emailC.text = data["email"] ?? "";
      genderC.text = data["gender"] ?? "";
      mobileC.text = data["mobile"] ?? "";
      clinicAddressC.text = data["clinicAddress"] ?? "";
      bioC.text = data["bio"] ?? "";
      yearsExpC.text = data["experience"] ?? "";
      hospitalNameC.text = data["hospital"] ?? "";
      nidC.text = data["nidNumber"] ?? "";

      /// save original snapshot
      _originalValues = {
        "name": fullNameC.text,
        "email": emailC.text,
        "gender": genderC.text,
        "mobile": mobileC.text,
        "clinicAddress": clinicAddressC.text,
        "bio": bioC.text,
        "experience": yearsExpC.text,
        "hospital": hospitalNameC.text,
        "nid": nidC.text,
      };

      /// listen changes
      _listenFormChanges();

      hasDoctorData = true;
    } catch (e) {
      hasDoctorData = false;
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
      bioC,
      yearsExpC,
      hospitalNameC,
      nidC,
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
        bioC.text != _originalValues["bio"] ||
        yearsExpC.text != _originalValues["experience"] ||
        hospitalNameC.text != _originalValues["hospital"] ||
        nidC.text != _originalValues["nid"];

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
      "bio": bioC.text,
      "experience": yearsExpC.text,
      "hospital": hospitalNameC.text,
      "nid": nidC.text,
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
}
