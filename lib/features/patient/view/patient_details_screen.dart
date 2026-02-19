import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';
import 'package:wio_doctor/features/patient/view/add_patient_vital.dart';
import 'package:wio_doctor/features/patient/view/patient_prescription_screen.dart';
import 'package:wio_doctor/features/patient/view/patient_report_screen.dart';
import 'package:wio_doctor/features/patient/view_model/patient_view_model.dart';

class PatientDetailsScreen extends StatefulWidget {
  final String patientId;
  const PatientDetailsScreen({super.key, required this.patientId});

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  final TextEditingController _testSearch = TextEditingController();

  // Demo data (replace with provider/api)
  final Map<String, dynamic> patient = {
    "name": "Ayesha Rahman",
    "wioId": "WIO-PT-01924",
    "imageUrl": null, // put network url if you have
  };

  final Map<String, dynamic> healthCards = {
    "bp": "118/78",
    "sugar": "6.1 mmol/L",
    "prescriptions": "2 Active",
  };

  final List<Map<String, dynamic>> testHistory = [
    {
      "name": "CBC (Complete Blood Count)",
      "result": "Normal",
      "date": "12 Feb 2026",
      "status": "Completed",
      "source": "Lab",
    },
    {
      "name": "Fasting Blood Sugar",
      "result": "6.1 mmol/L",
      "date": "10 Feb 2026",
      "status": "Completed",
      "source": "Clinic",
    },
    {
      "name": "HbA1c",
      "result": "Pending",
      "date": "09 Feb 2026",
      "status": "Pending",
      "source": "Lab",
    },
  ];

  final List<Map<String, dynamic>> prescriptions = [
    {"name": "Metformin 500mg", "date": "11 Feb 2026"},
    {"name": "Amlodipine 5mg", "date": "04 Feb 2026"},
  ];

  final List<Map<String, dynamic>> reports = [
    {"name": "ECG Report", "date": "08 Feb 2026"},
    {"name": "X-Ray Chest", "date": "01 Feb 2026"},
  ];

  final List<Map<String, dynamic>> vitalsHistory = [
    {"bp": "120/80", "sugar": "6.0 mmol/L", "date": "12 Feb 2026"},
    {"bp": "118/78", "sugar": "6.1 mmol/L", "date": "10 Feb 2026"},
    {"bp": "130/85", "sugar": "7.2 mmol/L", "date": "05 Feb 2026"},
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<PatientViewModel>(
      context,
      listen: false,
    ).fetchPatientDetails(widget.patientId);
  }

  @override
  void dispose() {
    _testSearch.dispose();
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
      fontWeight: FontWeight.w800,
      fontSize: size,
      letterSpacing: -0.2,
    );

    TextStyle sectionStyle(double size) =>
        GoogleFonts.exo(fontWeight: FontWeight.w800, fontSize: size);

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

    InputDecoration searchDecoration() {
      return InputDecoration(
        hintText: "Search test history (name/result/source)",
        hintStyle: GoogleFonts.exo(
          color: subtleText,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: const Icon(LucideIcons.search, size: 18),
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
          borderSide: BorderSide(
            color:
                isDark
                    ? Colors.white.withOpacity(0.18)
                    : Colors.black.withOpacity(0.12),
          ),
        ),
      );
    }

    Color chipBg(String key) {
      final s = key.toLowerCase();
      if (s.contains("pending"))
        return Colors.orange.withOpacity(isDark ? 0.18 : 0.12);
      if (s.contains("complete"))
        return Colors.green.withOpacity(isDark ? 0.18 : 0.12);
      if (s.contains("abnormal"))
        return Colors.red.withOpacity(isDark ? 0.18 : 0.12);
      return Colors.blueGrey.withOpacity(isDark ? 0.18 : 0.12);
    }

    Color chipBorder(String key) {
      final s = key.toLowerCase();
      if (s.contains("pending"))
        return Colors.orange.withOpacity(isDark ? 0.35 : 0.25);
      if (s.contains("complete"))
        return Colors.green.withOpacity(isDark ? 0.35 : 0.25);
      if (s.contains("abnormal"))
        return Colors.red.withOpacity(isDark ? 0.35 : 0.25);
      return Colors.blueGrey.withOpacity(isDark ? 0.35 : 0.25);
    }

    Color chipText(String key) {
      if (isDark) return Colors.white.withOpacity(0.92);
      final s = key.toLowerCase();
      if (s.contains("pending")) return Colors.orange.shade900;
      if (s.contains("complete")) return Colors.green.shade900;
      if (s.contains("abnormal")) return Colors.red.shade900;
      return Colors.blueGrey.shade900;
    }

