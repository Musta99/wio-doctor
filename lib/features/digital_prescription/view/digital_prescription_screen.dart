import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/app_colors.dart';
import 'package:wio_doctor/core/theme/app_decoration.dart';
import 'package:wio_doctor/core/theme/app_text_styles.dart';
import 'package:wio_doctor/features/digital_prescription/view_model/digital_prescription_view_model.dart';

class DigitalPrescriberScreen extends StatefulWidget {
  const DigitalPrescriberScreen({super.key});

  @override
  State<DigitalPrescriberScreen> createState() =>
      _DigitalPrescriberScreenState();
}

class _DigitalPrescriberScreenState extends State<DigitalPrescriberScreen> {
  // Medication dynamic list
  final List<_MedRow> meds = [];

  // Additional info
  final testsCtrl = TextEditingController();
  final suggestionCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DigitalPrescriptionViewModel>(
        context,
        listen: false,
      ).fetchGrantedPatientsList(context);
    });
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                Text(title, style: AppTextStyles.section(16)),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.body(
                    15,
                  ).copyWith(color: AppColors.subtleText(isDark)),
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
                      : AppColors.border(isDark),
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
          border: Border.all(color: AppColors.border(isDark)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.subtleText(isDark)),
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
                      color: AppColors.subtleText(isDark),
                    ),
                  ),
                  icon: Icon(
                    LucideIcons.chevronDown,
                    size: 18,
                    color: AppColors.subtleText(isDark),
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Digital Prescriber", style: AppTextStyles.title(18)),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bgTop(isDark), AppColors.bgBottom(isDark)],
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
                decoration: AppDecorations.card(isDark),
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
                    Consumer<DigitalPrescriptionViewModel>(
                      builder: (context, vm, child) {
                        /// Loading state
                        if (vm.isLoadingPatientsList &&
                            vm.grantedPatientList.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        /// Empty state
                        if (vm.grantedPatientList.isEmpty) {
                          return const Text("No patients available");
                        }

                        /// Convert API → dropdown text
                        final patients =
                            vm.grantedPatientList.map((p) {
                              final name = p["patientName"] ?? "Unknown";
                              return "$name";
                            }).toList();

                        return dropdownBox(
                          icon: LucideIcons.users,
                          hint: "Select patient",
                          value: vm.selectedPatient,
                          items: patients,
                          onChanged: (v) {
                            vm.selectPatient(v);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // MEDICATIONS
              Consumer<DigitalPrescriptionViewModel>(
                builder: (context, vm, child) {
                  return Container(
                    decoration: AppDecorations.card(isDark),
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

                            /// ADD MEDICINE
                            InkWell(
                              borderRadius: BorderRadius.circular(999),
                              onTap: vm.addMed, // ✅ use ViewModel
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color:
                                      isDark
                                          ? Colors.white.withOpacity(0.06)
                                          : Colors.black.withOpacity(0.05),
                                  border: Border.all(
                                    color: AppColors.border(isDark),
                                  ),
                                ),
                                child: Icon(LucideIcons.plus, size: 18),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        /// MEDICINE ROWS
                        for (int i = 0; i < vm.meds.length; i++)
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color:
                                  isDark
                                      ? Colors.white.withOpacity(0.04)
                                      : const Color(0xFFF3F4F8),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: AppColors.border(isDark),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// HEADER
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

                                    /// REMOVE MED
                                    InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () => vm.removeMed(i), // ✅
                                      child: Container(
                                        padding: const EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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

                                /// NAME
                                TextField(
                                  controller: vm.meds[i].name,
                                  style: AppTextStyles.body(14),
                                  decoration: AppDecorations.inputDec(
                                    "Medicine name (e.g., Paracetamol)",
                                    LucideIcons.pill,
                                    isDark,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                /// STRENGTH + DURATION
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: vm.meds[i].strength,
                                        style: AppTextStyles.body(14),
                                        decoration: AppDecorations.inputDec(
                                          "Strength (e.g., 500mg)",
                                          LucideIcons.flaskConical,
                                          isDark,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: vm.meds[i].duration,
                                        style: AppTextStyles.body(14),
                                        decoration: AppDecorations.inputDec(
                                          "Duration (e.g., 5 days)",
                                          LucideIcons.calendarClock,
                                          isDark,
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
                                    color: AppColors.subtleText(isDark),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                /// TIMING TOGGLES
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    pillToggle(
                                      text: "Morning",
                                      active: vm.meds[i].morning,
                                      onTap: () => vm.toggleMorning(i), // ✅
                                    ),
                                    pillToggle(
                                      text: "Noon",
                                      active: vm.meds[i].noon,
                                      onTap: () => vm.toggleNoon(i), // ✅
                                    ),
                                    pillToggle(
                                      text: "Night",
                                      active: vm.meds[i].night,
                                      onTap: () => vm.toggleNight(i), // ✅
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                /// INSTRUCTION
                                dropdownBox(
                                  icon: LucideIcons.list,
                                  hint: "Instruction",
                                  value: vm.meds[i].instruction,
                                  items: const [
                                    "After food",
                                    "Before food",
                                    "With food",
                                  ],
                                  onChanged:
                                      (v) => vm.setInstruction(i, v), // ✅
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),

              // ADDITIONAL INFO
              Container(
                decoration: AppDecorations.card(isDark),
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
                      style: AppTextStyles.body(14),
                      decoration: AppDecorations.inputDec(
                        "Recommended tests (e.g., CBC, ECG, HbA1c)",
                        LucideIcons.flaskRound,
                        isDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: suggestionCtrl,
                      maxLines: 3,
                      style: AppTextStyles.body(14),
                      decoration: AppDecorations.inputDec(
                        "Additional suggestions (diet, exercise, follow-up...)",
                        LucideIcons.messageSquareText,
                        isDark,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ACTIONS
              Container(
                decoration: AppDecorations.card(isDark),
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
