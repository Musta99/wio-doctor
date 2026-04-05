import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/features/auth/view/login_screen.dart';
import 'package:wio_doctor/features/auth/view_model/email_verification_view_model.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmailVerificationViewModel>().startPolling(() {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    context.read<EmailVerificationViewModel>().stopPolling();
    super.dispose();
  }

  void _navigateToLogin() {
    context.read<EmailVerificationViewModel>().stopPolling();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Future<void> _handleResend() async {
    final error =
        await context.read<EmailVerificationViewModel>().resendEmail();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: error == null ? Colors.green : Colors.red,
        content: Text(
          error ?? "Verification email resent.",
          style: GoogleFonts.exo(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Future<void> _handleCheckVerification() async {
    final verified =
        await context.read<EmailVerificationViewModel>().checkVerification();
    if (!mounted) return;
    if (verified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange,
          content: Text(
            "Email not verified yet. Please check your inbox.",
            style: GoogleFonts.exo(fontWeight: FontWeight.w700),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;

    final bgTop = isDark ? const Color(0xFF06111A) : const Color(0xFFF4F8FB);
    final bgBottom = isDark ? const Color(0xFF02060B) : const Color(0xFFFFFFFF);
    final cardColor =
        isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.white.withOpacity(0.90);
    final borderColor =
        isDark
            ? Colors.white.withOpacity(0.10)
            : Colors.white.withOpacity(0.65);
    final subtleText =
        isDark
            ? Colors.white.withOpacity(0.68)
            : Colors.black.withOpacity(0.55);
    final titleColor = isDark ? Colors.white : const Color(0xFF111827);

    TextStyle titleStyle(double s) => GoogleFonts.exo(
      fontSize: s,
      fontWeight: FontWeight.w800,
      color: titleColor,
      letterSpacing: -0.2,
    );

    TextStyle bodyStyle(double s) => GoogleFonts.exo(
      fontSize: s,
      fontWeight: FontWeight.w600,
      color: titleColor,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgTop, bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(
                      0xFF14c7eb,
                    ).withOpacity(isDark ? 0.15 : 0.10),
                    border: Border.all(
                      color: const Color(
                        0xFF14c7eb,
                      ).withOpacity(isDark ? 0.35 : 0.20),
                    ),
                  ),
                  child: const Icon(
                    LucideIcons.mailCheck,
                    size: 48,
                    color: Color(0xFF14c7eb),
                  ),
                ),

                const SizedBox(height: 28),

                Text("Verify your email", style: titleStyle(26)),
                const SizedBox(height: 12),
                Text(
                  "We've sent a verification link to",
                  textAlign: TextAlign.center,
                  style: bodyStyle(14).copyWith(color: subtleText),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? "",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.exo(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF14c7eb),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Please open your inbox and click the link to activate your account.",
                  textAlign: TextAlign.center,
                  style: bodyStyle(
                    13.5,
                  ).copyWith(color: subtleText, height: 1.55),
                ),

                const SizedBox(height: 32),

                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: borderColor),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StepHint(
                          number: "1",
                          text: "Open the email from Wio Doctor",
                          isDark: isDark,
                        ),
                        const SizedBox(height: 10),
                        _StepHint(
                          number: "2",
                          text: 'Click "Verify my email" in the message',
                          isDark: isDark,
                        ),
                        const SizedBox(height: 10),
                        _StepHint(
                          number: "3",
                          text: "Come back here and tap the button below",
                          isDark: isDark,
                        ),

                        const SizedBox(height: 20),

                        // Primary CTA
                        Consumer<EmailVerificationViewModel>(
                          builder:
                              (context, vm, _) => SizedBox(
                                width: double.infinity,
                                child: ShadButton(
                                  height: 52,
                                  backgroundColor: const Color(0xFF14c7eb),
                                  onPressed:
                                      vm.isChecking
                                          ? null
                                          : _handleCheckVerification,
                                  child:
                                      vm.isChecking
                                          ? const SizedBox(
                                            height: 18,
                                            width: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                          : Text(
                                            "I've verified my email",
                                            style: GoogleFonts.exo(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                ),
                              ),
                        ),

                        const SizedBox(height: 12),

                        // Resend button
                        Consumer<EmailVerificationViewModel>(
                          builder:
                              (context, vm, _) => SizedBox(
                                width: double.infinity,
                                child: ShadButton.outline(
                                  height: 48,
                                  onPressed:
                                      vm.isResending ? null : _handleResend,
                                  child:
                                      vm.isResending
                                          ? const SizedBox(
                                            height: 16,
                                            width: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Color(0xFF14c7eb),
                                                  ),
                                            ),
                                          )
                                          : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                LucideIcons.refreshCw,
                                                size: 15,
                                                color: Color(0xFF14c7eb),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Resend verification email",
                                                style: GoogleFonts.exo(
                                                  fontWeight: FontWeight.w800,
                                                  color: const Color(
                                                    0xFF14c7eb,
                                                  ),
                                                  fontSize: 13.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                ),
                              ),
                        ),

                        const SizedBox(height: 14),

                        Center(
                          child: GestureDetector(
                            onTap: _navigateToLogin,
                            child: Text(
                              "Back to Login",
                              style: GoogleFonts.exo(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: subtleText,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepHint extends StatelessWidget {
  final String number;
  final String text;
  final bool isDark;

  const _StepHint({
    required this.number,
    required this.text,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 26,
          width: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF14c7eb).withOpacity(isDark ? 0.18 : 0.12),
            border: Border.all(
              color: const Color(0xFF14c7eb).withOpacity(isDark ? 0.30 : 0.20),
            ),
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.exo(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF14c7eb),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.exo(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color:
                  isDark
                      ? Colors.white.withOpacity(0.75)
                      : Colors.black.withOpacity(0.65),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
