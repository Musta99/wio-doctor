import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wio_doctor/core/services/agora_services.dart';

class VideoCallProvider extends ChangeNotifier {
  RtcEngine? _engine;
  RtcEngine get engine => _engine!;

  bool localUserJoined = false;
  int? remoteUid;
  bool isMuted = false;
  bool isVideoOff = false;
  bool isSpeakerOn = true;
  bool isCallStarted = false;
  bool isInitializing = true;
  bool _isEngineInitialized = false;

  DateTime? callStartTime;
  Timer? durationTimer;
  String callDuration = '00:00';
  String connectionStatus = 'Initializing...';

  Future<void> initAgora({
    required String appId,
    required String channelName,
    required String token,
    required String userAccount,
    required String signalId,
    required String doctorId,
    required String patientId,
  }) async {
    // Prevent double initialization
    if (_isEngineInitialized) {
      print('⚠️ Engine already initialized');
      return;
    }

    try {
      print('🎥 Starting Agora initialization...');

      final mic = await Permission.microphone.request();
      final cam = await Permission.camera.request();

      if (!mic.isGranted || !cam.isGranted) {
        connectionStatus = 'Permissions denied';
        isInitializing = false;
        notifyListeners();
        return;
      }

      _engine = createAgoraRtcEngine();
      _isEngineInitialized = true;

      await _engine!.initialize(
        RtcEngineContext(
          appId: appId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      print('🎥 Engine initialized successfully');

      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            print('✅ Joined channel: ${connection.channelId}');
            localUserJoined = true;
            isInitializing = false;
            connectionStatus = 'Waiting for other user...';

            // ✅ Set speakerphone AFTER joining channel
            _engine?.setEnableSpeakerphone(isSpeakerOn);

            notifyListeners();
          },
          onUserJoined: (connection, uid, elapsed) {
            print('✅ Remote user joined: $uid');
            remoteUid = uid;
            connectionStatus = 'Connected';
            _startCall(signalId, patientId, doctorId, channelName);
            notifyListeners();
          },
          onUserOffline: (connection, uid, reason) {
            print('❌ User offline: $uid, reason: $reason');
            remoteUid = null;
            connectionStatus = 'User left';
            notifyListeners();
          },
          onConnectionStateChanged: (connection, state, reason) {
            print('🔄 Connection state: $state, reason: $reason');
            connectionStatus = state.name;
            notifyListeners();
          },
          onError: (err, msg) {
            print('❌ Agora Error: $err - $msg');
          },
        ),
      );

      await _engine!.enableVideo();
      print('🎥 Video enabled');

      await _engine!.startPreview();
      print('🎥 Preview started');

      // ❌ DON'T call setEnableSpeakerphone here - moved to onJoinChannelSuccess

      await _engine!.joinChannelWithUserAccount(
        token: token,
        channelId: channelName,
        userAccount: userAccount,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          publishMicrophoneTrack: true,
          publishCameraTrack: true,
        ),
      );

      print('🎥 Join channel request sent');
    } catch (e, stackTrace) {
      print('❌ Agora initialization failed: $e');
      print('📜 Stack trace: $stackTrace');
      connectionStatus = 'Error: ${e.toString()}';
      isInitializing = false;
      _isEngineInitialized = false;
      notifyListeners();
    }
  }

  void _startCall(
    String signalId,
    String patientId,
    String doctorId,
    String channelName,
  ) async {
    if (isCallStarted) return;

    isCallStarted = true;
    callStartTime = DateTime.now();

    durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      callDuration = _getDuration();
      notifyListeners();
    });

    await AgoraService.createSession(
      signalId: signalId,
      patientId: patientId,
      doctorId: doctorId,
      channelName: channelName,
    );
  }

  Future<void> endCall({
    required String signalId,
    required bool isPatient,
    required String patientId,
    required String doctorId,
  }) async {
    durationTimer?.cancel();

    if (isCallStarted) {
      await AgoraService.endSession(signalId: signalId);
    }

    await AgoraService.deleteSignal(
      patientId: isPatient ? patientId : null,
      doctorId: isPatient ? null : doctorId,
    );

    if (_isEngineInitialized && _engine != null) {
      await _engine!.leaveChannel();
      await _engine!.release();
      _isEngineInitialized = false;
    }
  }

  void toggleMute() {
    if (!_isEngineInitialized) return;
    isMuted = !isMuted;
    _engine?.muteLocalAudioStream(isMuted);
    notifyListeners();
  }

  void toggleVideo() {
    if (!_isEngineInitialized) return;
    isVideoOff = !isVideoOff;
    _engine?.muteLocalVideoStream(isVideoOff);
    notifyListeners();
  }

  void toggleSpeaker() {
    if (!_isEngineInitialized || !localUserJoined)
      return; // ✅ Only after joining
    isSpeakerOn = !isSpeakerOn;
    _engine?.setEnableSpeakerphone(isSpeakerOn);
    notifyListeners();
  }

  void switchCamera() {
    if (!_isEngineInitialized) return;
    _engine?.switchCamera();
  }

  String _getDuration() {
    if (callStartTime == null) return '00:00';
    final d = DateTime.now().difference(callStartTime!);
    return '${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    durationTimer?.cancel();
    if (_isEngineInitialized && _engine != null) {
      _engine!.leaveChannel();
      _engine!.release();
    }
    super.dispose();
  }
}
