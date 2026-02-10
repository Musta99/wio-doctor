import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DigitalPrescriberScreen extends StatefulWidget {
  const DigitalPrescriberScreen({super.key});

  @override
  State<DigitalPrescriberScreen> createState() =>
      _DigitalPrescriberScreenState();
}

class _DigitalPrescriberScreenState extends State<DigitalPrescriberScreen> {
  // Patient dropdown demo
  final List<String> patients = const [
    "Sarah Jenkins (WIO-10234)",
    "Rahim Uddin (WIO-88421)",
    "Nusrat Jahan (WIO-22109)",
    "Ayesha Khan (WIO-55319)",
  ];
  String? selectedPatient;

  // Medication dynamic list
  final List<_MedRow> meds = [];

  // Additional info
  final testsCtrl = TextEditingController();
  final suggestionCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // one default row
    meds.add(_MedRow());
  }

  @override
  void dispose() {
    for (final m in meds) {
      m.dispose();
    }
    testsCtrl.dispose();
    suggestionCtrl.dispose();
    super.dispose();
  }

  void _addMed() {
    setState(() => meds.add(_MedRow()));
  }

  void _removeMed(int i) {
    if (meds.length == 1) return; // keep at least 1
    setState(() {
      meds[i].dispose();
      meds.removeAt(i);
    });
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
    TextStyle sectionStyle(double s) =>
        GoogleFonts.exo(fontSize: s, fontWeight: FontWeight.w900);
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

    InputDecoration inputDec({required String hint, required IconData icon}) {
      return InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.exo(
          color: subtleText,
          fontWeight: FontWeight.w700,
          fontSize: 13,
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

    Widget headerRow({
      required IconData icon,
      required String title,
      required String subtitle,
      Color accent = Colors.teal,
    }) {
      return Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: accent.withOpacity(isDark ? 0.14 : 0.10),
              border: Border.all(
                color: accent.withOpacity(isDark ? 0.25 : 0.18),
              ),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: sectionStyle(16)),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: bodyStyle(12.5).copyWith(color: subtleText),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget pillToggle({
      required String text,
      required bool active,
      required VoidCallback onTap,
    }) {
      return InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color:
                active
                    ? Colors.teal.withOpacity(isDark ? 0.22 : 0.16)
                    : (isDark
                        ? Colors.white.withOpacity(0.04)
                        : const Color(0xFFF3F4F8)),
            border: Border.all(
              color:
                  active
                      ? Colors.teal.withOpacity(isDark ? 0.55 : 0.40)
                      : borderColor,
            ),
          ),
          child: Text(
            text,
            style: GoogleFonts.exo(
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
              color:
                  active
                      ? (isDark
                          ? Colors.white.withOpacity(0.95)
                          : const Color(0xFF0F172A))
                      : (isDark
                          ? Colors.white.withOpacity(0.80)
                          : Colors.black.withOpacity(0.70)),
            ),
          ),
        ),
      );
    }

    // Dropdown container (aesthetic)
    Widget dropdownBox({
      required IconData icon,
      required String hint,
      required String? value,
      required List<String> items,
      required ValueChanged<String?> onChanged,
    }) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF3F4F8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: subtleText),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: value,
                  hint: Text(
                    hint,
                    style: GoogleFonts.exo(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: subtleText,
                    ),
                  ),
                  icon: Icon(
                    LucideIcons.chevronDown,
                    size: 18,
                    color: subtleText,
                  ),
                  items:
                      items
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: GoogleFonts.exo(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Instruction dropdown for each medicine row
    Widget instructionDropdown({required _MedRow med}) {
      const options = ["After food", "Before food", "With food"];
      return dropdownBox(
        icon: LucideIcons.list,
        hint: "Instruction",
        value: med.instruction,
        items: options,
        onChanged: (v) => setState(() => med.instruction = v),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Digital Prescriber", style: titleStyle(18)),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [bgTop, bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PATIENT INFO
              Container(
                decoration: cardDecoration(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerRow(
                      icon: LucideIcons.user,
                      title: "Patient Information",
                      subtitle: "Select a patient to create a prescription.",
                      accent: Colors.teal,
                    ),
                    const SizedBox(height: 14),
                    dropdownBox(
                      icon: LucideIcons.users,
                      hint: "Select patient",
                      value: selectedPatient,
                      items: patients,
                      onChanged: (v) => setState(() => selectedPatient = v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // MEDICATIONS
              Container(
                decoration: cardDecoration(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: headerRow(
                            icon: LucideIcons.pill,
                            title: "Medications",
                            subtitle:
                                "Add medicines with dosage & instructions.",
                            accent: const Color(0xFF8B5CF6),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: _addMed,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              color:
                                  isDark
                                      ? Colors.white.withOpacity(0.06)
                                      : Colors.black.withOpacity(0.05),
                              border: Border.all(color: borderColor),
                            ),
                            child: Icon(
                              LucideIcons.plus,
                              size: 18,
                              color:
                                  isDark
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.black.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // rows
                    for (int i = 0; i < meds.length; i++)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? Colors.white.withOpacity(0.04)
                                  : const Color(0xFFF3F4F8),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // row header
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Medicine ${i + 1}",
                                    style: GoogleFonts.exo(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () => _removeMed(i),
                                  child: Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.red.withOpacity(
                                        isDark ? 0.14 : 0.10,
                                      ),
                                      border: Border.all(
                                        color: Colors.red.withOpacity(
                                          isDark ? 0.35 : 0.22,
                                        ),
                                      ),
                                    ),
                                    child: const Icon(
                                      LucideIcons.trash2,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            TextField(
                              controller: meds[i].name,
                              style: bodyStyle(14),
                              decoration: inputDec(
                                hint: "Medicine name (e.g., Paracetamol)",
                                icon: LucideIcons.pill,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: meds[i].strength,
                                    style: bodyStyle(14),
                                    decoration: inputDec(
                                      hint: "Strength (e.g., 500mg)",
                                      icon: LucideIcons.flaskConical,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: meds[i].duration,
                                    style: bodyStyle(14),
                                    decoration: inputDec(
                                      hint: "Duration (e.g., 5 days)",
                                      icon: LucideIcons.calendarClock,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "Timing",
                              style: GoogleFonts.exo(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w900,
                                color: subtleText,
                              ),
                            ),
                            const SizedBox(height: 8),

                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                pillToggle(
                                  text: "Morning",
                                  active: meds[i].morning,
                                  onTap:
                                      () => setState(
                                        () =>
                                            meds[i].morning = !meds[i].morning,
                                      ),
                                ),
                                pillToggle(
                                  text: "Noon",
                                  active: meds[i].noon,
                                  onTap:
                                      () => setState(
                                        () => meds[i].noon = !meds[i].noon,
                                      ),
                                ),
                                pillToggle(
                                  text: "Night",
                                  active: meds[i].night,
                                  onTap:
                                      () => setState(
                                        () => meds[i].night = !meds[i].night,
                                      ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            instructionDropdown(med: meds[i]),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ADDITIONAL INFO
              Container(
                decoration: cardDecoration(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerRow(
                      icon: LucideIcons.clipboardList,
                      title: "Additional Information",
                      subtitle: "Recommended tests and extra suggestions.",
                      accent: Colors.indigo,
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: testsCtrl,
                      maxLines: 3,
                      style: bodyStyle(14),
                      decoration: inputDec(
                        hint: "Recommended tests (e.g., CBC, ECG, HbA1c)",
                        icon: LucideIcons.flaskRound,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: suggestionCtrl,
                      maxLines: 3,
                      style: bodyStyle(14),
                      decoration: inputDec(
                        hint:
                            "Additional suggestions (diet, exercise, follow-up...)",
                        icon: LucideIcons.messageSquareText,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ACTIONS
              Container(
                decoration: cardDecoration(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ShadButton(
                      width: double.infinity,
                      backgroundColor:
                          isDark
                              ? Colors.white.withOpacity(0.06)
                              : const Color(0xFFF3F4F8),
                      onPressed: () {
                        // TODO: Preview prescription as PDF/Image
                      },
                      child: Text(
                        "Preview",
                        style: GoogleFonts.exo(
                          fontWeight: FontWeight.w900,
                          color:
                              isDark
                                  ? Colors.white.withOpacity(0.9)
                                  : Colors.black.withOpacity(0.85),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ShadButton(
                      width: double.infinity,
                      backgroundColor: Colors.teal,
                      onPressed: () {
                        // TODO: Save prescription
                      },
                      child: Text(
                        "Save",
                        style: GoogleFonts.exo(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
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
    );
  }
}

class _MedRow {
  final name = TextEditingController();
  final strength = TextEditingController();
  final duration = TextEditingController();

  bool morning = false;
  bool noon = false;
  bool night = false;

  String? instruction;

  void dispose() {
    name.dispose();
    strength.dispose();
    duration.dispose();
  }
}
