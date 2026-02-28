import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';

class CaseDiscussionViewModel extends ChangeNotifier {
  bool isLoadingCaseDiscussion = false;

  /// API response storage
  Map<String, dynamic>? caseDiscussionData;

  Future<void> initiateCaseDiscussion({
    required BuildContext context,
    required String caseTitle,
    required String caseSummary,
    String? caseImageDataUri,
    required List<Map<String, dynamic>> history,
    required String responseStyle, // "concise" or "elaborate"
  }) async {
    try {
      isLoadingCaseDiscussion = true;
      notifyListeners();

      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );

      String? token = await authProvider.getFreshToken();
      String? doctorId = authProvider.userId;

      if (doctorId == null || token == null) {
        throw Exception("User not authenticated");
      }

      final url = Uri.parse("https://www.wiocare.com/api/wio-discuss");

      /// Request body
      final body = {
        "caseTitle": caseTitle,
        "caseSummary": caseSummary,
        "caseImageDataUri": caseImageDataUri, // can be null
        "history": history, // [] if no previous messages
        "responseStyle": responseStyle, // "concise" or "elaborate"
      };

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // important
        },
        body: jsonEncode(body),
      );

      if (response.body.isEmpty) {
        throw Exception("Empty response from server");
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        caseDiscussionData = data["data"];
      } else {
        throw Exception(data["message"] ?? "Request failed");
      }
    } catch (err) {
      Fluttertoast.showToast(
        msg: "Error occurred: $err",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoadingCaseDiscussion = false;
      notifyListeners();
    }
  }
}
