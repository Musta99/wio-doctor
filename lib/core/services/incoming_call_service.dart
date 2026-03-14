// lib/services/incoming_call_service.dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IncomingCallService {
  static final IncomingCallService _instance = IncomingCallService._();
  static IncomingCallService get instance => _instance;

  IncomingCallService._();

  StreamSubscription<QuerySnapshot>? _callSubscription;
  final _incomingCallController =
      StreamController<Map<String, dynamic>?>.broadcast();

  Stream<Map<String, dynamic>?> get incomingCallStream =>
      _incomingCallController.stream;

  String? _currentUserId;
  bool _isListening = false;

  // ✅ Track processed signals to avoid duplicates
  final Set<String> _processedSignals = {};

  void startListening() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('❌ Cannot listen for calls: User not authenticated');
      return;
    }

    if (_isListening && _currentUserId == user.uid) {
      print('📞 Already listening for calls');
      return;
    }

    _currentUserId = user.uid;
    _isListening = true;
    _processedSignals.clear();

    print('📞 Starting incoming call listener for user: ${user.uid}');

    _callSubscription?.cancel();

    // ✅ Simplified query - just filter by status
    _callSubscription = FirebaseFirestore.instance
        .collection('telemedicine_signals')
        .where('status', isEqualTo: 'pending')
        .where('doctorId', isEqualTo: user.uid)
        .snapshots()
        .listen(
          (snapshot) {
            print(
              '📞 Firestore snapshot received: ${snapshot.docs.length} docs, ${snapshot.docChanges.length} changes',
            );
            _handleSignalSnapshot(snapshot, user.uid);
          },
          onError: (error) {
            print('❌ Error listening for calls-------: $error');
          },
        );
  }

  void _handleSignalSnapshot(QuerySnapshot snapshot, String currentUserId) {
    for (var change in snapshot.docChanges) {
      final docId = change.doc.id;

      print('📞 Doc change: ${change.type.name} - $docId');

      // ✅ Process both added and modified (in case we missed the add)
      if (change.type == DocumentChangeType.added ||
          change.type == DocumentChangeType.modified) {
        // Skip if already processed
        if (_processedSignals.contains(docId)) {
          print('📞 Already processed signal: $docId');
          continue;
        }

        final data = change.doc.data() as Map<String, dynamic>;
        data['id'] = docId;
        data['signalId'] = docId;

        final patientId = data['patientId'] as String?;
        final doctorId = data['doctorId'] as String?;
        final initiatedBy = data['initiatedBy'] as String?;
        final status = data['status'] as String?;

        print('📞 Signal details:');
        print('   - patientId: $patientId');
        print('   - doctorId: $doctorId');
        print('   - initiatedBy: $initiatedBy');
        print('   - status: $status');
        print('   - currentUserId: $currentUserId');

        // ✅ Skip if not pending
        if (status != 'pending') {
          print('📞 Skipping: status is $status');
          continue;
        }

        // ✅ Determine if this call is for the current user
        bool isForCurrentUser = false;
        bool isCurrentUserCaller = false;

        if (initiatedBy == 'patient') {
          isForCurrentUser = doctorId == currentUserId;
          isCurrentUserCaller = patientId == currentUserId;
        } else if (initiatedBy == 'doctor') {
          isForCurrentUser = patientId == currentUserId;
          isCurrentUserCaller = doctorId == currentUserId;
        } else {
          // ✅ FALLBACK: If initiatedBy is missing, check if user is recipient
          // Assume the call is for us if we're either the patient or doctor
          // and we're not the one who would have started it
          print('📞 WARNING: initiatedBy is missing or unknown: $initiatedBy');

          // If we're the doctor, assume patient called us
          // If we're the patient, assume doctor called us
          if (doctorId == currentUserId) {
            isForCurrentUser = true;
            isCurrentUserCaller = false;
          } else if (patientId == currentUserId) {
            isForCurrentUser = true;
            isCurrentUserCaller = false;
          }
        }

        print('   - isForCurrentUser: $isForCurrentUser');
        print('   - isCurrentUserCaller: $isCurrentUserCaller');

        if (isCurrentUserCaller) {
          print('📞 Ignoring own outgoing call: $docId');
          continue;
        }

        if (!isForCurrentUser) {
          print('📞 Call is not for current user: $docId');
          continue;
        }

        // Check if call is recent (within last 60 seconds)
        final createdAt = data['createdAt'];
        if (createdAt != null) {
          DateTime callTime;
          if (createdAt is Timestamp) {
            callTime = createdAt.toDate();
          } else {
            print('📞 Invalid createdAt format');
            continue;
          }

          final age = DateTime.now().difference(callTime);
          if (age.inSeconds > 60) {
            print(
              '📞 Ignoring old call signal: $docId (${age.inSeconds}s old)',
            );
            continue;
          }
        }

        // ✅ Mark as processed
        _processedSignals.add(docId);

        print('📲 INCOMING CALL DETECTED: $docId');
        print(
          '   From: ${data['patientName'] ?? data['doctorName'] ?? 'Unknown'}',
        );
        print('   Channel: ${data['channelName']}');

        _incomingCallController.add(data);
      }
    }
  }

  void stopListening() {
    print('🔇 Stopping incoming call listener');
    _callSubscription?.cancel();
    _callSubscription = null;
    _isListening = false;
    _currentUserId = null;
    _processedSignals.clear();
  }

  Future<void> updateSignalStatus(String signalId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('telemedicine_signals')
          .doc(signalId)
          .update({
            'status': status,
            'updatedAt': FieldValue.serverTimestamp(),
          });
      print('✅ Signal status updated to: $status');

      // Remove from processed so we don't re-process
      _processedSignals.remove(signalId);
    } catch (e) {
      print('❌ Error updating signal status: $e');
    }
  }

  Future<void> acceptCall(String signalId) async {
    await updateSignalStatus(signalId, 'accepted');
  }

  Future<void> declineCall(String signalId) async {
    await updateSignalStatus(signalId, 'declined');
  }

  void dispose() {
    stopListening();
    _incomingCallController.close();
  }
}
