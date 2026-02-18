import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/features/patient/view/patient_report_screen.dart';

/// ===============================
/// 1) CLINICAL REVIEW SCREEN
/// ===============================
class ClinicalReviewScreen extends StatefulWidget {
  const ClinicalReviewScreen({super.key});

  @override
  State<ClinicalReviewScreen> createState() => _ClinicalReviewScreenState();
}

class _ClinicalReviewScreenState extends State<ClinicalReviewScreen> {
  // Demo patient list
  final List<String> patients = const [
    "Sarah Jenkins (WIO-10234)",
    "Rahim Uddin (WIO-88421)",
    "Nusrat Jahan (WIO-22109)",
    "Ayesha Khan (WIO-55319)",
  ];
  String? selectedPatient;

  // Demo reports map
  final Map<String, List<_ReportItem>> patientReports = {
    "Sarah Jenkins (WIO-10234)": [
      _ReportItem(
        title: "CBC + HbA1c Report",
        date: "12 Feb 2026",
        source: "WIO Lab",
        status: "Reviewed",
        tagColor: Colors.teal,
      ),
      _ReportItem(
        title: "Lipid Profile",
        date: "28 Jan 2026",
        source: "City Diagnostics",
        status: "Pending",
        tagColor: Colors.orange,
      ),
    ],
    "Rahim Uddin (WIO-88421)": [
      _ReportItem(
        title: "Renal Function Panel",
        date: "05 Feb 2026",
        source: "WIO Lab",
        status: "Reviewed",
        tagColor: Colors.teal,
      ),
    ],
    "Nusrat Jahan (WIO-22109)": [
      _ReportItem(
        title: "Thyroid Profile",
        date: "02 Feb 2026",
        source: "Clinic Lab",
        status: "Reviewed",
        tagColor: Colors.teal,
      ),
      _ReportItem(
        title: "Vitamin D",
        date: "14 Jan 2026",
        source: "Clinic Lab",
        status: "Reviewed",
        tagColor: Colors.teal,
      ),
    ],
    "Ayesha Khan (WIO-55319)": [
      _ReportItem(
        title: "ECG Summary",
        date: "09 Feb 2026",
        source: "Clinic",
        status: "Pending",
        tagColor: Colors.orange,
      ),
    ],
  };

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

    TextStyle titleStyle(double s) =>
        GoogleFonts.exo(fontSize: s, fontWeight: FontWeight.w900);
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

    final reports =
        selectedPatient == null
            ? <_ReportItem>[]
            : (patientReports[selectedPatient] ?? const <_ReportItem>[]);

    return Scaffold(
      appBar: AppBar(
        title: Text("Clinical Review", style: titleStyle(18)),
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
              // Select patient
              Container(
                decoration: cardDecoration(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerRow(
                      icon: LucideIcons.userSearch,
                      title: "Select a patient to review",
                      subtitle:
                          "Choose a patient to see all available reports.",
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

              // Reports list
              Container(
                decoration: cardDecoration(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerRow(
                      icon: LucideIcons.file,
                      title: "Patient Reports",
                      subtitle:
                          selectedPatient == null
                              ? "Select a patient to view their reports."
                              : "Tap a report to open the health dashboard.",
                      accent: Colors.indigo,
                    ),
                    const SizedBox(height: 14),
                    if (selectedPatient == null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? Colors.white.withOpacity(0.04)
                                  : const Color(0xFFF3F4F8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor),
                        ),
                        child: Text(
                          "No patient selected yet.",
                          style: bodyStyle(13).copyWith(color: subtleText),
                        ),
                      ),
                    if (selectedPatient != null && reports.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? Colors.white.withOpacity(0.04)
                                  : const Color(0xFFF3F4F8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor),
                        ),
                        child: Text(
                          "No reports found for this patient.",
                          style: bodyStyle(13).copyWith(color: subtleText),
                        ),
                      ),
                    for (final r in reports)
                      InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder:
                          //         (_) => PatientHealthDashboardScreen(
                          //           patientName:
                          //               selectedPatient!.split(" (").first,
                          //           doctorName: "Dr. Alex Riveira",
                          //           reportDate: r.date,
                          //           reportTitle: r.title,
                          //         ),
                          //   ),
                          // );
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
                            border: Border.all(color: borderColor),
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
                                      r.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.exo(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${r.date} • ${r.source}",
                                      style: bodyStyle(
                                        12.5,
                                      ).copyWith(color: subtleText),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  color: r.tagColor.withOpacity(
                                    isDark ? 0.18 : 0.14,
                                  ),
                                  border: Border.all(
                                    color: r.tagColor.withOpacity(
                                      isDark ? 0.40 : 0.25,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  r.status,
                                  style: GoogleFonts.exo(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color:
                                        isDark
                                            ? Colors.white.withOpacity(0.9)
                                            : Colors.black.withOpacity(0.72),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                LucideIcons.chevronRight,
                                size: 18,
                                color: subtleText,
                              ),
                            ],
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
}

class _ReportItem {
  final String title;
  final String date;
  final String source;
  final String status;
  final Color tagColor;

  const _ReportItem({
    required this.title,
    required this.date,
    required this.source,
    required this.status,
    required this.tagColor,
  });
}
