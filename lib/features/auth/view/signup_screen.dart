// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:shadcn_ui/shadcn_ui.dart';
// import 'package:wio_doctor/features/auth/view/login_screen.dart';
// import 'package:wio_doctor/features/auth/view_model/signup_viewmodel.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final emailCtrl = TextEditingController();
//   final passCtrl = TextEditingController();
//   final confirmCtrl = TextEditingController();
//   final nameCtrl = TextEditingController();

//   bool hidePass = true;
//   bool hideConfirm = true;

//   @override
//   void dispose() {
//     emailCtrl.dispose();
//     passCtrl.dispose();
//     confirmCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final bgTop = isDark ? const Color(0xFF0B1220) : const Color(0xFFF7F8FC);
//     final bgBottom = isDark ? const Color(0xFF060A12) : Colors.white;

//     final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
//     final borderColor =
//         isDark
//             ? Colors.white.withOpacity(0.08)
//             : Colors.black.withOpacity(0.06);
//     final subtleText =
//         isDark
//             ? Colors.white.withOpacity(0.72)
//             : Colors.black.withOpacity(0.62);

//     TextStyle titleStyle(double s) => GoogleFonts.exo(
//       fontSize: s,
//       fontWeight: FontWeight.w900,
//       letterSpacing: -0.2,
//     );

//     TextStyle bodyStyle(double s) =>
//         GoogleFonts.exo(fontSize: s, fontWeight: FontWeight.w700);

//     BoxDecoration cardDecoration() => BoxDecoration(
//       color: cardColor,
//       borderRadius: BorderRadius.circular(22),
//       border: Border.all(color: borderColor),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
//           blurRadius: 18,
//           offset: const Offset(0, 10),
//         ),
//       ],
//     );

//     InputDecoration inputDec({
//       required String hint,
//       required IconData icon,
//       Widget? suffix,
//     }) {
//       return InputDecoration(
//         hintText: hint,
//         hintStyle: GoogleFonts.exo(
//           color: subtleText,
//           fontWeight: FontWeight.w700,
//           fontSize: 13,
//         ),
//         prefixIcon: Icon(icon, size: 18),
//         suffixIcon: suffix,
//         filled: true,
//         fillColor:
//             isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF3F4F8),
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 12,
//           vertical: 12,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(color: borderColor),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(color: borderColor),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(color: Colors.teal.withOpacity(0.65)),
//         ),
//       );
//     }

//     Widget topBrand() {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 52,
//             width: 52,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(18),
//               color: Colors.teal.withOpacity(isDark ? 0.18 : 0.12),
//               border: Border.all(
//                 color: Colors.teal.withOpacity(isDark ? 0.30 : 0.18),
//               ),
//             ),
//             child: const Icon(
//               LucideIcons.userPlus,
//               color: Colors.teal,
//               size: 22,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text("Create account", style: titleStyle(26)),
//           const SizedBox(height: 6),
//           Text(
//             "Sign up to start using Wio Doctor.",
//             style: bodyStyle(13.5).copyWith(color: subtleText),
//           ),
//         ],
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Sign Up",
//           style: GoogleFonts.exo(fontWeight: FontWeight.w900),
//         ),
//         centerTitle: true,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [bgTop, bgBottom],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 topBrand(),
//                 const SizedBox(height: 18),
//                 Container(
//                   decoration: cardDecoration(),
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Name", style: titleStyle(13.5)),
//                       const SizedBox(height: 8),
//                       TextField(
//                         controller: nameCtrl,
//                         keyboardType: TextInputType.name,
//                         style: bodyStyle(14),
//                         decoration: inputDec(
//                           hint: "Enter your full name",
//                           icon: LucideIcons.user,
//                         ),
//                       ),

//                       Text("Email", style: titleStyle(13.5)),
//                       const SizedBox(height: 8),
//                       TextField(
//                         controller: emailCtrl,
//                         keyboardType: TextInputType.emailAddress,
//                         style: bodyStyle(14),
//                         decoration: inputDec(
//                           hint: "doctor@email.com",
//                           icon: LucideIcons.mail,
//                         ),
//                       ),
//                       const SizedBox(height: 12),

//                       Text("Password", style: titleStyle(13.5)),
//                       const SizedBox(height: 8),
//                       TextField(
//                         controller: passCtrl,
//                         obscureText: hidePass,
//                         style: bodyStyle(14),
//                         decoration: inputDec(
//                           hint: "••••••••",
//                           icon: LucideIcons.lock,
//                           suffix: IconButton(
//                             onPressed:
//                                 () => setState(() => hidePass = !hidePass),
//                             icon: Icon(
//                               hidePass ? LucideIcons.eye : LucideIcons.eyeOff,
//                               size: 18,
//                             ),
//                             tooltip:
//                                 hidePass ? "Show password" : "Hide password",
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 12),

