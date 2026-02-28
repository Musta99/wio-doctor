import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/services/time_formate_service.dart';
import 'package:wio_doctor/core/theme/app_decoration.dart';
import 'package:wio_doctor/core/theme/app_text_styles.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';
import 'package:wio_doctor/features/appointment/view_model/appointment_view_model.dart';
import 'package:wio_doctor/widgets/avatar_circle_widget.dart';
import 'package:wio_doctor/widgets/pill_chip_widget.dart';

class AppointmentCardWidget extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final bool isDark;
  const AppointmentCardWidget({
    super.key,
    required this.appointment,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // -----------------------------------------------------------------
    final status = (appointment["status"] ?? "").toString();
    final payment = (appointment["payment"] ?? "").toString();
    final type = (appointment["consultationType"] ?? "").toString();
    final time = TimeFormateService().getFormattedTime(
      appointment["slotStart"],
    );
    return Container(
      decoration: AppDecorations.card(isDark),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                AvatarCircleWidget(
                  name: appointment["patientName"] ?? "Patient",
                  isDark: isDark,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment["patientName"] ?? "",
                        style: AppTextStyles.body(
                          15,
                        ).copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${appointment["patientWioId"] ?? ""} • ${appointment["slotDate"] ?? ""} • ${time ?? ""}",
                        style: AppTextStyles.body(12).copyWith(
                          color:
                              isDark
                                  ? Colors.white.withOpacity(0.72)
                                  : Colors.black.withOpacity(0.65),
                        ),
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
                      border: Border.all(
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.08)
                                : Colors.black.withOpacity(0.06),
                      ),
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
                PillChipWidget(
                  text: type,
                  icon: LucideIcons.badgeCheck,
                  statusKey: "confirmed",
                  isDark: isDark,
                ),
                PillChipWidget(
                  text: status,
                  icon: LucideIcons.clock3,
                  statusKey: status,
                  isDark: isDark,
                ),
                PillChipWidget(
                  text: payment,
                  icon: LucideIcons.creditCard,
                  statusKey: payment,
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: 12),
            status.toLowerCase().contains("pending")
                ? Consumer<AppointmentViewModel>(
                  builder: (context, appointmentVM, child) {
                    final id = appointment["id"];
                    final isApprovingThis = appointmentVM.isApproveLoading(id);
                    final isCancelingThis = appointmentVM.isCancelLoading(id);

                    return Row(
                      children: [
                        Expanded(
                          child: ShadButton(
                            width: double.infinity,
                            backgroundColor: Colors.green,
                            onPressed:
                                (isApprovingThis || isCancelingThis)
                                    ? null
                                    : () async => await appointmentVM
                                        .updateAppointmentStatus(context, id),
                            child:
                                isApprovingThis
                                    ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                    : Text(
                                      "Approve",
                                      style: GoogleFonts.exo(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                          ),
                        ),
                        Expanded(
                          child: ShadButton(
                            width: double.infinity,
                            backgroundColor: Colors.red,
                            onPressed:
                                (isApprovingThis || isCancelingThis)
                                    ? null
                                    : () async => await appointmentVM
                                        .updateAppointmentStatus(
                                          context,
                                          id,
                                          isApproved: false,
                                        ),
                            child:
                                isCancelingThis
                                    ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                    : Text(
                                      "Reject",
                                      style: GoogleFonts.exo(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    );
                  },
                )
                : Row(
                  children: [
                    Expanded(
                      child: ShadButton.outline(
                        width: double.infinity,
                        decoration: ShadDecoration(
                          border: ShadBorder.all(
                            color: Colors.blue,
                            radius: BorderRadius.circular(20),
                          ),
                        ),
                        backgroundColor: Colors.blue.withOpacity(0.06),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.phone,
                              size: 15,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Start Call",
                              style: GoogleFonts.exo(
                                fontWeight: FontWeight.w700,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ShadButton.outline(
                        width: double.infinity,
                        decoration: ShadDecoration(
                          border: ShadBorder.all(
                            color: Colors.green,
                            radius: BorderRadius.circular(20),
                          ),
                        ),
                        backgroundColor: Colors.green.withOpacity(0.06),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.circleCheck,
                              size: 15,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Mark Completed",
                              style: GoogleFonts.exo(
                                fontWeight: FontWeight.w700,
                                color: Colors.green,
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
    );
  }
}
