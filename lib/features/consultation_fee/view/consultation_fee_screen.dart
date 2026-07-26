// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shadcn_ui/shadcn_ui.dart';
// import 'package:wio_doctor/core/theme/app_decoration.dart';
// import 'package:wio_doctor/core/theme/app_text_styles.dart';
// import 'package:wio_doctor/core/theme/theme_provider.dart';
// import 'package:wio_doctor/features/consultation_fee/view_model/consultation_fee_view_model.dart';

// class ConsultationFeeScreen extends StatefulWidget {
//   const ConsultationFeeScreen({super.key});

//   @override
//   State<ConsultationFeeScreen> createState() => _ConsultationFeeScreenState();
// }

// class _ConsultationFeeScreenState extends State<ConsultationFeeScreen> {
//   bool isSaving = false;

//   Widget _buildFeeRow(
//     bool isDark,
//     String title,
//     String subtitle,
//     TextEditingController controller,
//     IconData icon,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Color(0xFF14c7eb).withOpacity(0.4),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, color: Colors.white),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: AppTextStyles.title(16)),
//                 const SizedBox(height: 2),
//                 Text(subtitle, style: AppTextStyles.body(13)),
//               ],
//             ),
//           ),
//           const SizedBox(width: 12),
//           SizedBox(
//             width: 120,
//             child: TextField(
//               controller: controller,
//               keyboardType: TextInputType.number,
//               decoration: AppDecorations.inputDec("Amount", icon, isDark),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ConsultationFeeViewModel>(
//         context,
//         listen: false,
//       ).fetchConsultationFee(context);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final themeProvider = context.read<ThemeViewModel>();
//     final vm = Provider.of<ConsultationFeeViewModel>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Consultation Fee", style: AppTextStyles.title(20)),
//         centerTitle: true,
//         automaticallyImplyLeading: true,
//       ),

//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
//         child: Column(
//           children: [
//             // Currency selector
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Currency", style: AppTextStyles.title(16)),
//                 DropdownButton<String>(
//                   value: vm.currency,
//                   items:
//                       ["BDT (৳)", "USD (\$)"]
//                           .map(
//                             (e) => DropdownMenuItem(value: e, child: Text(e)),
//                           )
//                           .toList(),
//                   onChanged: (val) {
//                     if (val != null) {
//                       vm.currency = val;
//                       vm.notifyListeners();
//                     }
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Fee rows
//             Expanded(
//               child: ListView(
//                 children: [
//                   _buildFeeRow(
//                     isDark,
//                     "60-Minute Consultation",
//                     "Full consultation session (60 minutes)",
//                     vm.feeControllers['60-Minute Consultation']!,
//                     Icons.access_time,
//                   ),
//                   _buildFeeRow(
//                     isDark,
//                     "30-Minute Consultation",
//                     "Quick consultation session (30 minutes)",
//                     vm.feeControllers['30-Minute Consultation']!,
//                     Icons.hourglass_bottom,
//                   ),
//                   _buildFeeRow(
//                     isDark,
//                     "Follow-up Consultation",
//                     "Reduced fee for follow-up visits",
//                     vm.feeControllers['Follow-up Consultation']!,
//                     Icons.update,
//                   ),
//                   _buildFeeRow(
//                     isDark,
//                     "Online Video Consultation",
//                     "Virtual consultation via video call",
//                     vm.feeControllers['Online Video Consultation']!,
//                     Icons.videocam,
//                   ),
//                   _buildFeeRow(
//                     isDark,
//                     "Home Visit",
//                     "Doctor visits patient at home",
//                     vm.feeControllers['Home Visit']!,
//                     Icons.home,
//                   ),

//                   const SizedBox(height: 24),
//                   // Platform Fee Summary
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(12),
//                     decoration: AppDecorations.card(isDark),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Platform Fee Summary",
//                           style: AppTextStyles.title(14),
//                         ),
//                         SizedBox(height: 6),
//                         Text(
//                           "• Platform commission: 10%",
//                           style: AppTextStyles.body(14),
//                         ),
//                         Text(
//                           "• Payment processing fee: 2.5%",
//                           style: AppTextStyles.body(14),
//                         ),
//                         Text(
//                           "• Estimated payout: 87.5% of consultation fee",
//                           style: AppTextStyles.body(14),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                 ],
//               ),
//             ),

//             // Save button
//             ShadButton(
//               onPressed: () async {
//                 await vm.updateConsultationFee(context);
//               },
//               width: double.infinity,
//               pressedBackgroundColor: Color(0xFF14c7eb),
//               backgroundColor: Color(0xFF14c7eb),
//               child:
//                   vm.isConsultationFeeUpdating
//                       ? Icon(LucideIcons.loader, size: 22)
//                       : Text("Save Fees", style: AppTextStyles.title(15)),
//             ),

//             SizedBox(height: 45),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ------------------------------------ 22222222222222222222222222----------------------
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/features/consultation_fee/view_model/consultation_fee_view_model.dart';