//                       Text("Confirm Password", style: titleStyle(13.5)),
//                       const SizedBox(height: 8),
//                       TextField(
//                         controller: confirmCtrl,
//                         obscureText: hideConfirm,
//                         style: bodyStyle(14),
//                         decoration: inputDec(
//                           hint: "••••••••",
//                           icon: LucideIcons.shieldCheck,
//                           suffix: IconButton(
//                             onPressed:
//                                 () =>
//                                     setState(() => hideConfirm = !hideConfirm),
//                             icon: Icon(
//                               hideConfirm
//                                   ? LucideIcons.eye
//                                   : LucideIcons.eyeOff,
//                               size: 18,
//                             ),
//                             tooltip:
//                                 hideConfirm ? "Show password" : "Hide password",
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 14),

//                       Consumer<SignupViewModel>(
//                         builder: (context, signupVM, child) {
//                           return ShadButton(
//                             width: double.infinity,
//                             backgroundColor: Colors.teal,
//                             onPressed: () async {
//                               if (nameCtrl.text.isEmpty ||
//                                   emailCtrl.text.isEmpty ||
//                                   passCtrl.text.isEmpty ||
//                                   confirmCtrl.text.isEmpty) {
//                                 Fluttertoast.showToast(
//                                   backgroundColor: Colors.red,
//                                   gravity: ToastGravity.CENTER,
//                                   msg: "Please fill in all fields.",
//                                   fontSize: 16,
//                                 );
//                               } else if (passCtrl.text != confirmCtrl.text) {
//                                 Fluttertoast.showToast(
//                                   backgroundColor: Colors.red,
//                                   gravity: ToastGravity.CENTER,
//                                   msg: "Passwords do not match.",
//                                   fontSize: 15,
//                                 );
//                               } else {
//                                 await signupVM.doctorSignUp(
//                                   emailCtrl.text.trim(),
//                                   passCtrl.text.trim(),
//                                   nameCtrl.text.trim(),
//                                 );
//                                 // Clear input fields after successful signup

//                                 nameCtrl.clear();
//                                 emailCtrl.clear();
//                                 passCtrl.clear();

//                                 // Navigate to login screen after successful signup
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => LoginScreen(),
//                                   ),
//                                 );
//                               }
//                             },
//                             child:
//                                 signupVM.isSignupLoading
//                                     ? Icon(
//                                       LucideIcons.loader,
//                                       color: Colors.white,
//                                       size: 18,
//                                     )
//                                     : Text(
//                                       "Sign Up",
//                                       style: GoogleFonts.exo(
//                                         fontWeight: FontWeight.w900,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                           );
//                         },
//                       ),

//                       const SizedBox(height: 12),

