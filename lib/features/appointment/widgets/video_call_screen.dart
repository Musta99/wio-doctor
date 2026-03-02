// lib/screens/video_call_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:wio_doctor/view_model/video_call_provider.dart';

class VideoCallScreen extends StatelessWidget {
  final String channelName;
  final String agoraToken;
  final String signalId;
  final String doctorId;
  final String patientId;
  final String doctorName;
  final String? doctorPhotoURL;
  final bool isPatient;
  final String userAccount;

  const VideoCallScreen({
    super.key,
    required this.channelName,
    required this.agoraToken,
    required this.signalId,
    required this.doctorId,
    required this.patientId,
    required this.doctorName,
    this.doctorPhotoURL,
    required this.isPatient,
    required this.userAccount,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) =>
              VideoCallProvider()..initAgora(
                appId: "7f05226b26174d79bfc414680113e0d2",

                channelName: channelName,
                token: agoraToken,
                userAccount: userAccount,

                signalId: signalId,
                patientId: patientId,
                doctorId: doctorId,
              ),
      child: Consumer<VideoCallProvider>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Center(
                  child:
                      vm.remoteUid != null
                          ? AgoraVideoView(
                            controller: VideoViewController.remote(
                              rtcEngine: vm.engine,
                              canvas: VideoCanvas(uid: vm.remoteUid),
                              connection: RtcConnection(channelId: channelName),
                            ),
                          )
                          : _waitingView(vm),
                ),

                if (vm.localUserJoined)
                  Positioned(
                    top: 50,
                    right: 16,
                    child: SizedBox(
                      width: 120,
                      height: 160,
                      child:
                          vm.isVideoOff
                              ? const Icon(
                                Icons.videocam_off,
                                color: Colors.white,
                              )
                              : AgoraVideoView(
                                controller: VideoViewController(
                                  rtcEngine: vm.engine,
                                  canvas: const VideoCanvas(uid: 0),
                                ),
                              ),
                    ),
                  ),

                _topBar(vm),

                _bottomControls(context, vm),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _topBar(VideoCallProvider vm) {
    return Positioned(
      top: 40,
      left: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            doctorName,
            style: GoogleFonts.exo(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            vm.isCallStarted ? vm.callDuration : vm.connectionStatus,
            style: GoogleFonts.exo2(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _bottomControls(BuildContext context, VideoCallProvider vm) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _btn(Icons.mic, vm.toggleMute, active: !vm.isMuted),
          _btn(Icons.videocam, vm.toggleVideo, active: !vm.isVideoOff),
          _btn(
            Icons.call_end,
            () async {
              await vm.endCall(
                isPatient: isPatient,
                signalId: signalId,
                patientId: patientId,
                doctorId: doctorId,
              );
              Navigator.pop(context);
            },
            color: Colors.red,
            size: 64,
          ),
          _btn(Icons.volume_up, vm.toggleSpeaker, active: vm.isSpeakerOn),
          _btn(Icons.flip_camera_ios, vm.switchCamera),
        ],
      ),
    );
  }

  Widget _btn(
    IconData icon,
    VoidCallback onTap, {
    bool active = true,
    Color? color,
    double size = 56,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color ?? (active ? Colors.white24 : Colors.grey.shade800),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _waitingView(VideoCallProvider vm) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage:
              doctorPhotoURL != null ? NetworkImage(doctorPhotoURL!) : null,
          child:
              doctorPhotoURL == null
                  ? const Icon(Icons.person, size: 60)
                  : null,
        ),
        const SizedBox(height: 24),
        Text(vm.connectionStatus, style: const TextStyle(color: Colors.white)),
        if (vm.isInitializing) const CircularProgressIndicator(),
      ],
    );
  }
}
