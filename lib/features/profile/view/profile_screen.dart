import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/app_colors.dart';
import 'package:wio_doctor/core/theme/app_decoration.dart';
import 'package:wio_doctor/core/theme/app_text_styles.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';
import 'package:wio_doctor/features/profile/view_model/profile_view_model.dart';
import 'package:wio_doctor/features/profile/widget/header_card_widget.dart';
import 'package:wio_doctor/features/profile/widget/section_widget.dart';
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
      Provider.of<ProfileViewModel>(context, listen: false).fetchDoctorData();
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
    final themeProvider = context.read<ThemeViewModel>();
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: AppTextStyles.title(20)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bgTop(isDark), AppColors.bgBottom(isDark)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<ProfileViewModel>(
          builder: (context, profileVM, child) {
            if (profileVM.isLoadingDoctor) {
              return const Center(child: CircularProgressIndicator());
            }

            // if (!profileVM.hasDoctorData) {
            //   return const Center(child: Text("No profile data found"));
            // }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Virtual Wio Card
                    // VirtualWioCard(
                    //   name: profileVM.fullNameC.text,
                    //   wioId: profileVM.wioId,
                    // ),
                    // const SizedBox(height: 14),
                    HeaderCardWidget(
                      isDark: isDark,
                      fullName: profileVM.fullNameC.text,
                      email: profileVM.emailC.text,
                      photoUrl: profileVM.photo,
                    ),
                    const SizedBox(height: 14),

                    // 2) Basic Information
                    SectionWidget(
                      isDark: isDark,
                      icon: LucideIcons.userRound,
                      title: "Basic Information",
                      subTitle:
                          "Keep your personal info accurate for patients.",
                      child: Column(
                        children: [
                          TextField(
                            controller: profileVM.fullNameC,
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
                            readOnly: true,
                            controller: profileVM.emailC,
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
                            controller: profileVM.genderC,
                            decoration: AppDecorations.inputDec(
                              "Gender",
                              LucideIcons.users,
                              isDark,
                            ),
                            style: AppTextStyles.body(14),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: profileVM.mobileC,
                            decoration: AppDecorations.inputDec(
                              "Mobile",
                              LucideIcons.phone,
                              isDark,
                            ),
                            style: AppTextStyles.body(14),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 14),

                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Text(
                          //     "Countries",
                          //     style: GoogleFonts.exo(
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w900,
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(height: 10),
                          // listAddRow(
                          //   controller: addCountryC,
                          //   hint: "Add country",
                          //   icon: LucideIcons.mapPin,
                          //   onAdd: () {
                          //     final v = addCountryC.text.trim();
                          //     if (v.isEmpty) return;
                          //     setState(() {
                          //       countries.add(v);
                          //       addCountryC.clear();
                          //     });
                          //   },
                          // ),
                          // const SizedBox(height: 10),
                          // chipsList(countries, icon: LucideIcons.mapPin),
                          // const SizedBox(height: 14),

                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Text(
                          //     "Languages",
                          //     style: GoogleFonts.exo(
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w900,
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(height: 10),
                          // listAddRow(
                          //   controller: addLanguageC,
                          //   hint: "Add language",
                          //   icon: LucideIcons.languages,
                          //   onAdd: () {
                          //     final v = addLanguageC.text.trim();
                          //     if (v.isEmpty) return;
                          //     setState(() {
                          //       languages.add(v);
                          //       addLanguageC.clear();
                          //     });
                          //   },
                          // ),
                          // const SizedBox(height: 10),
                          // chipsList(languages, icon: LucideIcons.languages),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // 3) Professional Information
                    SectionWidget(
                      isDark: isDark,
                      icon: LucideIcons.stethoscope,
                      title: "Professional Information",
                      subTitle: "Your practice and expertise details.",
                      child: Column(
                        children: [
                          TextField(
                            controller: profileVM.specialityC,
                            decoration: AppDecorations.inputDec(
                              "Specialty name",
                              LucideIcons.badgeCheck,
                              isDark,
                            ),
                            style: AppTextStyles.body(14),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: profileVM.specialityC,
                            decoration: AppDecorations.inputDec(
                              "Specialty key",
                              LucideIcons.key,
                              isDark,
                            ),
                            style: AppTextStyles.body(14),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: profileVM.hospitalNameC,
                            decoration: AppDecorations.inputDec(
                              "Enter Hospital name",
                              LucideIcons.building2,
                              isDark,
                            ),
                            style: AppTextStyles.body(14),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: profileVM.yearsExpC,
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
                    SectionWidget(
                      isDark: isDark,
                      icon: LucideIcons.graduationCap,
                      title: "Education & Qualification",
                      subTitle:
                          "Add education degrees and additional certifications.",
                      child: Column(
                        children: [
                          TextField(
                            controller: profileVM.educationDegreeC,
                            decoration: AppDecorations.inputDec(
                              "Education degrees",
                              LucideIcons.graduationCap,
                              isDark,
                            ),
                            style: AppTextStyles.body(14),
                          ),
                          // const SizedBox(height: 12),
                          // TextField(
                          //   controller: additionalQualC,
                          //   decoration: AppDecorations.inputDec(
                          //     "Additional qualifications",
                          //     LucideIcons.award,
                          //     isDark,
                          //   ),
                          //   style: AppTextStyles.body(14),
                          //   maxLines: 2,
                          // ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // 5) Registration & Identity
                    SectionWidget(
                      isDark: isDark,
                      icon: LucideIcons.shieldCheck,
                      title: "Registration & Identity",
                      subTitle: "Registration details help maintain trust.",
                      child: Column(
                        children: [
                          TextField(
                            controller: profileVM.regAuthorityC,
                            decoration: AppDecorations.inputDec(
                              "Registration authority",
                              LucideIcons.shield,
                              isDark,
                            ),
                            style: AppTextStyles.body(14),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: profileVM.regNumberC,
                            decoration: AppDecorations.inputDec(
                              "Registration number",
                              LucideIcons.hash,
                              isDark,
                            ),
                            style: AppTextStyles.body(14),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: profileVM.nidC,
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
                    SectionWidget(
                      isDark: isDark,

                      icon: LucideIcons.mapPinned,
                      title: "Practice Details",
                      subTitle:
                          "Clinic address and professional bio for patients.",
                      child: Column(
                        children: [
                          TextField(
                            controller: profileVM.clinicNameC,
                            decoration: AppDecorations.inputDec(
                              "Clinic address",
                              LucideIcons.mapPin,
                              isDark,
                            ),
                            style: AppTextStyles.body(14),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: profileVM.bioC,
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
                            backgroundColor:
                                profileVM.isProfileChanged
                                    ? Colors.teal
                                    : Colors.grey,
                            onPressed:
                                !profileVM.isProfileChanged ||
                                        profileVM.isUpdatingData
                                    ? null
                                    : () async {
                                      await profileVM.updateProfileData();
                                    },
                            child:
                                profileVM.isUpdatingData
                                    ? Icon(LucideIcons.loader, size: 22)
                                    : Text(
                                      "Save changes",
                                      style: GoogleFonts.exo(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Consumer<ProfileViewModel>(
                      builder: (context, vm, child) {
                        return ShadButton(
                          width: double.infinity,
                          backgroundColor: Colors.red,
                          onPressed:
                              vm.isLogoutLoading
                                  ? null // disable while loading
                                  : () => vm.userLogout(context),

                          child:
                              vm.isLogoutLoading
                                  ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        "Logging out...",
                                        style: GoogleFonts.exo(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                  : Text(
                                    "Logout",
                                    style: GoogleFonts.exo(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