//                       Center(
//                         child: Wrap(
//                           crossAxisAlignment: WrapCrossAlignment.center,
//                           children: [
//                             Text(
//                               "Already have an account? ",
//                               style: bodyStyle(13).copyWith(color: subtleText),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => const LoginScreen(),
//                                   ),
//                                 );
//                               },
//                               child: Text(
//                                 "Login",
//                                 style: GoogleFonts.exo(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w900,
//                                   color: Colors.teal,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// -------------------------------- 22222222222222222222222222 -----------------------------
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/features/auth/view/login_screen.dart';
import 'package:wio_doctor/features/auth/view_model/signup_viewmodel.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  bool hidePass = true;
  bool hideConfirm = true;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgTop = isDark ? const Color(0xFF06111A) : const Color(0xFFF4F8FB);
    final bgBottom = isDark ? const Color(0xFF02060B) : const Color(0xFFFFFFFF);

    final cardColor =
        isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.white.withOpacity(0.72);

    final borderColor =
        isDark
            ? Colors.white.withOpacity(0.10)
            : Colors.white.withOpacity(0.65);

    final subtleText =
        isDark
            ? Colors.white.withOpacity(0.72)
            : Colors.black.withOpacity(0.58);

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

    InputDecoration inputDec({
      required String hint,
      required IconData icon,
      Widget? suffix,
    }) {
      return InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.exo(
          color: subtleText,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(
          icon,
          size: 18,
          color: isDark ? Colors.white70 : Colors.black54,
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor:
            isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF7FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.08) : Colors.black12,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.08) : Colors.black12,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Color(0xFF14c7eb).withOpacity(0.65),
            width: 1.4,
          ),
        ),
      );
    }

    Widget backgroundOrbs() {
      return Stack(
        children: [
          Positioned(
            top: -40,
            left: -30,
            child: Container(
              height: 170,
              width: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF14c7eb).withOpacity(isDark ? 0.16 : 0.12),
              ),
            ),
          ),
          Positioned(
            top: 120,
            right: -40,
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyan.withOpacity(isDark ? 0.10 : 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: 110,
            left: -20,
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF14c7eb).withOpacity(isDark ? 0.08 : 0.08),
              ),
            ),
          ),
        ],
      );
    }

    Widget topBrand() {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF14c7eb).withOpacity(isDark ? 0.22 : 0.14),
                  Colors.cyanAccent.withOpacity(isDark ? 0.10 : 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Color(0xFF14c7eb).withOpacity(isDark ? 0.35 : 0.18),
                width: 1.1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF14c7eb).withOpacity(isDark ? 0.22 : 0.10),
                  blurRadius: 30,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Container(
              height: 82,
              width: 82,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white.withOpacity(0.88),
              ),
              child: Image.asset(
                "assets/icons/app_logo.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: Color(0xFF14c7eb).withOpacity(isDark ? 0.14 : 0.09),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Color(0xFF14c7eb).withOpacity(isDark ? 0.25 : 0.14),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  LucideIcons.userPlus,
                  size: 15,
                  color: Color(0xFF14c7eb),
                ),
                const SizedBox(width: 8),
                Text(
                  "Create Doctor Account",
                  style: GoogleFonts.exo(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14c7eb),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Create account",
            textAlign: TextAlign.center,
            style: titleStyle(30),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Sign up to manage patients, appointments, and your healthcare workflow in one secure place.",
              textAlign: TextAlign.center,
              style: bodyStyle(13.5).copyWith(
                color: subtleText,
                height: 1.55,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    }

    Widget signupCard() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Full Name", style: titleStyle(13.5)),
                const SizedBox(height: 8),
                TextField(
                  controller: nameCtrl,
                  keyboardType: TextInputType.name,
                  style: bodyStyle(14),
                  decoration: inputDec(
                    hint: "Enter your full name",
                    icon: LucideIcons.user,
                  ),
                ),

                const SizedBox(height: 14),

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

                const SizedBox(height: 14),

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
                      onPressed: () => setState(() => hidePass = !hidePass),
                      icon: Icon(
                        hidePass ? LucideIcons.eye : LucideIcons.eyeOff,
                        size: 18,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                      tooltip: hidePass ? "Show password" : "Hide password",
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Text("Confirm Password", style: titleStyle(13.5)),
                const SizedBox(height: 8),
                TextField(
                  controller: confirmCtrl,
                  obscureText: hideConfirm,
                  style: bodyStyle(14),
                  decoration: inputDec(
                    hint: "••••••••",
                    icon: LucideIcons.shieldCheck,
                    suffix: IconButton(
                      onPressed:
                          () => setState(() => hideConfirm = !hideConfirm),
                      icon: Icon(
                        hideConfirm ? LucideIcons.eye : LucideIcons.eyeOff,
                        size: 18,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                      tooltip: hideConfirm ? "Show password" : "Hide password",
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Consumer<SignupViewModel>(
                  builder: (context, signupVM, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: ShadButton(
                        height: 52,
                        backgroundColor: Color(0xFF14c7eb),
                        onPressed: () async {
                          if (nameCtrl.text.isEmpty ||
                              emailCtrl.text.isEmpty ||
                              passCtrl.text.isEmpty ||
                              confirmCtrl.text.isEmpty) {
                            Fluttertoast.showToast(
                              backgroundColor: Colors.red,
                              gravity: ToastGravity.CENTER,
                              msg: "Please fill in all fields.",
                              fontSize: 16,
                            );
                          } else if (passCtrl.text != confirmCtrl.text) {
                            Fluttertoast.showToast(
                              backgroundColor: Colors.red,
                              gravity: ToastGravity.CENTER,
                              msg: "Passwords do not match.",
                              fontSize: 15,
                            );
                          } else {
                            await signupVM.doctorSignUp(
                              emailCtrl.text.trim(),
                              passCtrl.text.trim(),
                              nameCtrl.text.trim(),
                            );

                            nameCtrl.clear();
                            emailCtrl.clear();
                            passCtrl.clear();
                            confirmCtrl.clear();

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          }
                        },
                        child:
                            signupVM.isSignupLoading
                                ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : Text(
                                  "Create Account",
                                  style: GoogleFonts.exo(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 14),

                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: bodyStyle(13).copyWith(color: subtleText),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.exo(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF14c7eb),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
        child: Stack(
          children: [
            backgroundOrbs(),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 24),
                child: Column(
                  children: [
                    topBrand(),
                    const SizedBox(height: 10),
                    signupCard(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
