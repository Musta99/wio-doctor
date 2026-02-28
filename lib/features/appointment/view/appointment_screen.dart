import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/app_colors.dart';
import 'package:wio_doctor/core/theme/app_decoration.dart';
import 'package:wio_doctor/core/theme/app_text_styles.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';
import 'package:wio_doctor/features/appointment/view/all_appointment_list.dart';
import 'package:wio_doctor/features/appointment/view_model/appointment_view_model.dart';
import 'package:wio_doctor/features/appointment/widgets/appointment_card_widget.dart';
import 'package:wio_doctor/widgets/avatar_circle_widget.dart';
import 'package:wio_doctor/widgets/pill_chip_widget.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final _searchController = TextEditingController();

  // Demo data (replace with Provider/API)
  final List<Map<String, dynamic>> _latestAppointments = [
    {
      "name": "Ayesha Rahman",
      "id": "WIO-PT-01924",
      "date": "12 Feb 2026",
      "time": "10:30 AM",
      "type": "Instant Video",
      "status": "Pending",
      "payment": "Unpaid",
    },
    {
      "name": "Mahfuz Ahmed",
      "id": "WIO-PT-01581",
      "date": "12 Feb 2026",
      "time": "12:00 PM",
      "type": "Appointment",
      "status": "Confirmed",
      "payment": "Paid",
    },
    {
      "name": "Nusrat Jahan",
      "id": "WIO-PT-02210",
      "date": "13 Feb 2026",
      "time": "09:15 AM",
      "type": "In Clinic",
      "status": "Confirmed",
      "payment": "Paid",
    },
  ];

  final List<Map<String, dynamic>> _videoHistory = [
    {
      "name": "Raihan Kabir",
      "id": "WIO-PT-01077",
      "date": "10 Feb 2026",
      "time": "08:40 PM",
      "duration": "12m 18s",
      "status": "Completed",
    },
    {
      "name": "Tasnim Islam",
      "id": "WIO-PT-02133",
      "date": "09 Feb 2026",
      "time": "06:05 PM",
      "duration": "09m 02s",
      "status": "Completed",
    },
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppointmentViewModel>(
        context,
        listen: false,
      ).fetchDoctorsAppointments(context);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    final isDark = themeProvider.isDarkMode;

    Widget videoCard(Map<String, dynamic> v) {
      return Container(
        decoration: AppDecorations.card(isDark),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              AvatarCircleWidget(name: v["name"] ?? "Patient", isDark: isDark),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v["name"] ?? "",
                      style: AppTextStyles.body(
                        15,
                      ).copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${v["id"] ?? ""} • ${v["date"] ?? ""} • ${v["time"] ?? ""}",
                      style: AppTextStyles.body(
                        12,
                      ).copyWith(color: AppColors.subtleText(isDark)),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        PillChipWidget(
                          text: "Duration: ${v["duration"] ?? "-"}",
                          icon: LucideIcons.timer,
                          statusKey: "completed",
                          isDark: isDark,
                        ),
                        PillChipWidget(
                          text: v["status"] ?? "Completed",
                          icon: LucideIcons.video,
                          statusKey: "completed",
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color:
                        isDark
                            ? Colors.white.withOpacity(0.06)
                            : Colors.black.withOpacity(0.04),
                    border: Border.all(color: AppColors.border(isDark)),
                  ),
                  child: const Icon(LucideIcons.eye, size: 18),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Filter appointments by search (name/id)
    final pending =
        _latestAppointments
            .where(
              (e) => (e["status"] ?? "").toString().toLowerCase().contains(
                "pending",
              ),
            )
            .length;

    return Scaffold(
      appBar: AppBar(
        title: Text("Appointments", style: AppTextStyles.title(20)),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bgTop(isDark), AppColors.bgBottom(isDark)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<AppointmentViewModel>(
          builder: (context, appointmentVM, child) {
            if (appointmentVM.isLoadingAppointmentsFetch &&
                appointmentVM.appointmentsList.isEmpty) {
              return Center(
                child: CircularProgressIndicator(color: Colors.teal),
              );
            }
            if (!appointmentVM.isLoadingAppointmentsFetch &&
                appointmentVM.appointmentsList.isEmpty) {
              return Center(child: Text("You don't have any appointments"));
            }

            List appointmentsList = (appointmentVM.appointmentsList ?? []);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =========================================================
                    // 1) Booked Appointments (header + search + stats column-wise)
                    // =========================================================
                    Container(
                      decoration: AppDecorations.card(isDark),
                      child: Padding(
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
                                    color:
                                        isDark
                                            ? Colors.white.withOpacity(0.06)
                                            : Colors.black.withOpacity(0.04),
                                  ),
                                  child: Icon(
                                    LucideIcons.clipboardList,
                                    size: 18,
                                    color:
                                        isDark
                                            ? Colors.white.withOpacity(0.88)
                                            : Colors.black.withOpacity(0.82),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Booked Appointments",
                                        style: AppTextStyles.section(18),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "View and manage all your confirmed and pending appointments.",
                                        style: AppTextStyles.body(13).copyWith(
                                          color: AppColors.subtleText(isDark),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            // TextField(
                            //   controller: _searchController,
                            //   onChanged: (_) => setState(() {}),
                            //   decoration: searchDecoration(),
                            //   style: bodyStyle(14),
                            // ),
                            // const SizedBox(height: 14),

                            // Stats in COLUMN (as you asked)
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    isDark
                                        ? Colors.white.withOpacity(0.04)
                                        : const Color(0xFFF3F4F8),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.border(isDark),
                                ),
                              ),
                              child: Column(
                                children: [
                                  _StatRow(
                                    isDark: isDark,
                                    borderColor: AppColors.border(isDark),
                                    subtleText: AppColors.subtleText(isDark),
                                    title: "Total appointments",
                                    value: appointmentsList.length.toString(),
                                    icon: LucideIcons.layers,
                                    accent: Colors.blue,
                                  ),
                                  _DividerLine(
                                    borderColor: AppColors.border(isDark),
                                  ),
                                  _StatRow(
                                    isDark: isDark,
                                    borderColor: AppColors.border(isDark),
                                    subtleText: AppColors.subtleText(isDark),
                                    title: "Pending approvals",
                                    value: "$pending",
                                    icon: LucideIcons.clock3,
                                    accent: Colors.orange,
                                  ),
                                  // _DividerLine(borderColor: borderColor),
                                  // _StatRow(
                                  //   isDark: isDark,
                                  //   borderColor: borderColor,
                                  //   subtleText: subtleText,
                                  //   title: "Expected revenue",
                                  //   value: expectedRevenue,
                                  //   icon: LucideIcons.badgeDollarSign,
                                  //   accent: Colors.green,
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // =========================================================
                    // 2) Latest Appointments (separate section)
                    // =========================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Latest appointments",
                          style: AppTextStyles.section(18),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllAppointmentList(),
                              ),
                            );
                          },
                          child: Text(
                            "See All",
                            style: GoogleFonts.exo(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    if (appointmentsList.isEmpty)
                      Container(
                        decoration: AppDecorations.card(isDark),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            "No appointments found for your search.",
                            style: AppTextStyles.body(
                              13,
                            ).copyWith(color: AppColors.subtleText(isDark)),
                          ),
                        ),
                      ),

                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          appointmentsList.length < 5
                              ? appointmentsList.length
                              : 6,
                      itemBuilder: (context, index) {
                        return AppointmentCardWidget(
                          appointment: appointmentsList[index],
                          isDark: isDark,
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // =========================================================
                    // 3) Video Call History (separate section)
                    // =========================================================
                    Text(
                      "Video call history",
                      style: AppTextStyles.section(18),
                    ),
                    const SizedBox(height: 10),

                    if (_videoHistory.isEmpty)
                      Container(
                        decoration: AppDecorations.card(isDark),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            "No video call history yet.",
                            style: AppTextStyles.body(
                              13,
                            ).copyWith(color: AppColors.subtleText(isDark)),
                          ),
                        ),
                      ),

                    for (final v in _videoHistory) ...[
                      videoCard(v),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Small internal helpers (kept minimal and only for the stats separators/rows)
class _DividerLine extends StatelessWidget {
  final Color borderColor;
  const _DividerLine({required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: borderColor);
  }
}

class _StatRow extends StatelessWidget {
  final bool isDark;
  final Color borderColor;
  final Color subtleText;
  final String title;
  final String value;
  final IconData icon;
  final Color accent;

  const _StatRow({
    required this.isDark,
    required this.borderColor,
    required this.subtleText,
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: accent.withOpacity(isDark ? 0.14 : 0.10),
              border: Border.all(
                color: accent.withOpacity(isDark ? 0.25 : 0.18),
              ),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.exo(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: subtleText,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.exo(fontSize: 15, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
