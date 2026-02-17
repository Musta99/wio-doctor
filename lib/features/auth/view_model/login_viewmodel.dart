import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wio_doctor/features/bottom_nav_bar/view/bottom_nav_bar.dart';

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

  Future login(String email, String password, BuildContext context) async {
    if (email.trim().isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        gravity: ToastGravity.CENTER,
        msg: "Please enter both email and password.",
        fontSize: 16,
      );
      return;
    }

    try {
      _setLoading(true);
      _setError(null);
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (cred.user!.uid == null) {
        throw Exception("User ID is null");
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("doctorId", cred.user!.uid);
      
      // Navigate to home screen if login successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomNavBar()),
      );

      Fluttertoast.showToast(
        msg: "Login successful",
        backgroundColor: Colors.green,
        gravity: ToastGravity.CENTER,
      );

      print("Login successful: ${cred.user?.uid}");
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        gravity: ToastGravity.CENTER,
        msg: _friendlyFirebaseError(e),
        fontSize: 16,
      );
    } catch (err) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        gravity: ToastGravity.CENTER,
        msg: "Something went wrong. Please try again.$err",
        fontSize: 16,
      );
      _setError("Something went wrong. Please try again.");
    } finally {
      _setLoading(false);
    }
  }
}