    Widget pillChip(String text, IconData icon, {String? keyColor}) {
      final k = keyColor ?? text;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: chipBg(k),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: chipBorder(k)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: chipText(k)),
            const SizedBox(width: 6),
            Text(
              text,
              style: GoogleFonts.exo(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: chipText(k),
              ),
            ),
          ],
        ),
      );
    }

    Widget avatarCircle(String name) {
      final parts = name.trim().split(RegExp(r"\s+"));
      final initials =
          parts.isEmpty
              ? "P"
              : parts
                  .take(2)
                  .map((e) => e.isNotEmpty ? e[0] : "")
                  .join()
                  .toUpperCase();
      return Container(
        height: 62,
        width: 62,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              isDark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.black.withOpacity(0.06),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.30 : 0.08),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Text(
            initials.isEmpty ? "P" : initials,
            style: GoogleFonts.exo(fontWeight: FontWeight.w900, fontSize: 18),
          ),
        ),
      );
    }

    final q = _testSearch.text.trim().toLowerCase();
    final filteredTests =
        testHistory.where((t) {
          if (q.isEmpty) return true;
          final name = (t["name"] ?? "").toString().toLowerCase();
          final result = (t["result"] ?? "").toString().toLowerCase();
          final source = (t["source"] ?? "").toString().toLowerCase();
          return name.contains(q) || result.contains(q) || source.contains(q);
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Details", style: titleStyle(20)),
        centerTitle: true,
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
      body: Consumer<PatientViewModel>(
        builder: (context, patientLoadingVM, child) {
          if (patientLoadingVM.isLoadingPatientDetails) {
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =========================================================
                    // 1) User details (Image, name, wio ID)
                    // =========================================================
                    Consumer<PatientViewModel>(
                      builder: (context, patientDetaislVM, child) {
                        return Container(
                          decoration: cardDecoration(),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                avatarCircle(
                                  patientDetaislVM
                                          .patientDetailsData?["profile"]?["name"] ??
                                      "Patient",
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        patientDetaislVM
                                                .patientDetailsData?["profile"]?["name"] ??
                                            "",
                                        style: bodyStyle(
                                          18,
                                        ).copyWith(fontWeight: FontWeight.w900),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          pillChip(
                                            patientDetaislVM
                                                    .patientDetailsData?["profile"]?["wioId"] ??
                                                "",
                                            LucideIcons.badgeCheck,
                                            keyColor: "completed",
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  isDark
                                                      ? Colors.white
                                                          .withOpacity(0.04)
                                                      : const Color(0xFFF3F4F8),
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                              border: Border.all(
                                                color: borderColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  LucideIcons.shield,
                                                  size: 14,
                                                  color: subtleText,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  "Verified",
                                                  style: GoogleFonts.exo(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w900,
                                                    color: subtleText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      ShadButton(
                                        width: double.infinity,
                                        backgroundColor: Colors.teal,
                                        onPressed: () {},
                                        child: Text(
                                          "Manage",
                                          style: GoogleFonts.exo(
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
                        );
                      },
                    ),

                    const SizedBox(height: 14),

                    // =========================================================
                    // 2) User health info cards (BP, Sugar, Active prescriptions)
                    // =========================================================
                    Text("Health overview", style: sectionStyle(18)),
                    const SizedBox(height: 10),
                    Consumer<PatientViewModel>(
                      builder: (context, patientDetailsVM, child) {
                        return Container(
                          decoration: cardDecoration(),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 38,
                                      width: 38,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.blue.withOpacity(
                                          isDark ? 0.14 : 0.10,
                                        ),
                                        border: Border.all(
                                          color: Colors.blue.withOpacity(
                                            isDark ? 0.25 : 0.18,
                                          ),
                                        ),
                                      ),
                                      child: const Icon(
                                        LucideIcons.heartPulse,
                                        size: 18,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "Blood Pressure",
                                        style: bodyStyle(13).copyWith(
                                          color: subtleText,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "RAW",
                                      style: bodyStyle(
                                        16,
                                      ).copyWith(fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                                Divider(color: borderColor, height: 18),
                                Row(
                                  children: [
                                    Container(
                                      height: 38,
                                      width: 38,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.orange.withOpacity(
                                          isDark ? 0.14 : 0.10,
                                        ),
                                        border: Border.all(
                                          color: Colors.orange.withOpacity(
                                            isDark ? 0.25 : 0.18,
                                          ),
                                        ),
                                      ),
                                      child: const Icon(
                                        LucideIcons.droplet,
                                        size: 18,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "Blood Sugar",
                                        style: bodyStyle(13).copyWith(
                                          color: subtleText,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "RAW",
                                      style: bodyStyle(
                                        16,
                                      ).copyWith(fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                                Divider(color: borderColor, height: 18),
                                Row(
                                  children: [
                                    Container(
                                      height: 38,
                                      width: 38,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.green.withOpacity(
                                          isDark ? 0.14 : 0.10,
                                        ),
                                        border: Border.all(
                                          color: Colors.green.withOpacity(
                                            isDark ? 0.25 : 0.18,
                                          ),
                                        ),
                                      ),
                                      child: const Icon(
                                        LucideIcons.pill,
                                        size: 18,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "Active Prescriptions",
                                        style: bodyStyle(13).copyWith(
                                          color: subtleText,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ((patientDetailsVM
                                                      .patientDetailsData?["prescriptions"]
                                                  as List?) ??
                                              [])
                                          .length
                                          .toString(),
                                      style: bodyStyle(
                                        16,
                                      ).copyWith(fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // =========================================================
                    // 3) Test history + search
                    // =========================================================
                    Text("Test history", style: sectionStyle(18)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _testSearch,
                      onChanged: (_) => setState(() {}),
                      decoration: searchDecoration(),
                      style: bodyStyle(14),
                    ),
                    const SizedBox(height: 10),

                    if (filteredTests.isEmpty)
                      Container(
                        decoration: cardDecoration(),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            "No test history found for your search.",
                            style: bodyStyle(13).copyWith(color: subtleText),
                          ),
                        ),
                      ),

                    for (final t in filteredTests) ...[
                      Container(
                        decoration: cardDecoration(),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      t["name"] ?? "",
                                      style: bodyStyle(
                                        15,
                                      ).copyWith(fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  pillChip(
                                    t["status"] ?? "",
                                    (t["status"] ?? "")
                                            .toString()
                                            .toLowerCase()
                                            .contains("pending")
                                        ? LucideIcons.clock3
                                        : LucideIcons.circleCheck,
                                    keyColor: t["status"] ?? "",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Result: ${t["result"] ?? "-"}",
                                style: bodyStyle(
                                  13,
                                ).copyWith(color: subtleText),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  pillChip(
                                    "Date: ${t["date"] ?? "-"}",
                                    LucideIcons.calendar,
                                    keyColor: "date",
                                  ),
                                  pillChip(
                                    "Source: ${t["source"] ?? "-"}",
                                    LucideIcons.flaskConical,
                                    keyColor: "source",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    const SizedBox(height: 16),

                    // =========================================================
                    // 4) Prescriptions list
                    // =========================================================
                    Text("Prescriptions", style: sectionStyle(18)),
                    const SizedBox(height: 10),

                    Consumer<PatientViewModel>(
                      builder: (context, patientDetailsVM, child) {
                        final prescriptions =
                            (patientDetailsVM
                                        .patientDetailsData?["prescriptions"]
                                    as List? ??
                                []);
                        return patientDetailsVM.isLoadingPatientDetails &&
                                prescriptions.isEmpty
                            ? Container(
                              decoration: cardDecoration(),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Icon(
                                  LucideIcons.loader,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            )
                            : Column(
                              children: [
                                // Show empty message
                                if (!patientDetailsVM.isLoadingPatientDetails &&
                                    prescriptions.isEmpty)
                                  Container(
                                    decoration: cardDecoration(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Text(
                                        "No prescriptions found.",
                                        style: bodyStyle(
                                          13,
                                        ).copyWith(color: subtleText),
                                      ),
                                    ),
                                  ),

                                // Show prescription list
                                for (final p in prescriptions) ...[
                                  Container(
                                    decoration: cardDecoration(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 42,
                                            width: 42,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: Colors.green.withOpacity(
                                                isDark ? 0.14 : 0.10,
                                              ),
                                              border: Border.all(
                                                color: Colors.green.withOpacity(
                                                  isDark ? 0.25 : 0.18,
                                                ),
                                              ),
                                            ),
                                            child: const Icon(
                                              LucideIcons.pill,
                                              size: 18,
                                              color: Colors.green,
                                            ),
                                          ),
                                          const SizedBox(width: 12),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  p["doctor"] ?? "",
                                                  style: bodyStyle(15).copyWith(
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  "Date: ${p["date"] ?? "-"}",
                                                  style: bodyStyle(
                                                    12,
                                                  ).copyWith(color: subtleText),
                                                ),
                                              ],
                                            ),
                                          ),

                                          ShadButton(
                                            backgroundColor: Colors.teal,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          PatientPrescriptionScreen(
                                                            patientId:
                                                                widget
                                                                    .patientId,
                                                            prescriptionId:
                                                                p["id"],
                                                          ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "View details",
                                              style: GoogleFonts.exo(
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ],
                            );
                      },
                    ),

                    const SizedBox(height: 16),

                    // =========================================================
                    // 5) Reports list
                    // =========================================================
                    Text("Reports", style: sectionStyle(18)),
                    const SizedBox(height: 10),
                    Consumer<PatientViewModel>(
                      builder: (context, patientDetailsVM, child) {
                        final reports =
                            (patientDetailsVM.patientDetailsData?["reports"]
                                    as List? ??
                                []);
                        return patientDetailsVM.isLoadingPatientDetails &&
                                reports.isEmpty
                            ? Container(
                              decoration: cardDecoration(),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Icon(
                                  LucideIcons.loader,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            )
                            : Column(
                              children: [
                                // Empty state
                                if (!patientDetailsVM.isLoadingPatientDetails &&
                                    reports.isEmpty)
                                  Container(
                                    decoration: cardDecoration(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Text(
                                        "No reports available.",
                                        style: bodyStyle(
                                          13,
                                        ).copyWith(color: subtleText),
                                      ),
                                    ),
                                  ),

                                // Report list
                                for (final r in reports) ...[
                                  Container(
                                    decoration: cardDecoration(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 42,
                                            width: 42,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: Colors.blue.withOpacity(
                                                isDark ? 0.14 : 0.10,
                                              ),
                                              border: Border.all(
                                                color: Colors.blue.withOpacity(
                                                  isDark ? 0.25 : 0.18,
                                                ),
                                              ),
                                            ),
                                            child: const Icon(
                                              LucideIcons.fileText,
                                              size: 18,
                                              color: Colors.blue,
                                            ),
                                          ),

                                          const SizedBox(width: 12),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  r["provider"] ?? "",
                                                  style: bodyStyle(15).copyWith(
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  "Date: ${r["date"] ?? "-"}",
                                                  style: bodyStyle(
                                                    12,
                                                  ).copyWith(color: subtleText),
                                                ),
                                              ],
                                            ),
                                          ),

                                          ShadButton(
                                            backgroundColor: Colors.teal,
                                            onPressed: () {
                                              print(r["id"]);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          PatientHealthDashboardScreen(
                                                            reportId: r["id"],
                                                            patientId:
                                                                widget
                                                                    .patientId,
                                                          ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "Details",
                                              style: GoogleFonts.exo(
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ],
                            );
                      },
                    ),

                    const SizedBox(height: 16),

                    // =========================================================
                    // 6) Patient tracer history (BP, Sugar, Date) + Add button
                    // =========================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Patient trackers", style: sectionStyle(18)),
                        ShadButton(
                          backgroundColor: Colors.teal,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddVitalsScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Add",
                            style: GoogleFonts.exo(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Consumer<PatientViewModel>(
                      builder: (context, patientDetailsVM, child) {
                        final vitals =
                            (patientDetailsVM.patientDetailsData?["vitals"]
                                    as List? ??
                                []);
                        return patientDetailsVM.isLoadingPatientDetails &&
                                vitals.isEmpty
                            ? Container(
                              decoration: cardDecoration(),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Icon(
                                  LucideIcons.loader,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            )
                            : Column(
                              children: [
                                if (!patientDetailsVM.isLoadingPatientDetails &&
                                    vitals.isEmpty)
                                  Container(
                                    decoration: cardDecoration(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Text(
                                        "No vitals history yet.",
                                        style: bodyStyle(
                                          13,
                                        ).copyWith(color: subtleText),
                                      ),
                                    ),
                                  ),

                                for (final v in vitals) ...[
                                  Container(
                                    decoration: cardDecoration(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Date: ${v["date"] ?? "-"}",
                                            style: bodyStyle(13).copyWith(
                                              color: subtleText,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    12,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          14,
                                                        ),
                                                    color:
                                                        isDark
                                                            ? Colors.white
                                                                .withOpacity(
                                                                  0.04,
                                                                )
                                                            : const Color(
                                                              0xFFF3F4F8,
                                                            ),
                                                    border: Border.all(
                                                      color: borderColor,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Blood Pressure",
                                                        style: bodyStyle(
                                                          12,
                                                        ).copyWith(
                                                          color: subtleText,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        "${v["bp"] ?? "-"}",
                                                        style: bodyStyle(
                                                          15,
                                                        ).copyWith(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    12,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          14,
                                                        ),
                                                    color:
                                                        isDark
                                                            ? Colors.white
                                                                .withOpacity(
                                                                  0.04,
                                                                )
                                                            : const Color(
                                                              0xFFF3F4F8,
                                                            ),
                                                    border: Border.all(
                                                      color: borderColor,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Blood Sugar",
                                                        style: bodyStyle(
                                                          12,
                                                        ).copyWith(
                                                          color: subtleText,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        "${v["sugar"] ?? "-"}",
                                                        style: bodyStyle(
                                                          15,
                                                        ).copyWith(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ],
                            );
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
