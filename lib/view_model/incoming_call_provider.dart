import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wio_doctor/core/services/agora_services.dart';
import 'package:wio_doctor/core/services/incoming_call_service.dart';

class IncomingCallProvider extends ChangeNotifier {
  bool _isProcessing = false;
  Timer? _timeoutTimer;

  bool get isProcessing => _isProcessing;

  void startTimeout(VoidCallback onTimeout) {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 60), () {
      if (!_isProcessing) {
        onTimeout();
      }
    });
  }

  Future<void> acceptCall({
    required BuildContext context,
    required Map<String, dynamic> callData,
    required Function(String agoraToken) onSuccess, // ✅ Changed to pass token
    required Function(String error) onError,
  }) async {
    if (_isProcessing) return;

    _isProcessing = true;
    notifyListeners();

    _timeoutTimer?.cancel();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Not authenticated');

      final signalId = callData['signalId'] ?? callData['id'];
      final channelName = callData['channelName'];

      print('✅ Accepting call: $signalId');

      await IncomingCallService.instance.acceptCall(signalId);

      final tokenResponse = await AgoraService.getAgoraToken(
        channelName: channelName,
        uid: user.uid,
        userEmail: user.email ?? '',
      );

      if (tokenResponse == null) {
        throw Exception('Failed to get Agora token');
      }

      final agoraToken = tokenResponse['token'] as String?;

      if (agoraToken == null || agoraToken.isEmpty) {
        throw Exception('Invalid Agora token received');
      }

      print('✅ Got Agora token: ${agoraToken.substring(0, 20)}...');

      _isProcessing = false;
      notifyListeners();

      onSuccess(agoraToken); // ✅ Pass the token to callback
    } catch (e) {
      print('❌ Error accepting call: $e');
      _isProcessing = false;
      notifyListeners();
      onError(e.toString());
    }
  }

  Future<void> declineCall({required String signalId}) async {
    if (_isProcessing) return;

    _isProcessing = true;
    notifyListeners();

    _timeoutTimer?.cancel();

    try {
      await IncomingCallService.instance.declineCall(signalId);
    } catch (e) {
      print('❌ Error declining call: $e');
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }
}
