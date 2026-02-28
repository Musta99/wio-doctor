import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';

class CaseDiscussionViewModel extends ChangeNotifier {
  /// ===== Controllers =====
  final caseTitleC = TextEditingController();
  final caseSummaryC = TextEditingController();
  final questionC = TextEditingController();

  /// ===== UI State =====
  bool isLoadingCaseDiscussion = false;
  String responseType = "concise";

  File? selectedImage;
  String? imageBase64;

  Map<String, dynamic>? caseDiscussionData;
  List discussionList = [];

  /// ===== Change response style =====
  void setResponseType(String value) {
    responseType = value == "Short Notes" ? "concise" : "elaborate";
    notifyListeners();
  }

  /// ===== Pick Image =====
  Future<void> pickImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    selectedImage = File(picked.path);

    final bytes = await selectedImage!.readAsBytes();
    imageBase64 = base64Encode(bytes);

    notifyListeners();
  }

  /// ===== Remove Image =====
  void removeImage() {
    selectedImage = null;
    imageBase64 = null;
    notifyListeners();
  }

  /// ===== Submit Case =====
  Future<void> initiateCaseDiscussion(BuildContext context) async {
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

      final body = {
        "caseTitle": caseTitleC.text.trim(),
        "caseSummary": "${caseSummaryC.text}\n\nQuestion: ${questionC.text}",
        "caseImageDataUri":
            imageBase64 != null ? "data:image/png;base64,$imageBase64" : null,
        "history": [],
        "responseStyle": responseType,
      };

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (response.body.isEmpty) {
        throw Exception("Empty response");
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        caseDiscussionData = data["data"];
        discussionList = caseDiscussionData?["discussion"] ?? [];
        print(caseDiscussionData);

        _clearForm();

        Fluttertoast.showToast(msg: "Case submitted successfully");
      } else {
        throw Exception(data["message"]);
      }
    } catch (err) {
      Fluttertoast.showToast(msg: "Error: $err", backgroundColor: Colors.red);
    } finally {
      isLoadingCaseDiscussion = false;
      notifyListeners();
    }
  }

  /// ===== Clear Form =====
  void _clearForm() {
    caseTitleC.clear();
    caseSummaryC.clear();
    questionC.clear();
    selectedImage = null;
    imageBase64 = null;
  }

  @override
  void dispose() {
    caseTitleC.dispose();
    caseSummaryC.dispose();
    questionC.dispose();
    super.dispose();
  }
}
