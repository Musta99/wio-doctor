import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/app_colors.dart';
import 'package:wio_doctor/core/theme/app_decoration.dart';
import 'package:wio_doctor/core/theme/app_text_styles.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';
import 'package:wio_doctor/features/dashboard/view_model/dashboard_view_model.dart';
import 'package:wio_doctor/features/profile/widget/header_card_widget.dart';
import 'package:wio_doctor/features/profile/widget/virtual_wio_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Basic info
  final fullNameC = TextEditingController(text: "Dr. Mustafizur Rahman");
  final emailC = TextEditingController(text: "doctor@example.com");
  final genderC = TextEditingController(text: "Male");
  final mobileC = TextEditingController(text: "+8801XXXXXXXXX");

  // Lists
  final List<String> countries = ["Bangladesh"];
  final List<String> languages = ["English", "বাংলা"];

  final addCountryC = TextEditingController();
  final addLanguageC = TextEditingController();

  // Professional
  final specialtyNameC = TextEditingController(text: "General Physician");
  final specialtyKeyC = TextEditingController(text: "GP-001");
  final hospitalNameC = TextEditingController(text: "City Hospital");
  final yearsExpC = TextEditingController(text: "3");

  // Education
  final educationDegreesC = TextEditingController(text: "MBBS");
  final additionalQualC = TextEditingController(text: "BCS (Health)");

  // Registration & Identity
  final regAuthorityC = TextEditingController(text: "BMDC");
  final regNumberC = TextEditingController(text: "A-12345");
  final nidC = TextEditingController(); // optional

  // Practice details
  final clinicAddressC = TextEditingController(text: "Chattogram, Bangladesh");
  final bioC = TextEditingController(
    text:
        "Dedicated to patient-centered care with a focus on preventive health and long-term wellness.",
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardViewModel>(context, listen: false).fetchDoctorData();
    });
  }

  @override
  void dispose() {
    fullNameC.dispose();
    emailC.dispose();
    genderC.dispose();
    mobileC.dispose();

    addCountryC.dispose();
    addLanguageC.dispose();

    specialtyNameC.dispose();
    specialtyKeyC.dispose();
    hospitalNameC.dispose();
    yearsExpC.dispose();

    educationDegreesC.dispose();
    additionalQualC.dispose();

    regAuthorityC.dispose();
    regNumberC.dispose();
    nidC.dispose();

    clinicAddressC.dispose();
    bioC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    final isDark = themeProvider.isDarkMode;

    Widget section({
      required IconData icon,
      required String title,
      required String subtitle,
      required Widget child,
    }) {
      return Container(
        decoration: AppDecorations.card(isDark),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.06)
                              : Colors.black.withOpacity(0.04),
                      border: Border.all(color: AppColors.border(isDark)),
                    ),
                    child: Icon(
                      icon,
                      size: 18,
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.88)
                              : Colors.black.withOpacity(0.80),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppTextStyles.section(14)),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: AppTextStyles.body(
                            13,
                          ).copyWith(color: AppColors.subtleText(isDark)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              child,
            ],
          ),
        ),
      );
    }

    Widget listAddRow({
      required TextEditingController controller,
      required String hint,
      required IconData icon,
      required VoidCallback onAdd,
    }) {
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTextStyles.body(14),
              decoration: AppDecorations.inputDec(hint, icon, isDark),
            ),
          ),
          const SizedBox(width: 10),
          ShadButton(
            backgroundColor: Colors.teal,
            onPressed: onAdd,
            child: Text(
              "Add",
              style: GoogleFonts.exo(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      );
    }

    Widget chipsList(List<String> items, {required IconData icon}) {
      if (items.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                isDark
                    ? Colors.white.withOpacity(0.04)
                    : const Color(0xFFF3F4F8),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border(isDark)),
          ),
          child: Text(
            "No items added yet.",
            style: AppTextStyles.body(
              13,
            ).copyWith(color: AppColors.subtleText(isDark)),
          ),
        );
      }

      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final item in items)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color:
                    isDark
                        ? Colors.white.withOpacity(0.05)
                        : const Color(0xFFF3F4F8),
                border: Border.all(color: AppColors.border(isDark)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 14, color: AppColors.subtleText(isDark)),
                  const SizedBox(width: 8),
                  Text(
                    item,
                    style: GoogleFonts.exo(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.88)
                              : Colors.black.withOpacity(0.82),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () {
                      setState(() => items.remove(item));
                    },
                    child: Icon(
                      LucideIcons.x,
                      size: 16,
                      color: AppColors.subtleText(isDark),
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: AppTextStyles.title(20)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: isDark ? "Switch to light" : "Switch to dark",
            icon: Icon(isDark ? LucideIcons.sun : LucideIcons.moon),
            onPressed: () {
              themeProvider.setThemeMode(
                isDark ? ThemeMode.light : ThemeMode.dark,
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bgTop(isDark), AppColors.bgBottom(isDark)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Virtual Wio Card
                VirtualWioCard(),
                const SizedBox(height: 14),
                HeaderCardWidget(
                  isDark: isDark,
                  fullName: fullNameC.text,
                  email: emailC.text,
                ),
                const SizedBox(height: 14),

                // 2) Basic Information
                section(
                  icon: LucideIcons.userRound,
                  title: "Basic Information",
                  subtitle: "Keep your personal info accurate for patients.",
                  child: Column(
                    children: [
                      TextField(
                        controller: fullNameC,
                        decoration: AppDecorations.inputDec(
                          "Full name",
                          LucideIcons.user,
                          isDark,
                        ),
                        style: AppTextStyles.body(14),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: emailC,
                        decoration: AppDecorations.inputDec(
                          "Email address",
                          LucideIcons.mail,
                          isDark,
                        ),
                        style: AppTextStyles.body(14),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: genderC,
                        decoration: AppDecorations.inputDec(
                          "Gender",
                          LucideIcons.users,
                          isDark,
                        ),
                        style: AppTextStyles.body(14),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: mobileC,
                        decoration: AppDecorations.inputDec(
                          "Mobile",
                          LucideIcons.phone,
                          isDark,
                        ),
                        style: AppTextStyles.body(14),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 14),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Countries",
                          style: GoogleFonts.exo(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      listAddRow(
                        controller: addCountryC,
                        hint: "Add country",
                        icon: LucideIcons.mapPin,
                        onAdd: () {
                          final v = addCountryC.text.trim();
                          if (v.isEmpty) return;
                          setState(() {
                            countries.add(v);
                            addCountryC.clear();
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      chipsList(countries, icon: LucideIcons.mapPin),

                      const SizedBox(height: 14),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Languages",
                          style: GoogleFonts.exo(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      listAddRow(
                        controller: addLanguageC,
                        hint: "Add language",
                        icon: LucideIcons.languages,
                        onAdd: () {
                          final v = addLanguageC.text.trim();
                          if (v.isEmpty) return;
                          setState(() {
                            languages.add(v);
                            addLanguageC.clear();
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      chipsList(languages, icon: LucideIcons.languages),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // 3) Professional Information
                section(
                  icon: LucideIcons.stethoscope,
                  title: "Professional Information",
                  subtitle: "Your practice and expertise details.",
                  child: Column(
                    children: [
                      TextField(
                        controller: specialtyNameC,
                        decoration: AppDecorations.inputDec(
                          "Specialty name",
                          LucideIcons.badgeCheck,
                          isDark,
                        ),
                        style: AppTextStyles.body(14),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: specialtyKeyC,
                        decoration: AppDecorations.inputDec(
                          "Specialty key",
                          LucideIcons.key,
                          isDark,
                        ),
                        style: AppTextStyles.body(14),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: hospitalNameC,
                        decoration: AppDecorations.inputDec(
                          "Hospital name",
                          LucideIcons.building2,
                          isDark,
                        ),
                        style: AppTextStyles.body(14),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: yearsExpC,
                        decoration: AppDecorations.inputDec(
                          "Years of experience",
                          LucideIcons.timer,
                          isDark,
                        ),
                        style: AppTextStyles.body(14),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // 4) Education & Qualification
                section(
                  icon: LucideIcons.graduationCap,
                  title: "Education & Qualification",
                  subtitle:
                      "Add education degrees and additional certifications.",
                  child: Column(
                    children: [
                      TextField(
                        controller: educationDegreesC,
                        decoration: AppDecorations.inputDec(
                          "Education degrees",
                          LucideIcons.graduationCap,
                          isDark,
                        ),
                        style: AppTextStyles.body(14),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: additionalQualC,
                        decoration: AppDecorations.inputDec(
                          "Additional qualifications",
                          LucideIcons.award,
                          isDark,
                        ),
                        style: AppTextStyles.body(14),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // 5) Registration & Identity
                section(
                  icon: LucideIcons.shieldCheck,
                  title: "Registration & Identity",
                  subtitle: "Registration details help maintain trust.",
                  child: Column(
                    children: [
                      TextField(
                        controller: regAuthorityC,
                        decoration: AppDecorations.inputDec(
                          "Registration authority",
                          LucideIcons.shield,
                          isDark,
                        ),
                        style: AppTextStyles.body(14),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: regNumberC,
                        decoration: AppDecorations.inputDec(
                          "Registration number",
                          LucideIcons.hash,
                          isDark,
                        ),
                        style: AppTextStyles.body(14),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: nidC,
                        decoration: AppDecorations.inputDec(
                          "NID number (optional)",
                          LucideIcons.idCard,
                          isDark,
                        ),
                        style: AppTextStyles.body(14),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // 6) Practice details
                section(
                  icon: LucideIcons.mapPinned,
                  title: "Practice Details",
                  subtitle: "Clinic address and professional bio for patients.",
                  child: Column(
                    children: [
                      TextField(
                        controller: clinicAddressC,
                        decoration: AppDecorations.inputDec(
                          "Clinic address",
                          LucideIcons.mapPin,
                          isDark,
                        ),
                        style: AppTextStyles.body(14),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: bioC,
                        decoration: AppDecorations.inputDec(
                          "Professional bio",
                          LucideIcons.filePenLine,
                          isDark,
                        ),
                        style: AppTextStyles.body(14),
                        maxLines: 4,
                      ),
                      const SizedBox(height: 16),
                      ShadButton(
                        width: double.infinity,
                        backgroundColor: Colors.teal,
                        onPressed: () {
                          // TODO: Save profile
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Saved (demo).")),
                          );
                        },
                        child: Text(
                          "Save changes",
                          style: GoogleFonts.exo(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _pill({
  //   required bool isDark,
  //   required Color borderColor,
  //   required Color subtleText,
  //   required IconData icon,
  //   required String text,
  // }) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  //     decoration: BoxDecoration(
  //       color:
  //           isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF3F4F8),
  //       borderRadius: BorderRadius.circular(999),
  //       border: Border.all(color: borderColor),
  //     ),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(icon, size: 14, color: subtleText),
  //         const SizedBox(width: 6),
  //         Text(
  //           text,
  //           style: GoogleFonts.exo(
  //             fontSize: 12,
  //             fontWeight: FontWeight.w900,
  //             color:
  //                 isDark
  //                     ? Colors.white.withOpacity(0.88)
  //                     : Colors.black.withOpacity(0.75),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
