// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:wio_doctor/shared/services/api_service.dart';
// import 'package:wio_doctor/view_model/auth_provider.dart';

// class ConsultationFeeViewModel extends ChangeNotifier {
//   bool isConsultationFeeFetchLoading = false;

//   // Currency
//   String currency = "BDT (৳)";

//   // TextEditingControllers stored in ViewModel
//   final Map<String, TextEditingController> feeControllers = {
//     "60-Minute Consultation": TextEditingController(text: "0"),
//     "30-Minute Consultation": TextEditingController(text: "0"),
//     "Follow-up Consultation": TextEditingController(text: "0"),
//     "Online Video Consultation": TextEditingController(text: "0"),
//     "Home Visit": TextEditingController(text: "0"),
//   };

//   Future fetchConsultationFee(BuildContext context) async {
//     try {
//       isConsultationFeeFetchLoading = true;
//       notifyListeners();

//       final authProvider = Provider.of<AuthenticationProvider>(
//         context,
//         listen: false,
//       );

//       String? token = await authProvider.getFreshToken();
//       String? doctorId = authProvider.userId;

//       if (doctorId == null || token == null) return;

//       final response = await http.get(
//         Uri.parse("${ApiServices.baseUrl}api/doctor/fees?doctorId=$doctorId"),
//         headers: {"Authorization": "Bearer $token"},
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data['success'] == true) {
//         final fees = data['fees'] ?? {};

//         feeControllers['60-Minute Consultation']?.text =
//             (fees['consultationFee'] ?? 0).toString();
//         feeControllers['30-Minute Consultation']?.text =
//             (fees['consultationFee30min'] ?? 0).toString();
//         feeControllers['Follow-up Consultation']?.text =
//             (fees['followUp']?['fee'] ?? 0).toString();
//         feeControllers['Online Video Consultation']?.text =
//             (fees['onlineVideoFee'] ?? 0).toString();
//         feeControllers['Home Visit']?.text =
//             (fees['homeVisitFee'] ?? 0).toString();

//         currency = fees['currency'] != null ? "BDT (৳)" : currency;

//         notifyListeners(); // Notify UI that controllers have updated
//       }
//     } catch (err) {
//       Fluttertoast.showToast(
//         msg: "Error occurred: $err",
//         backgroundColor: Colors.red,
//       );
//     } finally {
//       isConsultationFeeFetchLoading = false;
//       notifyListeners();
//     }
//   }

//   // ---------------- Update Consultation fee details --------------------
//   bool isConsultationFeeUpdating = false;
//   Future updateConsultationFee(BuildContext context) async {
//     try {
//       isConsultationFeeUpdating = true;
//       notifyListeners();

//       final authProvider = Provider.of<AuthenticationProvider>(
//         context,
//         listen: false,
//       );

//       String? token = await authProvider.getFreshToken();
//       String? doctorId = authProvider.userId;
//       if (doctorId == null || token == null) return;

//       // Build payload from controllers
//       final Map<String, dynamic> updatedData = {
//         "consultationFee":
//             int.tryParse(feeControllers['60-Minute Consultation']!.text) ?? 0,
//         "consultationFee30min":
//             int.tryParse(feeControllers['30-Minute Consultation']!.text) ?? 0,
//         "followUp": {
//           "fee": feeControllers['Follow-up Consultation']!.text,
//           "window": "Within 7 days",
//         },
//         "onlineVideoFee":
//             int.tryParse(feeControllers['Online Video Consultation']!.text) ??
//             0,
//         "homeVisitFee": int.tryParse(feeControllers['Home Visit']!.text) ?? 0,
//         "currency": currency,
//       };

//       final response = await http.put(
//         Uri.parse("${ApiServices.baseUrl}api/doctor/fees?doctorId=$doctorId"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode(updatedData),
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data['success'] == true) {
//         Fluttertoast.showToast(msg: "Consultation fees updated successfully");
//         notifyListeners();
//       } else {
//         Fluttertoast.showToast(msg: "Failed to update fees");
//         print("Response: $data");
//       }
//     } catch (err) {
//       Fluttertoast.showToast(
//         msg: "Error occurred: $err",
//         backgroundColor: Colors.red,
//       );
//     } finally {
//       isConsultationFeeUpdating = false;
//       notifyListeners();
//     }
//   }
// }

//  ----------------------------- 222222222222222222222222 ------------------------------
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wio_doctor/shared/services/api_service.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';

class ConsultationFeeViewModel extends ChangeNotifier {
  bool isConsultationFeeFetchLoading = false;
  bool isConsultationFeeUpdating = false;

  // Currency (matches web: ৳, ₹, $)
  String currency = "৳";

  // TextEditingControllers (matching web fee structure)
  final Map<String, TextEditingController> feeControllers = {
    "consultation60min": TextEditingController(text: "0"),
    "consultation30min": TextEditingController(text: "0"),
    "followUp": TextEditingController(text: "0"),
  };

  void setCurrency(String newCurrency) {
    currency = newCurrency;
    notifyListeners();
  }

  Future<void> fetchConsultationFee(BuildContext context) async {
    try {
      isConsultationFeeFetchLoading = true;
      notifyListeners();

      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );

      String? token = await authProvider.getFreshToken();
      String? doctorId = authProvider.userId;

      if (doctorId == null || token == null) {
        debugPrint("❌ DoctorId or token missing");
        return;
      }

      final response = await http.get(
        Uri.parse("${ApiServices.baseUrl}api/doctor/fees?doctorId=$doctorId"),
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("📥 Fees Response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['fees'] != null) {
          final fees = data['fees'] as Map<String, dynamic>;

          // Update controllers with fetched data
          feeControllers['consultation60min']?.text =
              (fees['consultationFee'] ?? 0).toString();
          feeControllers['consultation30min']?.text =
              (fees['consultationFee30min'] ?? 0).toString();

          // Handle followUp nested structure
          final followUp = fees['followUp'];
          if (followUp is Map) {
            feeControllers['followUp']?.text =
                (followUp['fee'] ?? 0).toString();
          } else {
            feeControllers['followUp']?.text = "0";
          }

          // Update currency
          currency = fees['currency'] ?? "৳";

          notifyListeners();
          debugPrint("✅ Fees loaded successfully");
        }
      } else {
        debugPrint("❌ Failed to fetch fees: ${response.statusCode}");
      }
    } catch (err) {
      debugPrint("❌ Error fetching fees: $err");
      Fluttertoast.showToast(
        msg: "Failed to load fees",
        backgroundColor: Colors.red,
      );
    } finally {
      isConsultationFeeFetchLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateConsultationFee(BuildContext context) async {
    try {
      isConsultationFeeUpdating = true;
      notifyListeners();

      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );

      String? token = await authProvider.getFreshToken();
      String? doctorId = authProvider.userId;

      if (doctorId == null || token == null) {
        Fluttertoast.showToast(msg: "Authentication required");
        return;
      }

      // Build payload matching web structure
      final Map<String, dynamic> payload = {
        "currency": currency,
        "consultationFee":
            int.tryParse(feeControllers['consultation60min']!.text) ?? 0,
        "consultationFee30min":
            int.tryParse(feeControllers['consultation30min']!.text) ?? 0,
        "followUp": {
          "fee": int.tryParse(feeControllers['followUp']!.text) ?? 0,
          "window": "Within 7 days",
        },
      };

      debugPrint("📤 Updating fees: ${jsonEncode(payload)}");

      final response = await http.put(
        Uri.parse("${ApiServices.baseUrl}api/doctor/fees?doctorId=$doctorId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      debugPrint("📥 Update Response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          Fluttertoast.showToast(
            msg: "Consultation fees updated successfully",
            backgroundColor: Colors.green,
          );
          notifyListeners();
        } else {
          throw Exception(data['error'] ?? 'Update failed');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to update fees');
      }
    } catch (err) {
      debugPrint("❌ Error updating fees: $err");
      Fluttertoast.showToast(
        msg: "Failed to update fees: $err",
        backgroundColor: Colors.red,
      );
    } finally {
      isConsultationFeeUpdating = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    for (var controller in feeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
