import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/app_colors.dart';
import 'package:wio_doctor/core/theme/app_decoration.dart';
import 'package:wio_doctor/features/patient_access/view_model/patient_access_view_model.dart';
import 'package:wio_doctor/features/profile/view_model/profile_view_model.dart';
import 'package:wio_doctor/features/profile/widget/virtual_wio_card.dart';
import 'package:wio_doctor/view_model/auth_provider.dart';

class PatientAccessScreen extends StatefulWidget {
  const PatientAccessScreen({super.key});

  @override
  State<PatientAccessScreen> createState() => _PatientAccessScreenState();
}

class _PatientAccessScreenState extends State<PatientAccessScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(context, listen: false).fetchDoctorData();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
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
              // ── Search section ────────────────────────────────
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
                    Column(
                      children: [
                        TextField(
                          controller: _searchCtrl,
                          onChanged: (value) async {
                            if (value.trim().isEmpty) {
                              Provider.of<PatientAccessViewModel>(
                                context,
                                listen: false,
                              ).clearPatients();
                              return;
                            }
                            await Provider.of<PatientAccessViewModel>(
                              context,
                              listen: false,
                            ).findPatient(value, context);
                          },
                          style: GoogleFonts.exo(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: AppDecorations.inputDec(
                            "Search by name, mobile, email or WIO ID",
                            LucideIcons.search,
                            isDark,
                          ).copyWith(
                            suffixIcon: Consumer<PatientAccessViewModel>(
                              builder: (context, vm, _) {
                                return _searchCtrl.text.isNotEmpty
                                    ? IconButton(
                                      icon: const Icon(Icons.close, size: 18),
                                      onPressed: () {
                                        _searchCtrl.clear();
                                        Provider.of<PatientAccessViewModel>(
                                          context,
                                          listen: false,
                                        ).clearPatients();
                                      },
                                    )
                                    : const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),

                        // Patient List Dropdown
                        Consumer<PatientAccessViewModel>(
                          builder: (context, vm, _) {
                            if (vm.isPatientsListLoading) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            if (vm.patientList.isEmpty)
                              return const SizedBox.shrink();

                            return Container(
                              height: 250,
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[900] : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      isDark
                                          ? Colors.grey[700]!
                                          : Colors.grey[300]!,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                itemCount: vm.patientList.length,
                                separatorBuilder:
                                    (_, __) => Divider(
                                      height: 1,
                                      color:
                                          isDark
                                              ? Colors.grey[700]
                                              : Colors.grey[300],
                                    ),
                                itemBuilder: (context, index) {
                                  final patient = vm.patientList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      print("Selected: ${patient['id']}");
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 24,
                                            backgroundImage:
                                                patient['profileImage'] != null
                                                    ? NetworkImage(
                                                      patient['profileImage'],
                                                    )
                                                    : null,
                                            backgroundColor: Colors.blue
                                                .withOpacity(0.1),
                                            child:
                                                patient['profileImage'] == null
                                                    ? Text(
                                                      (patient['name'] ??
                                                              '?')[0]
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                    : null,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  patient['name'] ?? 'Unknown',
                                                  style: GoogleFonts.exo(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  patient['email'] ?? '',
                                                  style: GoogleFonts.exo(
                                                    fontSize: 11,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () async {
                                              if (patient['accessStatus'] ==
                                                  'granted') {
                                                print(
                                                  "Revoke access for ${patient['id']}",
                                                );
                                              } else {
                                                print(
                                                  "Request access for ${patient['id']}",
                                                );
                                                await vm.sendAccessRequest(
                                                  context,
                                                  patient['id'],
                                                );
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    patient['accessStatus'] ==
                                                            'granted'
                                                        ? Colors.red
                                                            .withOpacity(0.1)
                                                        : Colors.blue
                                                            .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color:
                                                      patient['accessStatus'] ==
                                                              'granted'
                                                          ? Colors.red
                                                          : Colors.blue,
                                                ),
                                              ),
                                              child:
                                                  vm.isSendingRequest
                                                      ? SizedBox(
                                                        height: 14,
                                                        width: 14,
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color:
                                                              patient['accessStatus'] ==
                                                                      'granted'
                                                                  ? Colors.red
                                                                  : Colors.blue,
                                                        ),
                                                      )
                                                      : Text(
                                                        patient['accessStatus'] ==
                                                                'granted'
                                                            ? 'Revoke Access'
                                                            : 'Request Access',
                                                        style: GoogleFonts.exo(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              patient['accessStatus'] ==
                                                                      'granted'
                                                                  ? Colors.red
                                                                  : Colors.blue,
                                                        ),
                                                      ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ── Virtual Wio Card ──────────────────────────────
              Consumer<ProfileViewModel>(
                builder: (context, profileVM, _) {
                  return VirtualWioCard(
                    name: profileVM.fullNameC.text,
                    wioId: profileVM.wioId,
                  );
                },
              ),

              const SizedBox(height: 14),

              // ── Doctor QR / WIO section ───────────────────────
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
                            "DoctorId ID: $doctorId",
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
