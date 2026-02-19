import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/features/patient/view_model/patient_view_model.dart';

class PatientHealthDashboardScreen extends StatefulWidget {
  final String patientId;
  final String reportId;

  const PatientHealthDashboardScreen({
    super.key,
    required this.patientId,
    required this.reportId,
  });

  @override
  State<PatientHealthDashboardScreen> createState() =>
      _PatientHealthDashboardScreenState();
}

class _PatientHealthDashboardScreenState
    extends State<PatientHealthDashboardScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PatientViewModel>(
        context,
        listen: false,
      ).fetchReportDetails(widget.patientId, widget.reportId);
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

    Widget sectionHeader({
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

    Widget chip({required String text, required Color accent}) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: accent.withOpacity(isDark ? 0.18 : 0.14),
          border: Border.all(color: accent.withOpacity(isDark ? 0.40 : 0.25)),
        ),
        child: Text(
          text,
          style: GoogleFonts.exo(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color:
                isDark
                    ? Colors.white.withOpacity(0.9)
                    : Colors.black.withOpacity(0.72),
          ),
        ),
      );
    }

    // Demo content
    final summary =
        "Overall labs suggest mild dyslipidemia with elevated LDL, and borderline HbA1c. Renal markers are within normal range.";
    final majorIssue = "Elevated LDL cholesterol";
    final minorIssue = "Borderline HbA1c";
    final interpretation =
        "The results indicate increased cardiovascular risk due to lipid imbalance. Lifestyle changes are recommended, and consider follow-up lipid profile in 8–12 weeks.";

    final labRows = const [
      _LabRow("HbA1c", "6.1", "%", "4.0–5.6"),
      _LabRow("LDL", "158", "mg/dL", "< 100"),
      _LabRow("HDL", "42", "mg/dL", "> 40"),
      _LabRow("Triglycerides", "180", "mg/dL", "< 150"),
      _LabRow("Creatinine", "0.9", "mg/dL", "0.6–1.2"),
    ];

    final favorFoods = const [
      "Leafy greens, vegetables",
      "Whole grains (oats, brown rice)",
      "Fish, lean protein",
      "Nuts, seeds (in moderation)",
      "High-fiber fruits",
    ];

    final limitFoods = const [
      "Fried foods & trans fats",
      "Sugary drinks & sweets",
      "Refined carbs (white bread)",
      "Processed meats",
      "Excess salt",
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Health Dashboard", style: titleStyle(17)),
        centerTitle: true,
      ),
      body: Consumer<PatientViewModel>(
        builder: (context, patientDetailsVM, child) {
          if (patientDetailsVM.isLoadingReportFetch) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }

          return Container(
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
                  // Header section: patient name, doctor name, date
                  Container(
                    decoration: cardDecoration(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionHeader(
                          icon: LucideIcons.shieldCheck,
                          title:
                              patientDetailsVM
                                  .reportDetails?["analysis"]?["patientName"] ??
                              "Patient A",
                          subtitle:
                              "${patientDetailsVM.reportDetails?["analysis"]?["doctorName"] ?? "Doctor"} • ${patientDetailsVM.reportDetails?["analysis"]?["reportDate"] ?? "Date"}",
                          accent: Colors.teal,
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
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
                              Icon(
                                LucideIcons.fileText,
                                size: 18,
                                color: subtleText,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Report by ${patientDetailsVM.reportDetails?["provider"] ?? "Provider"}",
                                  style: GoogleFonts.exo(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Summary
                  Container(
                    decoration: cardDecoration(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionHeader(
                          icon: LucideIcons.alignCenterHorizontal,
                          title: "Summary",
                          subtitle: "Short overview of the report.",
                          accent: Colors.indigo,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          patientDetailsVM
                                  .reportDetails?["analysis"]?["finalSummary"]?["en"] ??
                              "Summary",
                          style: bodyStyle(13.5).copyWith(
                            color:
                                isDark
                                    ? Colors.white.withOpacity(0.85)
                                    : Colors.black.withOpacity(0.78),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Key findings ---- Major Issues & Minor Issues
                  Container(
                    decoration: cardDecoration(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionHeader(
                          icon: LucideIcons.circleCheck,
                          title: "Key Findings",
                          subtitle: "Major & minor issues extracted from labs.",
                          accent: Colors.orange,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
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
                              Text(
                                "Major issue",
                                style: bodyStyle(
                                  12.5,
                                ).copyWith(color: subtleText),
                              ),
                              const SizedBox(height: 6),
                              // Extract majorIssues list safely
                              Builder(
                                builder: (_) {
                                  final majorIssues =
                                      (patientDetailsVM
                                              .reportDetails?["analysis"]?["majorIssues"]
                                          as List?) ??
                                      [];
                                  return majorIssues.isEmpty
                                      ? chip(
                                        text: "No Major issues found",
                                        accent: Colors.grey,
                                      )
                                      : Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children:
                                            majorIssues
                                                .map(
                                                  (issue) => chip(
                                                    text:
                                                        (issue as Map)?["en"] ??
                                                        "-",
                                                    accent: Colors.red,
                                                  ),
                                                )
                                                .toList(),
                                      );
                                },
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Minor issue",
                                style: bodyStyle(
                                  12.5,
                                ).copyWith(color: subtleText),
                              ),
                              const SizedBox(height: 6),
                              // Extract minorIssues list safely
                              Builder(
                                builder: (_) {
                                  final minorIssues =
                                      (patientDetailsVM
                                              .reportDetails?["analysis"]?["minorIssues"]
                                          as List?) ??
                                      [];
                                  return minorIssues.isEmpty
                                      ? chip(
                                        text: "No Major issues found",
                                        accent: Colors.grey,
                                      )
                                      : Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children:
                                            minorIssues
                                                .map(
                                                  (issue) => chip(
                                                    text:
                                                        (issue as Map)?["en"] ??
                                                        "-",
                                                    accent: Colors.orange,
                                                  ),
                                                )
                                                .toList(),
                                      );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Lab results table-like list
                  Container(
                    decoration: cardDecoration(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionHeader(
                          icon: LucideIcons.flaskConical,
                          title: "Lab Results",
                          subtitle: "Test name, value, unit & reference range.",
                          accent: Colors.teal,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: borderColor),
                            color:
                                isDark
                                    ? Colors.white.withOpacity(0.03)
                                    : const Color(0xFFF3F4F8),
                          ),
                          child: Column(
                            children: [
                              // ── Header Row ──
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isDark
                                          ? Colors.white.withOpacity(0.06)
                                          : Colors.black.withOpacity(0.04),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(18),
                                  ),
                                  border: Border(
                                    bottom: BorderSide(color: borderColor),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "Test Name",
                                        style: bodyStyle(12).copyWith(
                                          color: subtleText,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Value",
                                        textAlign: TextAlign.right,
                                        style: bodyStyle(12).copyWith(
                                          color: subtleText,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Unit",
                                        textAlign: TextAlign.right,
                                        style: bodyStyle(12).copyWith(
                                          color: subtleText,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "Reference",
                                        textAlign: TextAlign.right,
                                        style: bodyStyle(12).copyWith(
                                          color: subtleText,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // ── Scrollable Data Rows ──
                              Builder(
                                builder: (_) {
                                  final tests =
                                      (patientDetailsVM
                                              .reportDetails?["analysis"]?["tests"]
                                          as List?) ??
                                      [];

                                  if (tests.isEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Text(
                                        "No lab results available.",
                                        style: bodyStyle(
                                          13,
                                        ).copyWith(color: subtleText),
                                      ),
                                    );
                                  }

                                  // Each row ~48px tall, show 7 rows = ~336px then scroll
                                  final maxHeight =
                                      tests.length > 7 ? 336.0 : null;

                                  return SizedBox(
                                    height: maxHeight,
                                    child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: Column(
                                        children: [
                                          for (int i = 0; i < tests.length; i++)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 12,
                                                  ),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color:
                                                        i == tests.length - 1
                                                            ? Colors.transparent
                                                            : borderColor,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      (tests[i]["name"] ?? "-")
                                                          .toString(),
                                                      style: GoogleFonts.exo(
                                                        fontSize: 13.5,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      (tests[i]["value"] ?? "-")
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: GoogleFonts.exo(
                                                        fontSize: 13.5,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      (tests[i]["unit"] ?? "-")
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: bodyStyle(
                                                        12.5,
                                                      ).copyWith(
                                                        color: subtleText,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      (tests[i]["refRange"] ??
                                                              "-")
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: bodyStyle(
                                                        12.5,
                                                      ).copyWith(
                                                        color: subtleText,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Overall interpretation
                  Container(
                    decoration: cardDecoration(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionHeader(
                          icon: LucideIcons.clipboardCheck,
                          title: "Overall Interpretation",
                          subtitle: "Clinical meaning of the report.",
                          accent: Colors.indigo,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          patientDetailsVM
                              .reportDetails["analysis"]["overallInterpretation"]["en"],
                          style: bodyStyle(13.5).copyWith(
                            color:
                                isDark
                                    ? Colors.white.withOpacity(0.85)
                                    : Colors.black.withOpacity(0.78),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Dietary suggestion
                  Container(
                    decoration: cardDecoration(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionHeader(
                          icon: LucideIcons.utensils,
                          title: "Dietary Suggestion",
                          subtitle: "Foods to favor and foods to limit.",
                          accent: Colors.teal,
                        ),
                        const SizedBox(height: 12),

                        Container(
                          width: double.infinity,
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
                              Text(
                                "Food to favor",
                                style: bodyStyle(
                                  12.5,
                                ).copyWith(color: subtleText),
                              ),
                              const SizedBox(height: 8),
                              for (final f in favorFoods)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        LucideIcons.circleCheck,
                                        size: 16,
                                        color: Colors.teal,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          f,
                                          style: bodyStyle(13).copyWith(
                                            color:
                                                isDark
                                                    ? Colors.white.withOpacity(
                                                      0.86,
                                                    )
                                                    : Colors.black.withOpacity(
                                                      0.78,
                                                    ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 12),
                              Text(
                                "Food to limit",
                                style: bodyStyle(
                                  12.5,
                                ).copyWith(color: subtleText),
                              ),
                              const SizedBox(height: 8),
                              for (final f in limitFoods)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        LucideIcons.x,
                                        size: 16,
                                        color: Colors.redAccent,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          f,
                                          style: bodyStyle(13).copyWith(
                                            color:
                                                isDark
                                                    ? Colors.white.withOpacity(
                                                      0.86,
                                                    )
                                                    : Colors.black.withOpacity(
                                                      0.78,
                                                    ),
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

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LabRow {
  final String name;
  final String value;
  final String unit;
  final String range;
  const _LabRow(this.name, this.value, this.unit, this.range);
}
