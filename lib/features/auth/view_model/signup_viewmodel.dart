import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SignupViewModel extends ChangeNotifier {
  bool isSignupLoading = false;

  Future doctorSignUp(String email, String password, String name) async {
    isSignupLoading = true;
    notifyListeners();

    try {
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user.user!.uid == null) {
        throw Exception("User ID is null");
      } else {
        final String signUpEndPoint = "https://wiocare.com/api/auth/signup";
        final response = await http.post(
          Uri.parse(signUpEndPoint),
          body: {
            "uid": user.user!.uid,
            "email": email,
            "name": name,
            "role": "doctor",
            "termsAccepted": true,
          },
        );

        if (response.statusCode == 200) {
          Fluttertoast.showToast(
            backgroundColor: Colors.green,
            gravity: ToastGravity.CENTER,
            msg: "Your account has been created successfully",
            fontSize: 16,
          );
        } else {
          throw Exception("Failed to create account. Please try again.");
        }
      }
    } catch (err) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        gravity: ToastGravity.CENTER,
        msg:
            err.toString().contains("email-already-in-use")
                ? "The email address is already in use by another account."
                : err.toString().contains("weak-password")
                ? "The password provided is too weak."
                : email.toString().contains("invalid-email")
                ? "The email address is badly formatted."
                : "An error occurred. Please try again.",
        fontSize: 16,
      );
    } finally {
      isSignupLoading = false;
      notifyListeners();
    }
  }
}
