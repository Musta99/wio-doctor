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
