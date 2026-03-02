// lib/services/agora_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class AgoraService {
  static const String baseUrl = "https://www.wiocare.com";
  // Get Agora RTC Token
  static Future<Map<String, dynamic>?> getAgoraToken({
    required String channelName,
    required String uid,
    required String userEmail,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('User not authenticated');
        return null;
      }

      final idToken = await user.getIdToken();

      final response = await http.post(
        Uri.parse('$baseUrl/api/agora-token'),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'channelName': channelName,
          'uid': user.uid,
          'userEmail': userEmail,
        }),
      );

      print('Agora token response: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to get Agora token: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting Agora token: $e');
      return null;
    }
  }

  // Create telemedicine signal (initiate call)
  static Future<Map<String, dynamic>?> createCallSignal({
    required String patientId,
    required String doctorId,
    required String channelName,
    String? patientName,
    String? doctorName,
    String? appointmentId,
    String? consultationType,
    String? patientPhotoURL,
    String? doctorPhotoURL,
    String initiatedBy = 'doctor',
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final idToken = await user.getIdToken();

      final response = await http.post(
        Uri.parse('$baseUrl/api/telemedicine-signal'),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'patientId': patientId,
          'doctorId': user.uid,
          'channelName': channelName,
          if (patientName != null) 'patientName': patientName,
          if (doctorName != null) 'doctorName': doctorName,
          if (appointmentId != null) 'appointmentId': appointmentId,
          if (consultationType != null) 'consultationType': consultationType,
          if (patientPhotoURL != null) 'patientPhotoURL': patientPhotoURL,
          if (doctorPhotoURL != null) 'doctorPhotoURL': doctorPhotoURL,
          'initiatedBy': initiatedBy,
        }),
      );

      print('Signal response: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error creating signal: $e');
      return null;
    }
  }

  // Create/update session
  static Future<Map<String, dynamic>?> createSession({
    required String signalId,
    required String patientId,
    required String doctorId,
    required String channelName,
    String status = 'active',
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final idToken = await user.getIdToken();

      final response = await http.post(
        Uri.parse('$baseUrl/api/telemedicine-session'),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'signalId': signalId,
          'patientId': patientId,
          'doctorId': doctorId,
          'channelName': channelName,
          'status': status,
          'startedAt': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error creating session: $e');
      return null;
    }
  }

  // Update session (end call)
  static Future<bool> endSession({
    required String signalId,
    String? notes,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final idToken = await user.getIdToken();

      final response = await http.patch(
        Uri.parse('$baseUrl/api/telemedicine-session'),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'signalId': signalId,
          'status': 'completed',
          'endedAt': DateTime.now().toIso8601String(),
          if (notes != null) 'notes': notes,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error ending session: $e');
      return false;
    }
  }

  // Delete signal
  static Future<bool> deleteSignal({
    String? patientId,
    String? doctorId,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final idToken = await user.getIdToken();

      String query = '';
      if (patientId != null) {
        query = 'patientId=$patientId';
      } else if (doctorId != null) {
        query = 'doctorId=$doctorId';
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/api/telemedicine-signal?$query'),
        headers: {'Authorization': 'Bearer $idToken'},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting signal: $e');
      return false;
    }
  }
}
