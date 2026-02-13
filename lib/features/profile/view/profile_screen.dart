import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';
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

    final bgTop = isDark ? const Color(0xFF0B1220) : const Color(0xFFF7F8FC);
    final bgBottom = isDark ? const Color(0xFF060A12) : const Color(0xFFFFFFFF);

    final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor =
        isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.06);
    final subtleText =
        isDark
            ? Colors.white.withOpacity(0.72)
            : Colors.black.withOpacity(0.65);

    TextStyle titleStyle(double size) => GoogleFonts.exo(
      fontWeight: FontWeight.w900,
      fontSize: size,
      letterSpacing: -0.2,
    );

    TextStyle sectionStyle(double size) =>
        GoogleFonts.exo(fontWeight: FontWeight.w900, fontSize: size);

    TextStyle bodyStyle(double size) =>
        GoogleFonts.exo(fontWeight: FontWeight.w500, fontSize: size);

    BoxDecoration cardDecoration() {
      return BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withOpacity(0.38)
                    : Colors.black.withOpacity(0.07),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      );
    }

    InputDecoration inputDec(String hint, IconData icon) {
      return InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.exo(
          color: subtleText,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(icon, size: 18),
        filled: true,
        fillColor:
            isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF3F4F8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.teal.withOpacity(0.6)),
        ),
      );
    }

    Widget headerCard() {
      return Container(
        decoration: cardDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    height: 84,
                    width: 84,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.06)
                              : Colors.black.withOpacity(0.06),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.32 : 0.10),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        LucideIcons.userRound,
                        size: 34,
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.9)
                                : Colors.black.withOpacity(0.75),
                      ),
                    ),
                  ),

                  // ✅ plus/pen icon for image update
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () {
                        // TODO: open image picker
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          LucideIcons.penLine,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullNameC.text.isEmpty
                          ? "Doctor Profile"
                          : fullNameC.text,
                      style: titleStyle(18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      emailC.text.isEmpty ? "Add email address" : emailC.text,
                      style: bodyStyle(13).copyWith(color: subtleText),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _pill(
                          isDark: isDark,
                          borderColor: borderColor,
                          subtleText: subtleText,
                          icon: LucideIcons.shieldCheck,
                          text: "Doctor",
                        ),
                        const SizedBox(width: 8),
                        _pill(
                          isDark: isDark,
                          borderColor: borderColor,
                          subtleText: subtleText,
                          icon: LucideIcons.heartPulse,
                          text: "Healthcare",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget section({
      required IconData icon,
      required String title,
      required String subtitle,
      required Widget child,
    }) {
      return Container(
        decoration: cardDecoration(),
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
                      border: Border.all(color: borderColor),
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
                        Text(title, style: sectionStyle(18)),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: bodyStyle(13).copyWith(color: subtleText),
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
              style: bodyStyle(14),
              decoration: inputDec(hint, icon),
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
            border: Border.all(color: borderColor),
          ),
          child: Text(
            "No items added yet.",
            style: bodyStyle(13).copyWith(color: subtleText),
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
                border: Border.all(color: borderColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 14, color: subtleText),
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
                    child: Icon(LucideIcons.x, size: 16, color: subtleText),
                  ),
                ],
              ),
            ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: titleStyle(20)),
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
            colors: [bgTop, bgBottom],
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
                headerCard(),
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
                        decoration: inputDec("Full name", LucideIcons.user),
                        style: bodyStyle(14),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: emailC,
                        decoration: inputDec("Email address", LucideIcons.mail),
                        style: bodyStyle(14),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: genderC,
                        decoration: inputDec("Gender", LucideIcons.users),
                        style: bodyStyle(14),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: mobileC,
                        decoration: inputDec("Mobile", LucideIcons.phone),
                        style: bodyStyle(14),
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
                        decoration: inputDec(
                          "Specialty name",
                          LucideIcons.badgeCheck,
                        ),
                        style: bodyStyle(14),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: specialtyKeyC,
                        decoration: inputDec("Specialty key", LucideIcons.key),
                        style: bodyStyle(14),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: hospitalNameC,
                        decoration: inputDec(
                          "Hospital name",
                          LucideIcons.building2,
                        ),
                        style: bodyStyle(14),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: yearsExpC,
                        decoration: inputDec(
                          "Years of experience",
                          LucideIcons.timer,
                        ),
                        style: bodyStyle(14),
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
                        decoration: inputDec(
                          "Education degrees",
                          LucideIcons.graduationCap,
                        ),
                        style: bodyStyle(14),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: additionalQualC,
                        decoration: inputDec(
                          "Additional qualifications",
                          LucideIcons.award,
                        ),
                        style: bodyStyle(14),
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
                        decoration: inputDec(
                          "Registration authority",
                          LucideIcons.shield,
                        ),
                        style: bodyStyle(14),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: regNumberC,
                        decoration: inputDec(
                          "Registration number",
                          LucideIcons.hash,
                        ),
                        style: bodyStyle(14),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: nidC,
                        decoration: inputDec(
                          "NID number (optional)",
                          LucideIcons.idCard,
                        ),
                        style: bodyStyle(14),
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
                        decoration: inputDec(
                          "Clinic address",
                          LucideIcons.mapPin,
                        ),
                        style: bodyStyle(14),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: bioC,
                        decoration: inputDec(
                          "Professional bio",
                          LucideIcons.filePenLine,
                        ),
                        style: bodyStyle(14),
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

  Widget _pill({
    required bool isDark,
    required Color borderColor,
    required Color subtleText,
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF3F4F8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: subtleText),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.exo(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color:
                  isDark
                      ? Colors.white.withOpacity(0.88)
                      : Colors.black.withOpacity(0.75),
            ),
          ),
        ],
      ),
    );
  }
}
