import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';

class ConsultationFeeViewModel extends ChangeNotifier {
  // ------------------- Fetch Consultation Fee data ------------------------
  bool isConsultationFeeFetchLoading = false;
  Future fetchConsultationFee(BuildContext context) async {
    try {
      isConsultationFeeFetchLoading = true;
      notifyListeners();

      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );

      // Always request fresh token
      String? token = await authProvider.getFreshToken();
      String? doctorId = authProvider.userId; // or however you store doctorId
      if (doctorId == null || token == null) {
        print("DoctorId or token missing");
        return;
      }
      if (doctorId == null || token == null) {
        return;
      }

      final consultationFeeFetchRoute =
          "https://www.wiocare.com/api/doctor/fees?doctorId=${doctorId}";

      final response = await http.get(
        Uri.parse(consultationFeeFetchRoute),
        headers: {"Authorization": "Bearer $token"},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("Data: $data");
      } else {
        print(response.statusCode);
        print(response.body);
      }
    } catch (err) {
      print(err.toString());
      Fluttertoast.showToast(
        msg: "Error occured: $err",
        backgroundColor: Colors.red,
      );
    } finally {
      isConsultationFeeFetchLoading = false;
      notifyListeners();
    }
  }
}
