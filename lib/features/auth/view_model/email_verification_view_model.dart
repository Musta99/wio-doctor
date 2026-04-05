import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationViewModel extends ChangeNotifier {
  bool isResending = false;
  bool isChecking = false;
  bool isVerified = false;

  Timer? _pollingTimer;

  void startPolling(VoidCallback onVerified) {
    _pollingTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        _pollingTimer?.cancel();
        isVerified = true;
        notifyListeners();
        onVerified();
      }
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
  }

  Future<String?> resendEmail() async {
    isResending = true;
    notifyListeners();
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      return null; // null = success
    } catch (e) {
      return "Failed to resend. Please try again.";
    } finally {
      isResending = false;
      notifyListeners();
    }
  }

  Future<bool> checkVerification() async {
    isChecking = true;
    notifyListeners();
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        isVerified = true;
        _pollingTimer?.cancel();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      isChecking = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}
