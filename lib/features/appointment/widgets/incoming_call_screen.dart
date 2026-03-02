import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wio_doctor/view_model/incoming_call_provider.dart';


class IncomingCallScreen extends StatefulWidget {
  final Map<String, dynamic> callData;

  const IncomingCallScreen({Key? key, required this.callData})
    : super(key: key);

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  String get callerName {
    final initiatedBy = widget.callData['initiatedBy'] ?? 'patient';
    if (initiatedBy == 'patient') {
      return widget.callData['patientName'] ?? 'Patient';
    } else {
      return widget.callData['doctorName'] ?? 'Doctor';
    }
  }

  String? get callerPhoto {
    final initiatedBy = widget.callData['initiatedBy'] ?? 'patient';
    if (initiatedBy == 'patient') {
      return widget.callData['patientPhotoURL'];
    } else {
      return widget.callData['doctorPhotoURL'];
    }
  }

  String get signalId =>
      widget.callData['signalId'] ?? widget.callData['id'] ?? '';
  String get channelName => widget.callData['channelName'] ?? '';
  String get doctorId => widget.callData['doctorId'] ?? '';
  String get patientId => widget.callData['patientId'] ?? '';

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<IncomingCallProvider>();
      provider.startTimeout(() {
        provider.declineCall(signalId: signalId);
        if (mounted) Navigator.pop(context);
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleAcceptCall(IncomingCallProvider provider) {
    provider.acceptCall(
      context: context,
      callData: widget.callData,
      onSuccess: (String agoraToken) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Not authenticated')));
          Navigator.pop(context);
          return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => VideoCallScreen(
                  channelName: channelName,
                  agoraToken: agoraToken,
                  signalId: signalId,
                  doctorId: doctorId,
                  patientId: patientId,
                  doctorName: callerName,
                  doctorPhotoURL: callerPhoto,
                  isPatient: user.uid == patientId,
                  userAccount: user.uid,
                ),
          ),
        );
      },
      onError: (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to join call: $error')));
        Navigator.pop(context);
      },
    );
  }

  void _handleDeclineCall(IncomingCallProvider provider) async {
    await provider.declineCall(signalId: signalId);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final provider = context.read<IncomingCallProvider>();
          await provider.declineCall(signalId: signalId);
          if (mounted) Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1a1a2e),
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Caller avatar with pulse animation
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey[800],
                    backgroundImage:
                        callerPhoto != null ? NetworkImage(callerPhoto!) : null,
                    child:
                        callerPhoto == null
                            ? const Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.white,
                            )
                            : null,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Text(
                callerName,
                style: GoogleFonts.exo(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Incoming video call...',
                style: GoogleFonts.exo2(color: Colors.white70, fontSize: 16),
              ),

              const Spacer(flex: 3),

              Consumer<IncomingCallProvider>(
                builder: (context, provider, _) {
                  if (provider.isProcessing) {
                    return Column(
                      children: [
                        const CircularProgressIndicator(color: Colors.white),
                        const SizedBox(height: 16),
                        Text(
                          'Connecting...',
                          style: GoogleFonts.exo2(color: Colors.white70),
                        ),
                      ],
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _CallActionButton(
                          icon: Icons.call_end,
                          color: Colors.red,
                          label: 'Decline',
                          onTap: () => _handleDeclineCall(provider),
                        ),
                        _CallActionButton(
                          icon: Icons.videocam,
                          color: Colors.green,
                          label: 'Accept',
                          onTap: () => _handleAcceptCall(provider),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CallActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _CallActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: GoogleFonts.exo(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}