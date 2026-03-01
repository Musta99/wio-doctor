import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/app_colors.dart';
import 'package:wio_doctor/core/theme/app_decoration.dart';
import 'package:wio_doctor/features/patient_access/view_model/patient_access_view_model.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';

class PatientAccessScreen extends StatefulWidget {
  const PatientAccessScreen({super.key});

  @override
  State<PatientAccessScreen> createState() => _PatientAccessScreenState();
}

class _PatientAccessScreenState extends State<PatientAccessScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final doctorId =
        context.read<AuthenticationProvider>().userId ?? "DOC-8F29A1";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Patient Access",
          style: GoogleFonts.exo(fontWeight: FontWeight.w900),
        ),
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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search section
              Container(
                decoration: AppDecorations.card(isDark),
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
                            color: Colors.teal.withOpacity(
                              isDark ? 0.14 : 0.10,
                            ),
                            border: Border.all(
                              color: Colors.teal.withOpacity(
                                isDark ? 0.25 : 0.18,
                              ),
                            ),
                          ),
                          child: const Icon(
                            LucideIcons.search,
                            size: 18,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Find Patient",
                                style: GoogleFonts.exo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Search using patient details or WIO ID.",
                                style: GoogleFonts.exo(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.subtleText(isDark),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      onChanged: (value) async{
                        print(value);

                        await Provider.of<PatientAccessViewModel>(context, listen: false).findPatient(value);
                      },
                      style: GoogleFonts.exo(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: AppDecorations.inputDec(
                        "Search by name, mobile, email or WIO ID",
                        LucideIcons.search,
                        isDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ShadButton(
                      width: double.infinity,
                      backgroundColor: Colors.teal,
                      pressedBackgroundColor: Colors.teal,
                      onPressed: () {
                        // TODO: perform search
                        FocusScope.of(context).unfocus();
                      },
                      child: Text(
                        "Search",
                        style: GoogleFonts.exo(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Doctor QR / WIO section
              Container(
                decoration: AppDecorations.card(isDark),
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
                            color: Colors.indigo.withOpacity(
                              isDark ? 0.14 : 0.10,
                            ),
                            border: Border.all(
                              color: Colors.indigo.withOpacity(
                                isDark ? 0.25 : 0.18,
                              ),
                            ),
                          ),
                          child: const Icon(
                            LucideIcons.qrCode,
                            size: 18,
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your QR Code",
                                style: GoogleFonts.exo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Patients can scan this to request access.",
                                style: GoogleFonts.exo(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.subtleText(isDark),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // QR placeholder (replace with qr_flutter later)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.04)
                                : const Color(0xFFF3F4F8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border(isDark)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 180,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.white,
                            ),
                            child: PrettyQrView.data(
                              data: doctorId,
                              decoration: const PrettyQrDecoration(
                                shape: PrettyQrSmoothSymbol(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "DoctorId ID: ${doctorId}",
                            style: GoogleFonts.exo(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Show this QR to your patient during consultation.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.exo(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.subtleText(isDark),
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ShadButton(
                                  backgroundColor:
                                      isDark
                                          ? Colors.white.withOpacity(0.06)
                                          : const Color(0xFFF3F4F8),
                                  onPressed: () {
                                    // TODO: copy WIO ID
                                  },
                                  child: Text(
                                    "Copy ID",
                                    style: GoogleFonts.exo(
                                      fontWeight: FontWeight.w900,
                                      color:
                                          isDark
                                              ? Colors.white.withOpacity(0.9)
                                              : Colors.black.withOpacity(0.85),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ShadButton(
                                  backgroundColor: Colors.teal,
                                  onPressed: () {
                                    // TODO: share QR / open QR full screen
                                  },
                                  child: Text(
                                    "Download",
                                    style: GoogleFonts.exo(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),
            ],
          ),
        ),
      ),
    );
  }
}