class ConsultationFeeScreen extends StatefulWidget {
  const ConsultationFeeScreen({super.key});

  @override
  State<ConsultationFeeScreen> createState() => _ConsultationFeeScreenState();
}

class _ConsultationFeeScreenState extends State<ConsultationFeeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ConsultationFeeViewModel>(
        context,
        listen: false,
      ).fetchConsultationFee(context);
    });
  }

  Widget _buildFeeRow({
    required bool isDark,
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.06),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.exo(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.exo(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color:
                        isDark ? Colors.white.withOpacity(0.6) : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: GoogleFonts.exo(fontSize: 14, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: "0",
                filled: true,
                fillColor:
                    isDark
                        ? Colors.white.withOpacity(0.05)
                        : const Color(0xFFF3F4F6),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = Provider.of<ConsultationFeeViewModel>(context);

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "Consultation Fees",
          style: GoogleFonts.exo(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:
          vm.isConsultationFeeFetchLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF14c7eb)),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      "Set Your Consultation Fees",
                      style: GoogleFonts.exo(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Configure your fees for different consultation types",
                      style: GoogleFonts.exo(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.7)
                                : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Currency Selector Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              isDark
                                  ? Colors.white.withOpacity(0.08)
                                  : Colors.black.withOpacity(0.06),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF14c7eb,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  LucideIcons.dollarSign,
                                  color: Color(0xFF14c7eb),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Currency",
                                style: GoogleFonts.exo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isDark
                                      ? Colors.white.withOpacity(0.05)
                                      : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    isDark
                                        ? Colors.white.withOpacity(0.1)
                                        : Colors.black.withOpacity(0.1),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: vm.currency,
                                isDense: true,
                                style: GoogleFonts.exo(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                                dropdownColor:
                                    isDark
                                        ? const Color(0xFF1E293B)
                                        : Colors.white,
                                items: const [
                                  DropdownMenuItem(
                                    value: "৳",
                                    child: Text("BDT (৳)"),
                                  ),
                                  DropdownMenuItem(
                                    value: "₹",
                                    child: Text("INR (₹)"),
                                  ),
                                  DropdownMenuItem(
                                    value: "\$",
                                    child: Text("USD (\$)"),
                                  ),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    vm.setCurrency(val);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Fee Rows
                    _buildFeeRow(
                      isDark: isDark,
                      title: "60-Minute Consultation",
                      subtitle: "Standard full-length consultation session",
                      controller: vm.feeControllers['consultation60min']!,
                      icon: LucideIcons.clock,
                      iconBg: const Color(0xFF3B82F6).withOpacity(0.1),
                      iconColor: const Color(0xFF3B82F6),
                    ),
                    _buildFeeRow(
                      isDark: isDark,
                      title: "30-Minute Consultation",
                      subtitle: "Quick consultation for minor issues",
                      controller: vm.feeControllers['consultation30min']!,
                      icon: LucideIcons.hourglass,
                      iconBg: const Color(0xFF8B5CF6).withOpacity(0.1),
                      iconColor: const Color(0xFF8B5CF6),
                    ),
                    _buildFeeRow(
                      isDark: isDark,
                      title: "Follow-up Consultation",
                      subtitle: "Reduced fee for returning patients (7 days)",
                      controller: vm.feeControllers['followUp']!,
                      icon: LucideIcons.rotateCcw,
                      iconBg: const Color(0xFF14B8A6).withOpacity(0.1),
                      iconColor: const Color(0xFF14B8A6),
                    ),

                    const SizedBox(height: 24),

                    // Summary Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              isDark
                                  ? Colors.white.withOpacity(0.08)
                                  : Colors.black.withOpacity(0.06),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFF59E0B,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  LucideIcons.info,
                                  color: Color(0xFFF59E0B),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Fee Summary",
                                style: GoogleFonts.exo(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _summaryRow(isDark, "Platform commission", "10%"),
                          _summaryRow(isDark, "Payment processing fee", "2.5%"),
                          _summaryRow(
                            isDark,
                            "Estimated payout",
                            "~87.5% of fee",
                            highlight: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Save Button
                    ShadButton(
                      onPressed:
                          vm.isConsultationFeeUpdating
                              ? null
                              : () async {
                                await vm.updateConsultationFee(context);
                              },
                      width: double.infinity,
                      height: 50,
                      backgroundColor: const Color(0xFF14c7eb),
                      pressedBackgroundColor: const Color(0xFF0EA5C9),
                      child:
                          vm.isConsultationFeeUpdating
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : Text(
                                "Save Fees",
                                style: GoogleFonts.exo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
    );
  }

  Widget _summaryRow(
    bool isDark,
    String label,
    String value, {
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              color:
                  isDark
                      ? Colors.white.withOpacity(0.5)
                      : Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.exo(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color:
                    isDark
                        ? Colors.white.withOpacity(0.7)
                        : Colors.black.withOpacity(0.7),
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.exo(
              fontSize: 13,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
              color:
                  highlight
                      ? const Color(0xFF14c7eb)
                      : (isDark ? Colors.white : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
