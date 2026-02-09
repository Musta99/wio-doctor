import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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

    InputDecoration inputDec() {
      return InputDecoration(
        hintText: "Search by name, mobile, email or WIO ID",
        hintStyle: GoogleFonts.exo(color: subtleText, fontSize: 13),
        prefixIcon: Icon(
          LucideIcons.search,
          size: 18,
          color: isDark ? Colors.white.withOpacity(0.7) : Colors.black54,
        ),
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

    BoxDecoration cardDecoration() {
      return BoxDecoration(
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
    }

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
            colors: [bgTop, bgBottom],
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
                decoration: cardDecoration(),
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
                                  color: subtleText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _searchCtrl,
                      style: GoogleFonts.exo(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: inputDec(),
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
                decoration: cardDecoration(),
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
                                "Your QR (WIO ID)",
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
                                  color: subtleText,
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
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 180,
                            width: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color:
                                  isDark
                                      ? Colors.white.withOpacity(0.06)
                                      : Colors.white,
                              border: Border.all(color: borderColor),
                            ),
                            child: Center(
                              child: Icon(
                                LucideIcons.qrCode,
                                size: 54,
                                color:
                                    isDark
                                        ? Colors.white.withOpacity(0.55)
                                        : Colors.black.withOpacity(0.35),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "WIO ID: DOC-8F29A1",
                            style: GoogleFonts.exo(
                              fontSize: 13.5,
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
                              color: subtleText,
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
                                    "Share",
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
