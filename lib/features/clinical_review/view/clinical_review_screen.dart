import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/app_colors.dart';
import 'package:wio_doctor/core/theme/app_decoration.dart';
import 'package:wio_doctor/core/theme/app_text_styles.dart';
import 'package:wio_doctor/features/clinical_review/view_model/clinical_review_view_model.dart';
import 'package:wio_doctor/features/digital_prescription/view_model/digital_prescription_view_model.dart';
import 'package:wio_doctor/features/patient/view/patient_report_screen.dart';
import 'package:wio_doctor/widgets/dropdown_box_widget.dart';
import 'package:wio_doctor/widgets/header_row_widget.dart';

/// ===============================
/// 1) CLINICAL REVIEW SCREEN
/// ===============================
class ClinicalReviewScreen extends StatefulWidget {
  const ClinicalReviewScreen({super.key});

  @override
  State<ClinicalReviewScreen> createState() => _ClinicalReviewScreenState();
}

class _ClinicalReviewScreenState extends State<ClinicalReviewScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DigitalPrescriptionViewModel>(
        context,
        listen: false,
      ).fetchGrantedPatientsList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Clinical Review", style: AppTextStyles.title(18)),
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
              // Select patient
              Container(
                decoration: AppDecorations.card(isDark),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderRowWidget(
                      icon: LucideIcons.userSearch,
                      title: "Select a patient to review",
                      subTitle:
                          "Choose a patient to see all available reports.",
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

                        /// Map patient objects
                        final patientList =
                            vm.grantedPatientList
                                .map(
                                  (p) => {
                                    "name": p["patientName"] ?? "Unknown",
                                    "id": p["patientId"] ?? "",
                                  },
                                )
                                .toList();

                        /// Dropdown text list (only names)
                        final List<String> patientNames =
                            vm.grantedPatientList
                                .map<String>(
                                  (p) =>
                                      (p["patientName"] ?? "Unknown")
                                          .toString(),
                                )
                                .toList();

                        /// Current selected name
                        final selectedName = vm.selectedPatient?["name"];

                        return DropdownBoxWidget(
                          icon: LucideIcons.users,
                          hint: "Select patient",
                          value: selectedName,
                          items: patientNames,
                          onChanged: (v) {
                            if (v == null) return;
                            // Find the selected patient map by name
                            final selected = patientList.firstWhere(
                              (p) => p["name"] == v,
                            );
                            vm.selectPatient(selected);

                            Provider.of<ClinicalReviewViewModel>(
                              context,
                              listen: false,
                            ).fetchPatientReports(vm.selectedPatient!["id"]);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Reports list
              Container(
                decoration: AppDecorations.card(isDark),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderRowWidget(
                      icon: LucideIcons.file,
                      title: "Patient Reports",
                      subTitle:
                          Provider.of<DigitalPrescriptionViewModel>(
                                    context,
                                  ).selectedPatient ==
                                  null
                              ? "Select a patient to view their reports."
                              : "Tap a report to open the health dashboard.",
                    ),
                    const SizedBox(height: 14),
                    if (Provider.of<DigitalPrescriptionViewModel>(
                          context,
                        ).selectedPatient ==
                        null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? Colors.white.withOpacity(0.04)
                                  : const Color(0xFFF3F4F8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border(isDark)),
                        ),
                        child: Text(
                          "No patient selected yet.",
                          style: AppTextStyles.body(
                            13,
                          ).copyWith(color: AppColors.subtleText(isDark)),
                        ),
                      ),
                    if (Provider.of<DigitalPrescriptionViewModel>(
                              context,
                            ).selectedPatient !=
                            null &&
                        Provider.of<ClinicalReviewViewModel>(
                          context,
                        ).reportsList.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? Colors.white.withOpacity(0.04)
                                  : const Color(0xFFF3F4F8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border(isDark)),
                        ),
                        child: Text(
                          "No reports found for this patient.",
                          style: AppTextStyles.body(
                            13,
                          ).copyWith(color: AppColors.subtleText(isDark)),
                        ),
                      ),

                    if (Provider.of<ClinicalReviewViewModel>(
                      context,
                    ).isReportFetchLoading)
                      SizedBox(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.teal),
                        ),
                      ),

                    for (final r
                        in Provider.of<ClinicalReviewViewModel>(
                          context,
                        ).reportsList)
                      InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => PatientHealthDashboardScreen(
                                    patientId:
                                        Provider.of<
                                          DigitalPrescriptionViewModel
                                        >(context).selectedPatient!["id"],
                                    reportId: r["id"],
                                  ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color:
                                isDark
                                    ? Colors.white.withOpacity(0.04)
                                    : const Color(0xFFF3F4F8),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.border(isDark)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.teal.withOpacity(
                                    isDark ? 0.14 : 0.10,
                                  ),
                                  border: Border.all(
                                    color: Colors.teal.withOpacity(
                                      isDark ? 0.25 : 0.18,
                                    ),
                                  ),
                                ),
                                child: Icon(
                                  LucideIcons.fileText,
                                  size: 18,
                                  color:
                                      isDark
                                          ? Colors.tealAccent.withOpacity(0.9)
                                          : Colors.teal,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r["type"],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.exo(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${r["date"]} •",
                                      style: AppTextStyles.body(12.5).copyWith(
                                        color: AppColors.subtleText(isDark),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),

                              const SizedBox(width: 8),
                              Icon(
                                LucideIcons.chevronRight,
                                size: 18,
                                color: AppColors.subtleText(isDark),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              if (Provider.of<ClinicalReviewViewModel>(
                context,
              ).reportsList.isNotEmpty)
                Consumer<ClinicalReviewViewModel>(
                  builder: (context, clinicalVM, child) {
                    return ShadButton(
                      backgroundColor: Colors.teal,
                      pressedBackgroundColor: Colors.teal,
                      width: double.infinity,
                      onPressed: () async {
                        await clinicalVM.analyzingReports(
                          clinicalVM.reportsList,
                        );
                      },
                      child: Text(
                        "Start Wio Review",
                        style: AppTextStyles.section(
                          16,
                        ).copyWith(color: Colors.white),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
