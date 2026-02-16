import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginViewmodel extends ChangeNotifier {
  bool isLoginLoading = false;
  String? errorMessage;

  void _setLoading(bool value) {
    isLoginLoading = value;
    notifyListeners();
  }

  void _setError(String? msg) {
    errorMessage = msg;
    notifyListeners();
  }

  String _friendlyFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case "user-not-found":
        return "No account found with this email.";
      case "wrong-password":
      case "invalid-credential":
        return "Invalid email or password.";
      case "invalid-email":
        return "Invalid email address.";
      case "user-disabled":
        return "This account is disabled.";
      case "too-many-requests":
        return "Too many attempts. Try again later.";
      default:
        return "Login failed. Please try again.";
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return true; // ✅ success
    } on FirebaseAuthException catch (e) {
      _setError(_friendlyFirebaseError(e));
      return false;
    } catch (_) {
      _setError("Something went wrong. Please try again.");
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
