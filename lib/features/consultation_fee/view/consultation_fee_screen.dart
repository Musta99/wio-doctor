import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/app_decoration.dart';
import 'package:wio_doctor/core/theme/app_text_styles.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';
import 'package:wio_doctor/features/consultation_fee/view_model/consultation_fee_view_model.dart';

class ConsultationFeeScreen extends StatefulWidget {
  const ConsultationFeeScreen({super.key});

  @override
  State<ConsultationFeeScreen> createState() => _ConsultationFeeScreenState();
}

class _ConsultationFeeScreenState extends State<ConsultationFeeScreen> {
  String currency = "BDT (৳)";
  final Map<String, TextEditingController> feeControllers = {
    "60-Minute Consultation": TextEditingController(text: "1000"),
    "30-Minute Consultation": TextEditingController(text: "250"),
    "Follow-up Consultation": TextEditingController(text: "300"),
    "Online Video Consultation": TextEditingController(text: "0"),
    "Home Visit": TextEditingController(text: "0"),
  };

  bool isSaving = false;

  Widget _buildFeeRow(
    bool isDark,
    String title,
    String subtitle,
    TextEditingController controller,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.title(16)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.body(13)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: AppDecorations.inputDec("Amount", icon, isDark),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ConsultationFeeViewModel>(
        context,
        listen: false,
      ).fetchConsultationFee(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = ThemeProvider.of(context);
    final vm = Provider.of<ConsultationFeeViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultation Fee", style: AppTextStyles.title(20)),
        centerTitle: true,
        automaticallyImplyLeading: true,
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

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Currency selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Currency"),
                DropdownButton<String>(
                  value: vm.currency,
                  items:
                      ["BDT (৳)", "USD (\$)"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      vm.currency = val;
                      vm.notifyListeners();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Fee rows
            Expanded(
              child: ListView(
                children: [
                  _buildFeeRow(
                    isDark,
                    "60-Minute Consultation",
                    "Full consultation session (60 minutes)",
                    vm.feeControllers['60-Minute Consultation']!,
                    Icons.access_time,
                  ),
                  _buildFeeRow(
                    isDark,
                    "30-Minute Consultation",
                    "Quick consultation session (30 minutes)",
                    vm.feeControllers['30-Minute Consultation']!,
                    Icons.hourglass_bottom,
                  ),
                  _buildFeeRow(
                    isDark,
                    "Follow-up Consultation",
                    "Reduced fee for follow-up visits",
                    vm.feeControllers['Follow-up Consultation']!,
                    Icons.update,
                  ),
                  _buildFeeRow(
                    isDark,
                    "Online Video Consultation",
                    "Virtual consultation via video call",
                    vm.feeControllers['Online Video Consultation']!,
                    Icons.videocam,
                  ),
                  _buildFeeRow(
                    isDark,
                    "Home Visit",
                    "Doctor visits patient at home",
                    vm.feeControllers['Home Visit']!,
                    Icons.home,
                  ),

                  const SizedBox(height: 24),
                  // Platform Fee Summary
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: AppDecorations.card(isDark),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Platform Fee Summary",
                          style: AppTextStyles.title(14),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "• Platform commission: 10%",
                          style: AppTextStyles.body(14),
                        ),
                        Text(
                          "• Payment processing fee: 2.5%",
                          style: AppTextStyles.body(14),
                        ),
                        Text(
                          "• Estimated payout: 87.5% of consultation fee",
                          style: AppTextStyles.body(14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Save button
            ShadButton(
              width: double.infinity,
              backgroundColor: Colors.teal,
              child: Text("Save Fees"),
            ),

            SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}
