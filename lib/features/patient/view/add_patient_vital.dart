import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/services/time_formate_service.dart';
import 'package:wio_doctor/features/patient/view_model/patient_view_model.dart';
import 'package:wio_doctor/view_model/date_picker_view_model.dart';

class AddVitalsScreen extends StatefulWidget {
  final String patientId;
  const AddVitalsScreen({super.key, required this.patientId});

  @override
  State<AddVitalsScreen> createState() => _AddVitalsScreenState();
}

class _AddVitalsScreenState extends State<AddVitalsScreen> {
  final systolicController = TextEditingController();
  final diastolicController = TextEditingController();
  final sugarController = TextEditingController();

  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    systolicController.dispose();
    diastolicController.dispose();
    sugarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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

    InputDecoration inputDec(String hint, IconData icon) {
      return InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.exo(
          color: subtleText,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(icon, size: 18),
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
          borderSide: BorderSide(color: Colors.teal.withOpacity(0.6)),
        ),
      );
    }

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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Vitals",
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Container(
              decoration: cardDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vitals entry",
                      style: GoogleFonts.exo(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Pick date and add vitals.",
                      style: GoogleFonts.exo(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: subtleText,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ✅ Calendar picker
                    Consumer<DatePickerProvider>(
                      builder: (context, datePickerVM, child) {
                        return GestureDetector(
                          onTap: () async {
                            await datePickerVM.pickDate(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isDark
                                      ? Colors.white.withOpacity(0.04)
                                      : const Color(0xFFF3F4F8),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.calendar, size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    datePickerVM.selectedDate == null
                                        ? "Select date"
                                        : "${datePickerVM.selectedDate!.year}-${datePickerVM.selectedDate!.month}-${datePickerVM.selectedDate!.day}",
                                    style: GoogleFonts.exo(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Icon(
                                  LucideIcons.chevronDown,
                                  size: 18,
                                  color: subtleText,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 14),

                    // BP fields
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: systolicController,
                            keyboardType: TextInputType.number,
                            decoration: inputDec(
                              "Systolic",
                              LucideIcons.heartPulse,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: diastolicController,
                            keyboardType: TextInputType.number,
                            decoration: inputDec(
                              "Diastolic",
                              LucideIcons.heartPulse,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Sugar
                    TextField(
                      controller: sugarController,
                      decoration: inputDec("Blood sugar", LucideIcons.droplet),
                    ),

                    const SizedBox(height: 16),

                    Consumer<PatientViewModel>(
                      builder: (context, patientVM, child) {
                        return ShadButton(
                          width: double.infinity,
                          backgroundColor: Colors.teal,
                          onPressed: () async {
                            final selectedDate =
                                Provider.of<DatePickerProvider>(
                                  context,
                                  listen: false,
                                ).selectedDate;
                            await patientVM.addNewVitals(
                              widget.patientId,
                              "${systolicController.text.trim()}/${diastolicController.text.trim()}",
                              int.parse(sugarController.text.trim()),
                              "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}",
                              "",
                            );
                            Provider.of<DatePickerProvider>(
                              context,
                              listen: false,
                            ).clearDate();

                            systolicController.clear();
                            diastolicController.clear();
                            sugarController.clear();

                            Navigator.pop(context);
                          },
                          child:
                              patientVM.isPatientVitalsAddLoading
                                  ? Text(
                                    "Saving...",
                                    style: GoogleFonts.exo(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  )
                                  : Text(
                                    "Save",
                                    style: GoogleFonts.exo(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
