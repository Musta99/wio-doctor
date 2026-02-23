import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/services/time_formate_service.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';

class AppointmentCardWidget extends StatelessWidget {
  final  Map<String, dynamic> appointment;
  const AppointmentCardWidget({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
        final themeProvider = ThemeProvider.of(context);
    final isDark = themeProvider.isDarkMode;
    final borderColor =
        isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.06);
    final subtleText =
        isDark
            ? Colors.white.withOpacity(0.72)
            : Colors.black.withOpacity(0.65);
    // -----------------------------------------------------------------
      final status = (appointment["status"] ?? "").toString();
      final payment = (appointment["payment"] ?? "").toString();
      final type = (appointment["consultationType"] ?? "").toString();
      final time = TimeFormateService().getFormattedTime(appointment["slotStart"]);
    return Container(
        decoration: cardDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  avatarCircle(appointment["patientName"] ?? "Patient"),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment["patientName"] ?? "",
                          style: bodyStyle(
                            15,
                          ).copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${appointment["patientWioId"] ?? ""} • ${appointment["slotDate"] ?? ""} • ${time ?? ""}",
                          style: bodyStyle(12).copyWith(color: subtleText),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.06)
                                : Colors.black.withOpacity(0.04),
                        border: Border.all(color: borderColor),
                      ),
                      child: Icon(
                        LucideIcons.chevronRight,
                        size: 18,
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.85)
                                : Colors.black.withOpacity(0.75),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  pillChip(type, LucideIcons.badgeCheck, colorKey: "confirmed"),
                  pillChip(status, LucideIcons.clock3, colorKey: status),
                  pillChip(payment, LucideIcons.creditCard, colorKey: payment),
                ],
              ),
              const SizedBox(height: 12),
              status.toLowerCase().contains("pending")
                  ? Row(
                    children: [
                      Expanded(
                        child: ShadButton(
                          width: double.infinity,
                          backgroundColor: Colors.green,

                          onPressed: () {},
                          child: Text(
                            "Approve",
                            style: GoogleFonts.exo(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),

                      Expanded(
                        child: ShadButton(
                          width: double.infinity,
                          backgroundColor: Colors.red,

                          onPressed: () {},
                          child: Text(
                            "Reject",

                            style: GoogleFonts.exo(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ],
                  )
                  : ShadButton(
                    width: double.infinity,
                    backgroundColor: Colors.teal,
                    onPressed: () {},
                    child: Text(
                      "Manage",
                      style: GoogleFonts.exo(fontWeight: FontWeight.w900),
                    ),
                  ),
            ],
          ),
        ),
      );
  }
}