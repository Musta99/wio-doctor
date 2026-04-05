import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wio_doctor/features/auth/view/login_screen.dart';
import 'package:wio_doctor/features/auth/view_model/email_verification_view_model.dart';

// ── Theme constants ───────────────────────────────────────────────────────────
const _primary = Color(0xFF14C7EB);
const _primaryLight = Color(0xFFE6F9FD);
const _primaryMid = Color(0xFFB3EEF9);
const _bg = Colors.white;
const _textDark = Color(0xFF0D1B2A);
const _textMid = Color(0xFF6B7A8D);
const _textLight = Color(0xFFB0BAC5);
const _error = Color(0xFFFF4F6B);
const _success = Color(0xFF00C896);

// ── Public entry point ────────────────────────────────────────────────────────
class EmailVerificationScreen extends StatelessWidget {
  final String email;
  final String userName;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmailVerificationViewModel(),
      child: _EmailVerificationView(email: email, userName: userName),
    );
  }
}

// ── Internal view ─────────────────────────────────────────────────────────────
class _EmailVerificationView extends StatefulWidget {
  final String email;
  final String userName;

  const _EmailVerificationView({required this.email, required this.userName});

  @override
  State<_EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<_EmailVerificationView>
    with TickerProviderStateMixin {
  // ── Animation controllers ─────────────────────────────────────────────────
  late final AnimationController _envelopeController;
  late final AnimationController _pulseController;
  late final AnimationController _successController;
  late final Animation<double> _envelopeBounce;
  late final Animation<double> _pulseAnim;
  late final Animation<double> _successScale;
  late final Animation<double> _successOpacity;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmailVerificationViewModel>().init(onVerified: _onVerified);
    });
  }

  void _initAnimations() {
    _envelopeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _envelopeBounce = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _envelopeController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _pulseAnim = Tween<double>(
      begin: 0.75,
      end: 1.35,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _successScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );

    _successOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.easeIn),
    );
  }

  Future<void> _onVerified() async {
    _envelopeController.stop();
    _pulseController.stop();
    await _successController.forward();
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionsBuilder:
              (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
        ),
        (route) => false,
      );
    }
  }

  Future<void> _signOutAndGoBack() async {
    await context.read<EmailVerificationViewModel>().signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _envelopeController.dispose();
    _pulseController.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmailVerificationViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: _bg,
          body: SafeArea(
            child: vm.isVerified ? _buildSuccessState() : _buildVerifyState(vm),
          ),
        );
      },
    );
  }

  // ── Success state ─────────────────────────────────────────────────────────
  Widget _buildSuccessState() {
    return Center(
      child: FadeTransition(
        opacity: _successOpacity,
        child: ScaleTransition(
          scale: _successScale,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _success.withOpacity(0.08),
                      ),
                    ),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _success.withOpacity(0.14),
                      ),
                    ),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: _success,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  "Email Verified!",
                  style: GoogleFonts.exo(
                    color: _textDark,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Redirecting you to login…",
                  style: GoogleFonts.exo(
                    color: _textMid,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Waiting state ─────────────────────────────────────────────────────────
  Widget _buildVerifyState(EmailVerificationViewModel vm) {
    final firstName = widget.userName;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),

            // Back button
            Row(
              children: [
                GestureDetector(
                  onTap: _signOutAndGoBack,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _primaryLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _primaryMid),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: _primary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 44),

            // Animated envelope
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer pulse ring
                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder:
                        (_, __) => Transform.scale(
                          scale: _pulseAnim.value,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _primary.withOpacity(
                                  (1.35 - _pulseAnim.value).clamp(0.0, 0.18),
                                ),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                  ),
                  // Inner pulse ring (lagged)
                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, __) {
                      final lag =
                          ((_pulseAnim.value - 0.2).clamp(0.75, 1.35) - 0.75) /
                          0.6;
                      return Transform.scale(
                        scale: 0.75 + lag * 0.6,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _primary.withOpacity(
                                (0.25 - lag * 0.25).clamp(0, 0.25),
                              ),
                              width: 1.5,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Background glow disc
                  Container(
                    width: 110,
                    height: 110,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: _primaryLight,
                    ),
                  ),
                  // Floating envelope
                  AnimatedBuilder(
                    animation: _envelopeBounce,
                    builder:
                        (_, __) => Transform.translate(
                          offset: Offset(0, _envelopeBounce.value),
                          child: _buildEnvelopeIcon(),
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Heading
            Text(
              "Check your inbox,",
              style: GoogleFonts.exo(
                color: _textMid,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Dr. $firstName",
              style: GoogleFonts.exo(
                color: _textDark,
                fontSize: 34,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
              ),
            ),

            const SizedBox(height: 20),

            // Email pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _primaryLight,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: _primaryMid),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.mail_outline_rounded,
                    color: _primary,
                    size: 15,
                  ),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Text(
                      widget.email,
                      style: GoogleFonts.exo(
                        color: _primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Description
            Text(
              "We've sent a verification link to your email address. "
              "Click it to activate your account — this may take a minute.",
              textAlign: TextAlign.center,
              style: GoogleFonts.exo(
                color: _textMid,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.7,
                letterSpacing: 0.1,
              ),
            ),

            const SizedBox(height: 44),

            // Primary CTA
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed:
                    vm.isChecking
                        ? null
                        : () => vm.checkVerification(silent: false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  disabledBackgroundColor: _primary.withOpacity(0.35),
                  foregroundColor: Colors.white,
                  shadowColor: _primary.withOpacity(0.35),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child:
                    vm.isChecking
                        ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : Text(
                          "I've verified my email",
                          style: GoogleFonts.exo(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
              ),
            ),

            const SizedBox(height: 14),

            // Resend button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed:
                    (vm.resendCooldown > 0 || vm.isResending)
                        ? null
                        : vm.resendEmail,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: vm.resendCooldown > 0 ? _textLight : _primary,
                    width: 1.5,
                  ),
                  foregroundColor: _primary,
                  disabledForegroundColor: _textLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child:
                    vm.isResending
                        ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(_primary),
                          ),
                        )
                        : Text(
                          vm.resendCooldown > 0
                              ? "Resend in ${vm.resendCooldown}s"
                              : "Resend verification email",
                          style: GoogleFonts.exo(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
              ),
            ),

            const SizedBox(height: 28),

            // Spam tip
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: _textLight,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  "Don't forget to check your spam folder",
                  style: GoogleFonts.exo(
                    color: _textLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Envelope icon ─────────────────────────────────────────────────────────
  Widget _buildEnvelopeIcon() {
    return SizedBox(
      width: 78,
      height: 78,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3DD6F5), _primary],
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: _primary.withOpacity(0.35),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.mark_email_unread_rounded,
            color: Colors.white,
            size: 36,
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: _error,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
