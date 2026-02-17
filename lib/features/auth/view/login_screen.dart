import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/features/auth/view/signup_screen.dart';
import 'package:wio_doctor/features/auth/view_model/login_viewmodel.dart';
import 'package:wio_doctor/features/bottom_nav_bar/view/bottom_nav_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool hidePass = true;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgTop = isDark ? const Color(0xFF0B1220) : const Color(0xFFF7F8FC);
    final bgBottom = isDark ? const Color(0xFF060A12) : Colors.white;

    final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor =
        isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.06);
    final subtleText =
        isDark
            ? Colors.white.withOpacity(0.72)
            : Colors.black.withOpacity(0.62);

    TextStyle titleStyle(double s) => GoogleFonts.exo(
      fontSize: s,
      fontWeight: FontWeight.w900,
      letterSpacing: -0.2,
    );

    TextStyle bodyStyle(double s) =>
        GoogleFonts.exo(fontSize: s, fontWeight: FontWeight.w700);

    BoxDecoration cardDecoration() => BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: borderColor),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
          blurRadius: 18,
          offset: const Offset(0, 10),
        ),
      ],
    );

    InputDecoration inputDec({
      required String hint,
      required IconData icon,
      Widget? suffix,
    }) {
      return InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.exo(color: subtleText, fontSize: 13),
        prefixIcon: Icon(icon, size: 18),
        suffixIcon: suffix,
        filled: true,
        fillColor:
            isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF3F4F8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.teal.withOpacity(0.65)),
        ),
      );
    }

    Widget topBrand() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.teal.withOpacity(isDark ? 0.18 : 0.12),
              border: Border.all(
                color: Colors.teal.withOpacity(isDark ? 0.30 : 0.18),
              ),
            ),
            child: const Icon(
              LucideIcons.stethoscope,
              color: Colors.teal,
              size: 22,
            ),
          ),
          const SizedBox(height: 12),
          Text("Welcome back", style: titleStyle(26)),
          const SizedBox(height: 6),
          Text(
            "Login to manage appointments and patients.",
            style: bodyStyle(13.5).copyWith(color: subtleText),
          ),
        ],
      );
    }

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
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topBrand(),
                const SizedBox(height: 18),
                Container(
                  decoration: cardDecoration(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email", style: titleStyle(13.5)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        style: bodyStyle(14),
                        decoration: inputDec(
                          hint: "doctor@email.com",
                          icon: LucideIcons.mail,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text("Password", style: titleStyle(13.5)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: passCtrl,
                        obscureText: hidePass,
                        style: bodyStyle(14),
                        decoration: inputDec(
                          hint: "••••••••",
                          icon: LucideIcons.lock,
                          suffix: IconButton(
                            onPressed:
                                () => setState(() => hidePass = !hidePass),
                            icon: Icon(
                              hidePass ? LucideIcons.eye : LucideIcons.eyeOff,
                              size: 18,
                            ),
                            tooltip:
                                hidePass ? "Show password" : "Hide password",
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Navigate to forgot password
                          },
                          child: Text(
                            "Forgot password?",
                            style: GoogleFonts.exo(
                              fontWeight: FontWeight.w900,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Consumer<LoginViewmodel>(
                        builder: (context, loginVM, child) {
                          return ShadButton(
                            width: double.infinity,
                            backgroundColor: Colors.teal,
                            onPressed: () async {
                              if (loginVM.isLoginLoading) return;

                              await loginVM.login(
                                emailCtrl.text,
                                passCtrl.text,
                                context,
                              );

                              // clear the text fields after login attempt
                              emailCtrl.clear();
                              passCtrl.clear();
                            },
                            child:
                                loginVM.isLoginLoading
                                    ? Icon(
                                      LucideIcons.loader,
                                      size: 18,
                                      color: Colors.white,
                                    )
                                    : Text(
                                      "Login",
                                      style: GoogleFonts.exo(
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      Center(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              "New here? ",
                              style: bodyStyle(13).copyWith(color: subtleText),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Create an account",
                                style: GoogleFonts.exo(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
