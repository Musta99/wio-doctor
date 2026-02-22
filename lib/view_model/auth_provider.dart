import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationProvider extends ChangeNotifier {
  String? _token;
  String? _userId;
  bool _isAuthenticated = false;

  String? get token => _token;
  String? get userId => _userId;
  bool get isAuthenticated => _isAuthenticated;

  // Initialize from Firebase Auth (NOT just SharedPreferences)
  Future<void> init() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // User is actually logged in - get fresh token
        _userId = user.uid;
        _token = await user.getIdToken();
        _isAuthenticated = true;

        // Update SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('user_id', _userId!);
        await prefs.setString('patientId', _userId!);

        debugPrint('✅ Auth initialized for user: $_userId');
      } else {
        // User is NOT logged in - clear everything
        await clearCredentials();
        debugPrint('ℹ️ No authenticated user found');
      }
    } catch (e) {
      debugPrint('❌ Error initializing auth: $e');
      await clearCredentials();
    }

    notifyListeners();
  }

  // Call after successful login
  Future<void> setCredentials({
    required String token,
    required String userId,
  }) async {
    _token = token;
    _userId = userId;
    _isAuthenticated = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_id', userId);
    await prefs.setString('patientId', userId);

    debugPrint('✅ Credentials saved for user: $userId');
    notifyListeners();
  }

  // Get fresh Firebase token
  Future<String?> getFreshToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _token = await user.getIdToken(true);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);

        return _token;
      } else {
        // User not logged in
        await clearCredentials();
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error getting fresh token: $e');
    }
    return null;
  }

  // Call on logout
  Future<void> clearCredentials() async {
    _token = null;
    _userId = null;
    _isAuthenticated = false;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_id');
      await prefs.remove('patientId');
      debugPrint('✅ All credentials cleared');
    } catch (e) {
      debugPrint('❌ Error clearing credentials: $e');
    }

    notifyListeners();
  }
}