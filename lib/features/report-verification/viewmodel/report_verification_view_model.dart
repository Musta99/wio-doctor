import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:wio_doctor/model/report_verification_models.dart';
import 'package:wio_doctor/shared/services/api_service.dart';

class ReportVerificationViewModel extends ChangeNotifier {
  // Loading states
  bool isLoadingQueue = false;
  bool isLoadingDetail = false;
  bool isClaiming = false;
  bool isVerifying = false;

  // Data
  List<VerifierQueueItem> queueItems = [];
  VerificationDetail? selectedDetail;
  String? selectedVerificationId;

  // Pagination
  int currentPage = 1;
  int itemsPerPage = 10;

  // UI state
  String commentsText = "";
  String? selectedOutcome; // "verified" or "needs_followup"
  String? errorMessage;

  // Computed properties
  int get openCount => queueItems.where((item) => item.isOpen).length;
  int get claimedByMeCount =>
      queueItems
          .where(
            (item) => item.isClaimed && item.verifierId == _currentVerifierId,
          )
          .length;
  int get verifiedByMeCount =>
      queueItems
          .where(
            (item) => item.isVerified && item.verifierId == _currentVerifierId,
          )
          .length;

  String? _currentVerifierId;

  Future<void> loadQueue() async {
    isLoadingQueue = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = await _getAuthToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse("${ApiServices.baseUrl}api/doctor/report-verification"),
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("📥 Queue Response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          queueItems =
              (data['items'] as List)
                  .map((item) => VerifierQueueItem.fromJson(item))
                  .toList();

          debugPrint("✅ Queue loaded: ${queueItems.length} items");
          notifyListeners();
        } else {
          throw Exception(data['error'] ?? 'Failed to load queue');
        }
      } else if (response.statusCode == 403) {
        errorMessage = "Report verifier access required.";
        debugPrint("❌ Access denied: Not a report verifier");
      } else {
        throw Exception(
          'Failed to load verification queue (${response.statusCode})',
        );
      }
    } catch (err) {
      debugPrint("❌ Error loading queue: $err");
      errorMessage = err.toString();
      Fluttertoast.showToast(
        msg: "Failed to load verification queue",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoadingQueue = false;
      notifyListeners();
    }
  }

  Future<void> openDetail(String verificationId) async {
    selectedVerificationId = verificationId;
    selectedDetail = null;
    commentsText = "";
    selectedOutcome = null;
    isLoadingDetail = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = await _getAuthToken();
      if (token == null) return;

      final encodedId = Uri.encodeComponent(verificationId);
      final response = await http.get(
        Uri.parse(
          "${ApiServices.baseUrl}api/doctor/report-verification/$encodedId",
        ),
        headers: {"Authorization": "Bearer $token"},
      );

      debugPrint("📥 Detail Response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          selectedDetail = VerificationDetail.fromJson(data['data']);

          // Pre-fill comments if already verified
          if (selectedDetail?.comments != null) {
            commentsText = selectedDetail!.comments!;
          }

          debugPrint("✅ Detail loaded for: $verificationId");
          notifyListeners();
        } else {
          throw Exception(data['error'] ?? 'Failed to load verification');
        }
      } else if (response.statusCode == 404) {
        errorMessage = "Verification request not found.";
      } else {
        throw Exception('Failed to load verification (${response.statusCode})');
      }
    } catch (err) {
      debugPrint("❌ Error loading detail: $err");
      errorMessage = err.toString();
      Fluttertoast.showToast(
        msg: "Failed to load verification details",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<void> claimVerification() async {
    if (selectedVerificationId == null) return;

    isClaiming = true;
    notifyListeners();

    try {
      final token = await _getAuthToken();
      if (token == null) return;

      final encodedId = Uri.encodeComponent(selectedVerificationId!);
      final response = await http.post(
        Uri.parse(
          "${ApiServices.baseUrl}api/doctor/report-verification/$encodedId/claim",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({}),
      );

      debugPrint("📥 Claim Response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          Fluttertoast.showToast(
            msg: "Verification claimed successfully",
            backgroundColor: Colors.green,
          );

          // Reload queue and detail
          await loadQueue();
          if (selectedVerificationId != null) {
            await openDetail(selectedVerificationId!);
          }

          debugPrint("✅ Verification claimed");
        } else {
          throw Exception(data['error'] ?? 'Failed to claim verification');
        }
      } else if (response.statusCode == 409) {
        errorMessage = "This request has already been claimed.";
        Fluttertoast.showToast(
          msg: "Already claimed by another verifier",
          backgroundColor: Colors.orange,
        );
        // Reload queue to show updated state
        await loadQueue();
      } else {
        throw Exception(
          'Failed to claim verification (${response.statusCode})',
        );
      }
    } catch (err) {
      debugPrint("❌ Error claiming verification: $err");
      Fluttertoast.showToast(
        msg: "Failed to claim verification",
        backgroundColor: Colors.red,
      );
    } finally {
      isClaiming = false;
      notifyListeners();
    }
  }

  Future<void> submitVerification() async {
    if (selectedVerificationId == null || selectedOutcome == null) {
      Fluttertoast.showToast(
        msg: "Please select an outcome",
        backgroundColor: Colors.orange,
      );
      return;
    }

    isVerifying = true;
    notifyListeners();

    try {
      final token = await _getAuthToken();
      if (token == null) return;

      final encodedId = Uri.encodeComponent(selectedVerificationId!);
      final payload = {
        'outcome': selectedOutcome,
        if (commentsText.isNotEmpty) 'comments': commentsText.trim(),
      };

      debugPrint("📤 Submitting verification: ${jsonEncode(payload)}");

      final response = await http.post(
        Uri.parse(
          "${ApiServices.baseUrl}api/doctor/report-verification/$encodedId/verify",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      debugPrint("📥 Submit Response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          Fluttertoast.showToast(
            msg: "Report verified successfully",
            backgroundColor: Colors.green,
          );

          // Close detail view
          selectedVerificationId = null;
          selectedDetail = null;
          commentsText = "";
          selectedOutcome = null;

          // Reload queue
          await loadQueue();

          debugPrint("✅ Verification submitted");
        } else {
          throw Exception(data['error'] ?? 'Failed to submit verification');
        }
      } else if (response.statusCode == 404) {
        errorMessage = "Verification request not found.";
      } else {
        throw Exception(
          'Failed to submit verification (${response.statusCode})',
        );
      }
    } catch (err) {
      debugPrint("❌ Error submitting verification: $err");
      Fluttertoast.showToast(
        msg: "Failed to submit verification",
        backgroundColor: Colors.red,
      );
    } finally {
      isVerifying = false;
      notifyListeners();
    }
  }

  void updateComments(String value) {
    commentsText = value;
    notifyListeners();
  }

  void setOutcome(String outcome) {
    selectedOutcome = outcome;
    notifyListeners();
  }

  void closeDetail() {
    selectedVerificationId = null;
    selectedDetail = null;
    commentsText = "";
    selectedOutcome = null;
    errorMessage = null;
    notifyListeners();
  }

  Future<String?> _getAuthToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        errorMessage = "User not authenticated";
        return null;
      }
      _currentVerifierId = user.uid;
      return await user.getIdToken();
    } catch (e) {
      debugPrint("❌ Failed to get auth token: $e");
      errorMessage = "Authentication failed";
      return null;
    }
  }

  Map<String, dynamic>? dashboardSummary;
}
