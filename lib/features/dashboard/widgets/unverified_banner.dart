import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/features/dashboard/view_model/dashboard_view_model.dart';

class UnverifiedBanner extends StatelessWidget {
  const UnverifiedBanner();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<DashboardViewModel>(
      builder: (context, vm, _) {
        if (vm.isEmailVerified) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(isDark ? 0.15 : 0.10),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.orange.withOpacity(isDark ? 0.35 : 0.25),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                LucideIcons.triangleAlert,
                size: 18,
                color: Colors.orange,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Your email is not verified. Please check your inbox.",
                  style: GoogleFonts.exo(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color:
                        isDark
                            ? Colors.orange.withOpacity(0.90)
                            : Colors.orange.shade800,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap:
                    () =>
                        context
                            .read<DashboardViewModel>()
                            .refreshEmailVerification(),
                child:
                    vm.isRefreshingVerification
                        ? const SizedBox(
                          height: 14,
                          width: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.orange,
                            ),
                          ),
                        )
                        : Text(
                          "Refresh",
                          style: GoogleFonts.exo(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w900,
                            color: Colors.orange,
                          ),
                        ),
              ),
            ],
          ),
        );
      },
    );
  }
}
