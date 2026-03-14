// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:shadcn_ui/shadcn_ui.dart';
// import 'package:wio_doctor/features/auth/view/signup_screen.dart';
// import 'package:wio_doctor/features/auth/view_model/login_viewmodel.dart';
// import 'package:wio_doctor/features/bottom_nav_bar/view/bottom_nav_bar.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final emailCtrl = TextEditingController();
//   final passCtrl = TextEditingController();

//   bool hidePass = true;

//   @override
//   void dispose() {
//     emailCtrl.dispose();
//     passCtrl.dispose();
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
//         hintStyle: GoogleFonts.exo(color: subtleText, fontSize: 13),
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
//         children: [
//           Center(
//             child: Container(
//               padding: const EdgeInsets.all(18),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.teal.withOpacity(isDark ? 0.22 : 0.14),
//                     Colors.tealAccent.withOpacity(isDark ? 0.10 : 0.08),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 border: Border.all(
//                   color: Colors.teal.withOpacity(isDark ? 0.30 : 0.18),
//                   width: 1.2,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.teal.withOpacity(isDark ? 0.18 : 0.10),
//                     blurRadius: 28,
//                     spreadRadius: 2,
//                     offset: const Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: Container(
//                 height: 82,
//                 width: 82,
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color:
//                       isDark
//                           ? Colors.white.withOpacity(0.04)
//                           : Colors.white.withOpacity(0.75),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Image.asset(
//                   "assets/icons/app_logo.png",
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),

//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.teal.withOpacity(isDark ? 0.14 : 0.10),
//               borderRadius: BorderRadius.circular(30),
//               border: Border.all(
//                 color: Colors.teal.withOpacity(isDark ? 0.24 : 0.14),
//               ),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(
//                   LucideIcons.stethoscope,
//                   size: 16,
//                   color: Colors.teal,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   "Wio Doctor",
//                   style: GoogleFonts.exo(
//                     fontSize: 12.5,
//                     fontWeight: FontWeight.w800,
//                     color: Colors.teal,
//                     letterSpacing: 0.3,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 18),

//           Text(
//             "Welcome back",
//             textAlign: TextAlign.center,
//             style: titleStyle(28),
//           ),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 18),
//             child: Text(
//               "Login to manage appointments, patients, and daily doctor activities smoothly.",
//               textAlign: TextAlign.center,
//               style: bodyStyle(13.5).copyWith(color: subtleText, height: 1.5),
//             ),
//           ),
//         ],
//       );
//     }

//     return Scaffold(
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
//                       const SizedBox(height: 10),

//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: TextButton(
//                           onPressed: () {
//                             // TODO: Navigate to forgot password
//                           },
//                           child: Text(
//                             "Forgot password?",
//                             style: GoogleFonts.exo(
//                               fontWeight: FontWeight.w900,
//                               color: Colors.teal,
//                             ),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 6),

//                       Consumer<LoginViewmodel>(
//                         builder: (context, loginVM, child) {
//                           return ShadButton(
//                             width: double.infinity,
//                             backgroundColor: Colors.teal,
//                             onPressed: () async {
//                               if (loginVM.isLoginLoading) return;

//                               await loginVM.login(
//                                 emailCtrl.text,
//                                 passCtrl.text,
//                                 context,
//                               );

//                               // clear the text fields after login attempt
//                               emailCtrl.clear();
//                               passCtrl.clear();
//                             },
//                             child:
//                                 loginVM.isLoginLoading
//                                     ? Icon(
//                                       LucideIcons.loader,
//                                       size: 18,
//                                       color: Colors.white,
//                                     )
//                                     : Text(
//                                       "Login",
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
//                               "New here? ",
//                               style: bodyStyle(13).copyWith(color: subtleText),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => const SignupScreen(),
//                                   ),
//                                 );
//                               },
//                               child: Text(
//                                 "Create an account",
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

// ----------------------------------- 22222222222222222222222 ---------------------------
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/features/auth/view/signup_screen.dart';
import 'package:wio_doctor/features/auth/view_model/login_viewmodel.dart';

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
            color: Colors.teal.withOpacity(0.65),
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
                color: Colors.teal.withOpacity(isDark ? 0.16 : 0.12),
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
                color: Colors.tealAccent.withOpacity(isDark ? 0.08 : 0.08),
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
                  Colors.teal.withOpacity(isDark ? 0.22 : 0.14),
                  Colors.cyanAccent.withOpacity(isDark ? 0.10 : 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.teal.withOpacity(isDark ? 0.35 : 0.18),
                width: 1.1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(isDark ? 0.22 : 0.10),
                  blurRadius: 30,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Container(
              height: 88,
              width: 88,
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
              color: Colors.teal.withOpacity(isDark ? 0.14 : 0.09),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.teal.withOpacity(isDark ? 0.25 : 0.14),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  LucideIcons.badgeCheck,
                  size: 15,
                  color: Colors.teal,
                ),
                const SizedBox(width: 8),
                Text(
                  "Secure Doctor Access",
                  style: GoogleFonts.exo(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.teal,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "Welcome back",
            textAlign: TextAlign.center,
            style: titleStyle(30),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Sign in to manage appointments, patients, and your daily workflow with ease.",
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

    Widget loginCard() {
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
                        fontWeight: FontWeight.w800,
                        color: Colors.teal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                Consumer<LoginViewmodel>(
                  builder: (context, loginVM, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: ShadButton(
                        height: 52,
                        backgroundColor: Colors.teal,
                        onPressed: () async {
                          if (loginVM.isLoginLoading) return;

                          await loginVM.login(
                            emailCtrl.text,
                            passCtrl.text,
                            context,
                          );

                          // emailCtrl.clear();
                          // passCtrl.clear();
                        },
                        child:
                            loginVM.isLoginLoading
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
                                  "Login",
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
                        "New here? ",
                        style: bodyStyle(13).copyWith(color: subtleText),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Create an account",
                          style: GoogleFonts.exo(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
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
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    topBrand(),
                    const SizedBox(height: 24),
                    loginCard(),
                    const SizedBox(height: 20),
                    Text(
                      "Trusted access for modern healthcare workflow",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.exo(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: subtleText,
                      ),
                    ),
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
