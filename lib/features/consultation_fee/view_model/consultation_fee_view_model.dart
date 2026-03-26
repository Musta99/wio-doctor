import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wio_doctor/shared/services/api_service.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';

class ConsultationFeeViewModel extends ChangeNotifier {
  bool isConsultationFeeFetchLoading = false;

  // Currency
  String currency = "BDT (৳)";

  // TextEditingControllers stored in ViewModel
  final Map<String, TextEditingController> feeControllers = {
    "60-Minute Consultation": TextEditingController(text: "0"),
    "30-Minute Consultation": TextEditingController(text: "0"),
    "Follow-up Consultation": TextEditingController(text: "0"),
    "Online Video Consultation": TextEditingController(text: "0"),
    "Home Visit": TextEditingController(text: "0"),
  };

  Future fetchConsultationFee(BuildContext context) async {
    try {
      isConsultationFeeFetchLoading = true;
      notifyListeners();

      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );

      String? token = await authProvider.getFreshToken();
      String? doctorId = authProvider.userId;

      if (doctorId == null || token == null) return;

      final response = await http.get(
        Uri.parse("${ApiServices.baseUrl}api/doctor/fees?doctorId=$doctorId"),
        headers: {"Authorization": "Bearer $token"},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final fees = data['fees'] ?? {};

        feeControllers['60-Minute Consultation']?.text =
            (fees['consultationFee'] ?? 0).toString();
        feeControllers['30-Minute Consultation']?.text =
            (fees['consultationFee30min'] ?? 0).toString();
        feeControllers['Follow-up Consultation']?.text =
            (fees['followUp']?['fee'] ?? 0).toString();
        feeControllers['Online Video Consultation']?.text =
            (fees['onlineVideoFee'] ?? 0).toString();
        feeControllers['Home Visit']?.text =
            (fees['homeVisitFee'] ?? 0).toString();

        currency = fees['currency'] != null ? "BDT (৳)" : currency;

        notifyListeners(); // Notify UI that controllers have updated
      }
    } catch (err) {
      Fluttertoast.showToast(
        msg: "Error occurred: $err",
        backgroundColor: Colors.red,
      );
    } finally {
      isConsultationFeeFetchLoading = false;
      notifyListeners();
    }
  }

  // ---------------- Update Consultation fee details --------------------
  bool isConsultationFeeUpdating = false;
  Future updateConsultationFee(BuildContext context) async {
    try {
      isConsultationFeeUpdating = true;
      notifyListeners();

      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );

      String? token = await authProvider.getFreshToken();
      String? doctorId = authProvider.userId;
      if (doctorId == null || token == null) return;

      // Build payload from controllers
      final Map<String, dynamic> updatedData = {
        "consultationFee":
            int.tryParse(feeControllers['60-Minute Consultation']!.text) ?? 0,
        "consultationFee30min":
            int.tryParse(feeControllers['30-Minute Consultation']!.text) ?? 0,
        "followUp": {
          "fee": feeControllers['Follow-up Consultation']!.text,
          "window": "Within 7 days",
        },
        "onlineVideoFee":
            int.tryParse(feeControllers['Online Video Consultation']!.text) ??
            0,
        "homeVisitFee": int.tryParse(feeControllers['Home Visit']!.text) ?? 0,
        "currency": currency,
      };

      final response = await http.put(
        Uri.parse("${ApiServices.baseUrl}api/doctor/fees?doctorId=$doctorId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(updatedData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        Fluttertoast.showToast(msg: "Consultation fees updated successfully");
        notifyListeners();
      } else {
        Fluttertoast.showToast(msg: "Failed to update fees");
        print("Response: $data");
      }
    } catch (err) {
      Fluttertoast.showToast(
        msg: "Error occurred: $err",
        backgroundColor: Colors.red,
      );
    } finally {
      isConsultationFeeUpdating = false;
      notifyListeners();
    }
  }
}
