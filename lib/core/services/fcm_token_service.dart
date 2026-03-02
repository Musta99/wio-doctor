// lib/services/fcm_token_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class FCMTokenService {
  static final FCMTokenService _instance = FCMTokenService._();
  static FCMTokenService get instance => _instance;

  FCMTokenService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Initialize FCM and register token
  Future<void> initialize() async {
    // Request permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
    );

    print('📱 FCM Permission: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      await _registerToken();

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        print('🔄 FCM Token refreshed');
        _saveTokenToFirestore(newToken);
      });
    }
  }

  Future<void> _registerToken() async {
    try {
      String? token;

      if (Platform.isIOS) {
        // For iOS, get APNS token first
        String? apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null) {
          token = await _messaging.getToken();
        }
      } else {
        token = await _messaging.getToken();
      }

      if (token != null) {
        print('📲 FCM Token: ${token.substring(0, 20)}...');
        await _saveTokenToFirestore(token);
      }
    } catch (e) {
      print('❌ Error getting FCM token: $e');
    }
  }

  Future<void> _saveTokenToFirestore(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('❌ Cannot save FCM token: User not authenticated');
      return;
    }

    try {
      // Save to fcmTokens/{userId}/tokens/{token}
      // This matches your backend structure
      await _firestore
          .collection('fcmTokens')
          .doc(user.uid)
          .collection('tokens')
          .doc(token)
          .set({
            'enabled': true,
            'platform': Platform.isIOS ? 'ios' : 'android',
            'createdAt': FieldValue.serverTimestamp(),
            'lastSeenAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      print('✅ FCM token saved to Firestore');
    } catch (e) {
      print('❌ Error saving FCM token: $e');
    }
  }

  /// Call this when user logs out
  Future<void> disableToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _firestore
            .collection('fcmTokens')
            .doc(user.uid)
            .collection('tokens')
            .doc(token)
            .update({'enabled': false});
        print('✅ FCM token disabled');
      }
    } catch (e) {
      print('❌ Error disabling FCM token: $e');
    }
  }
}
