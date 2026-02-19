import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/features/patient/view_model/patient_view_model.dart';

class PatientPrescriptionScreen extends StatefulWidget {
  final String patientId;
  final String prescriptionId;

  const PatientPrescriptionScreen({
    super.key,
    required this.patientId,
    required this.prescriptionId,
  });

  @override
  State<PatientPrescriptionScreen> createState() =>
      _PatientPrescriptionScreenState();
}

class _PatientPrescriptionScreenState extends State<PatientPrescriptionScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PatientViewModel>(context, listen: false)
          .fetchPrescriptionDetails(widget.patientId, widget.prescriptionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgTop = isDark ? const Color(0xFF0B1220) : const Color(0xFFF7F8FC);
    final bgBottom = isDark ? const Color(0xFF060A12) : Colors.white;

    final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor =
        isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06);
    final subtleText =
        isDark ? Colors.white.withOpacity(0.72) : Colors.black.withOpacity(0.62);

    TextStyle titleStyle(double s) =>
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
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: titleStyle(16)),
              Text(subtitle,
                  style: bodyStyle(12.5).copyWith(color: subtleText)),
            ],
          ),
        ],
      );
    }

    Widget chip(String text, Color color) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: color.withOpacity(.15),
        ),
        child: Text(text, style: bodyStyle(12)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Prescription", style: titleStyle(17)),
        centerTitle: true,
      ),
      body: Consumer<PatientViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoadingPrescriptionFetch) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = vm.prescriptionDetails ?? {};

          final meds = data["medications"] ?? [];
          final interactions = data["interactions"] ?? [];
          final tests = data["recommendedTests"] ?? [];

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [bgTop, bgBottom],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// ================= PATIENT DETAILS =================
                  Container(
                    decoration: cardDecoration(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionHeader(
                          icon: LucideIcons.user,
                          title: data["patientName"] ?? "Patient",
                          subtitle:
                              "Dr. ${data["doctorName"] ?? "-"} • ${data["date"] ?? "-"}",
                        ),
                        const SizedBox(height: 12),
                        Text("Age: ${data["age"] ?? "-"}",
                            style: bodyStyle(13)),
                        Text("Gender: ${data["gender"] ?? "-"}",
                            style: bodyStyle(13)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// ================= MEDICATION TABLE =================
                  Container(
                    decoration: cardDecoration(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        sectionHeader(
                          icon: LucideIcons.pill,
                          title: "Medications",
                          subtitle: "Prescribed medicines & dosage",
                        ),
                        const SizedBox(height: 12),

                        for (final m in meds)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(m["name"] ?? "-",
                                style: bodyStyle(14)),
                            subtitle: Text(
                                "Dosage: ${m["dosage"]} • Duration: ${m["duration"]}"),
                            trailing: chip(m["frequency"] ?? "", Colors.teal),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// ================= INTERACTION CHECK =================
                  Container(
                    decoration: cardDecoration(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionHeader(
                          icon: LucideIcons.circleAlert,
                          title: "Drug Interaction Check",
                          subtitle: "Potential conflicts",
                          accent: Colors.orange,
                        ),
                        const SizedBox(height: 10),

                        interactions.isEmpty
                            ? chip("No interactions found", Colors.green)
                            : Wrap(
                                spacing: 8,
                                children: interactions
                                    .map<Widget>((i) => chip(i, Colors.red))
                                    .toList(),
                              ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// ================= RECOMMENDED TESTS =================
                  Container(
                    decoration: cardDecoration(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionHeader(
                          icon: LucideIcons.flaskConical,
                          title: "Recommended Tests",
                          subtitle: "Further investigation",
                        ),
                        const SizedBox(height: 10),

                        for (final t in tests)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle,
                                    size: 18, color: Colors.teal),
                                const SizedBox(width: 8),
                                Expanded(child: Text(t, style: bodyStyle(13))),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// ================= DOCTOR SUGGESTION =================
                  Container(
                    decoration: cardDecoration(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionHeader(
                          icon: LucideIcons.stethoscope,
                          title: "Doctor's Suggestion",
                          subtitle: "Advice & precautions",
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data["doctorSuggestion"] ?? "No suggestion available",
                          style: bodyStyle(13.5),
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
    );
  }
}
