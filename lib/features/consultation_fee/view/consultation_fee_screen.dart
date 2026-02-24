import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wio_doctor/core/theme/app_decoration.dart';
import 'package:wio_doctor/core/theme/app_text_styles.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';

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
                Text(
                  title,
                  style: GoogleFonts.exo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.exo(fontSize: 13, color: Colors.grey),
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
              decoration: AppDecorations.inputDec("Amount", icon, isDark),
            ),
          ),
        ],
      ),
    );
  }

  void _saveFees() async {
    setState(() => isSaving = true);

    await Future.delayed(const Duration(seconds: 2)); // Simulate save
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Consultation fees saved successfully")),
    );

    setState(() => isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = ThemeProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Consultation Fees")),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Currency selector
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<String>(
                  value: currency,
                  dropdownColor: Colors.grey.shade900,
                  items:
                      ["BDT (৳)", "USD (\$)"]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => currency = val);
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
                    feeControllers["60-Minute Consultation"]!,
                    Icons.access_time,
                  ),
                  _buildFeeRow(
                    isDark,
                    "30-Minute Consultation",
                    "Quick consultation session (30 minutes)",
                    feeControllers["30-Minute Consultation"]!,
                    Icons.hourglass_bottom,
                  ),
                  _buildFeeRow(
                    isDark,
                    "Follow-up Consultation",
                    "Reduced fee for follow-up visits",
                    feeControllers["Follow-up Consultation"]!,
                    Icons.update,
                  ),
                  _buildFeeRow(
                    isDark,
                    "Online Video Consultation",
                    "Virtual consultation via video call",
                    feeControllers["Online Video Consultation"]!,
                    Icons.videocam,
                  ),
                  _buildFeeRow(
                    isDark,
                    "Home Visit",
                    "Doctor visits patient at home",
                    feeControllers["Home Visit"]!,
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
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : _saveFees,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          "Save Fees",
                          style: GoogleFonts.exo(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
