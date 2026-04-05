import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmailVerificationViewModel extends ChangeNotifier {
  bool isResending = false;
  bool isChecking = false;
  bool isVerified = false;
  int resendCooldown = 0;

  Timer? _pollTimer;
  Timer? _cooldownTimer;

  VoidCallback? _onVerified;

  void init({required VoidCallback onVerified}) {
    _onVerified = onVerified;
    _startPolling();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      await checkVerification(silent: true);
    });
  }

  Future<void> checkVerification({bool silent = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (!silent) {
      isChecking = true;
      notifyListeners();
    }

    try {
      await user.reload();
      final refreshed = FirebaseAuth.instance.currentUser;

      if (refreshed != null && refreshed.emailVerified && !isVerified) {
        _pollTimer?.cancel();
        _cooldownTimer?.cancel();
        isVerified = true;
        notifyListeners();
        _onVerified?.call();
      }
    } catch (e) {
      debugPrint("Verification check error: $e");
    } finally {
      if (!silent) {
        isChecking = false;
        notifyListeners();
      }
    }
  }

  Future<void> resendEmail() async {
    if (resendCooldown > 0 || isResending) return;

    isResending = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      Fluttertoast.showToast(
        msg: "Verification email sent!",
        backgroundColor: const Color(0xFF00C896),
        gravity: ToastGravity.CENTER,
      );
      _startCooldown();
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg:
            e.code == 'too-many-requests'
                ? "Too many requests. Please wait a moment."
                : "Could not send email: ${e.message}",
        backgroundColor: const Color(0xFFFF4F6B),
        gravity: ToastGravity.CENTER,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Unexpected error: $e",
        backgroundColor: const Color(0xFFFF4F6B),
        gravity: ToastGravity.CENTER,
      );
    } finally {
      isResending = false;
      notifyListeners();
    }
  }

  void _startCooldown() {
    resendCooldown = 30;
    notifyListeners();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      resendCooldown--;
      if (resendCooldown <= 0) timer.cancel();
      notifyListeners();
    });
  }

  Future<void> signOut() async {
    _pollTimer?.cancel();
    _cooldownTimer?.cancel();
    await FirebaseAuth.instance.signOut();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }
}
