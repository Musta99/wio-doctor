import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/services/time_formate_service.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';
import 'package:wio_doctor/features/clinical_review/view/clinical_review_screen.dart';
import 'package:wio_doctor/features/consultation_fee/view/consultation_fee_screen.dart';
import 'package:wio_doctor/features/dashboard/view_model/dashboard_view_model.dart';
import 'package:wio_doctor/features/dashboard/widgets/appointment_state_card.dart';
import 'package:wio_doctor/features/dashboard/widgets/patient_card.dart';
import 'package:wio_doctor/features/dashboard/widgets/unverified_banner.dart';
import 'package:wio_doctor/features/digital_prescription/view/digital_prescription_screen.dart';
import 'package:wio_doctor/features/earnings/view/earning_screen.dart';
import 'package:wio_doctor/features/patient/view/patient_details_screen.dart';
import 'package:wio_doctor/features/patient_access/view/patient_access_screen.dart';
import 'package:wio_doctor/features/report-verification/view/report_verification_screen.dart';
import 'package:wio_doctor/features/wio_case_discussion/view/wio_case_discussion_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  _HeaderPalette _paletteForNow(bool isDark) {
    final hour = DateTime.now().hour;

    // Morning: 5-11, Noon: 12-15, Evening: 16-19, Night: 20-4
    if (hour >= 5 && hour <= 11) {
      return _HeaderPalette(
        title: "Good Morning",
        colors:
            isDark
                ? const [Color(0xFF14c7eb), Color(0xFF14c7eb)]
                : const [Color(0xFF14c7eb), Color(0xFF14c7eb)],
      );
    } else if (hour >= 12 && hour <= 15) {
      return _HeaderPalette(
        title: "Good Afternoon",
        colors:
            isDark
                ? const [Color(0xFF14c7eb), Color(0xFF14c7eb)]
                : const [Color(0xFF14c7eb), Color(0xFF14c7eb)],
      );
    } else if (hour >= 16 && hour <= 19) {
      return _HeaderPalette(
        title: "Good Evening",
        colors:
            isDark
                ? const [Color(0xFF14c7eb), Color(0xFF14c7eb)]
                : const [Color(0xFF14c7eb), Color(0xFF14c7eb)],
      );
    } else {
      return _HeaderPalette(
        title: "Good Night",
        colors:
            isDark
                ? const [Color(0xFF14c7eb), Color(0xFF14c7eb)]
                : const [Color(0xFF14c7eb), Color(0xFF14c7eb)],
      );
    }
  }

  String _formatLastVisit(dynamic value) {
    if (value == null) return "New Visit";

    // Firestore Timestamp support
    if (value is Timestamp) {
      return TimeFormateService().formatDate(value);
    }

    // DateTime support
    if (value is DateTime) {
      return _formatDateTime(value);
    }

    // String support from API
    if (value is String) {
      final trimmed = value.trim();

      if (trimmed.isEmpty || trimmed == "N/A") {
        return "New Visit";
      }

      final parsedDate = DateTime.tryParse(trimmed);
      if (parsedDate != null) {
        return _formatDateTime(parsedDate);
      }

      return trimmed;
    }

    return value.toString();
  }

  String _formatDateTime(DateTime date) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use new combined fetch method
      Provider.of<DashboardViewModel>(
        context,
        listen: false,
      ).fetchDashboardData();
      Provider.of<DashboardViewModel>(
        context,
        listen: false,
      ).fetchDoctorProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = _paletteForNow(isDark);

    final bg = isDark ? Colors.black : const Color(0xFFF8FAFC);
    final onHeader =
        isDark
            ? Colors.white.withOpacity(0.95)
            : Colors.white.withOpacity(0.96);

    return Scaffold(
      backgroundColor: bg,
      extendBodyBehindAppBar: true,
      endDrawerEnableOpenDragGesture: false,
      // ✅ END DRAWER
      endDrawer: _DashboardEndDrawer(isDark: isDark),
      // ✅ bKash-like top header (AppBar background changes by time)
      appBar: AppBar(
        toolbarHeight: 150,
        leading: const SizedBox.shrink(),
        actions: const [SizedBox.shrink()],
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        flexibleSpace: Stack(
          children: [
            // Gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: palette.colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Soft decorative layers (healthcare vibe)
            CustomPaint(
              painter: _HeaderWavePainter(
                isDark: isDark,
                accent: const Color(0xFF0D9488),
              ),
              size: const Size(double.infinity, 200),
            ),

            // Top content
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row: avatar + name + actions (search, notif, theme)
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: onHeader, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.18),
                                blurRadius: 14,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Consumer<DashboardViewModel>(
                            builder: (context, dashboardVM, child) {
                              return CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    dashboardVM.photo == null ||
                                            dashboardVM.photo!.isEmpty
                                        ? const AssetImage(
                                          "assets/icons/user-icon.png",
                                        )
                                        : NetworkImage(dashboardVM.photo!),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                palette.title,
                                style: GoogleFonts.exo(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: onHeader.withOpacity(0.90),
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Consumer<DashboardViewModel>(
                                builder: (context, dashboardVM, child) {
                                  return Text(
                                    dashboardVM.name == null ||
                                            dashboardVM.name!.isEmpty
                                        ? "Dr. Alex Riveira"
                                        : dashboardVM.name!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.exo(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: onHeader,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),
                        _CircleIconButton(
                          onTap: () {
                            // TODO: notifications
                          },
                          icon: LucideIcons.bell,
                          isDarkHeader: true,
                        ),
                        const SizedBox(width: 10),
                        Builder(
                          builder:
                              (context) => _CircleIconButton(
                                onTap: () {
                                  Scaffold.of(context).openEndDrawer();
                                },
                                icon: LucideIcons.menu,
                                isDarkHeader: true,
                              ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // bKash-like pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(isDark ? 0.10 : 0.18),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(isDark ? 0.22 : 0.28),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(0.22),
                            ),
                            child: const Icon(
                              LucideIcons.badgeCheck,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Consumer<DashboardViewModel>(
                            builder: (context, dashboardVm, child) {
                              return Text(
                                "${dashboardVm.specialization == null || dashboardVm.specialization!.isEmpty ? "Cardiologist" : dashboardVm.specialization} • WIO ID: ${dashboardVm.wioId == null || dashboardVm.wioId!.isEmpty ? "XXXXXXX" : dashboardVm.wioId}",
                                style: GoogleFonts.exo(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: onHeader,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ✅ Keep your contents & ListView builder logic — only design changes
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 220, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unverified Banner
            const UnverifiedBanner(),

            // A white rounded sheet like bKash (makes the header look premium)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color:
                      isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.black.withOpacity(0.06),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Statistics Cards Row 1 (Original)
                  Consumer<DashboardViewModel>(
                    builder: (context, dashboardVM, child) {
                      return Row(
                        children: [
                          Expanded(
                            child: AppointmentStateCard(
                              icon: Icons.people_outline,
                              count: dashboardVM.totalPatients.toString(),
                              label: "Total Patients",
                              color: const Color(0xFF8B5CF6),
                              lightColor:
                                  isDark
                                      ? const Color(0xFF312E81)
                                      : const Color(0xFFF3E8FF),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppointmentStateCard(
                              icon: Icons.description_outlined,
                              count:
                                  dashboardVM.pendingReports?.toString() ?? "0",
                              label: "Pending Reports",
                              color: const Color(0xFFEF4444),
                              lightColor:
                                  isDark
                                      ? const Color(0xFF7F1D1D)
                                      : const Color(0xFFFEE2E2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppointmentStateCard(
                              icon: Icons.event_available,
                              count:
                                  dashboardVM.consultationsToday?.toString() ??
                                  "0",
                              label: "Consultations Today",
                              color: const Color(0xFF0D9488),
                              lightColor:
                                  isDark
                                      ? const Color(0xFF134E4A)
                                      : const Color(0xFFCCFBF1),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  // Statistics Cards Row 2 (New - Consultation Details)
                  Consumer<DashboardViewModel>(
                    builder: (context, dashboardVM, child) {
                      final remaining = dashboardVM.remainingToday ?? 0;
                      final completed = dashboardVM.completedToday ?? 0;

                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isDark
                                        ? const Color(0xFF1E293B)
                                        : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "$completed",
                                    style: GoogleFonts.exo(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: const Color(0xFF10B981),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Completed",
                                    style: GoogleFonts.exo(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          isDark
                                              ? Colors.white70
                                              : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isDark
                                        ? const Color(0xFF1E293B)
                                        : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "$remaining",
                                    style: GoogleFonts.exo(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color:
                                          remaining > 0
                                              ? const Color(0xFFF59E0B)
                                              : const Color(0xFF6B7280),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Remaining",
                                    style: GoogleFonts.exo(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          isDark
                                              ? Colors.white70
                                              : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  // Small quick strip (optional vibe, not breaking your content)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.04)
                              : const Color(0xFFF3F4F8),
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
                        const Icon(
                          LucideIcons.activity,
                          size: 18,
                          color: Color(0xFF14c7eb),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Consumer<DashboardViewModel>(
                            builder: (context, dashboardVM, child) {
                              final remaining = dashboardVM.remainingToday ?? 0;
                              return Text(
                                remaining > 0
                                    ? "You have $remaining consultations remaining today."
                                    : "All consultations completed for today!",
                                style: GoogleFonts.exo(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      isDark
                                          ? Colors.white.withOpacity(0.84)
                                          : Colors.black.withOpacity(0.72),
                                ),
                              );
                            },
                          ),
                        ),
                        Icon(
                          LucideIcons.chevronRight,
                          size: 18,
                          color:
                              isDark
                                  ? Colors.white.withOpacity(0.55)
                                  : Colors.black.withOpacity(0.40),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Section Header (Patient Roster)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color:
                      isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.black.withOpacity(0.06),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Patient Roster",
                        style: GoogleFonts.exo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF1F2937),
                        ),
                      ),
                      Consumer<DashboardViewModel>(
                        builder: (context, dashboardVM, child) {
                          return Text(
                            "${dashboardVM.roasterPatients.length} of ${dashboardVM.totalPatients}",
                            style: GoogleFonts.exo(
                              fontSize: 14,
                              color: const Color(0xFF0D9488),
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Patient List -- Patient Roster
                  Consumer<DashboardViewModel>(
                    builder: (context, dashboardVM, child) {
                      final patients = dashboardVM.roasterPatients;

                      // Case 1 → Loading + empty (initial load)
                      if (dashboardVM.isLoadingPatientRoaster &&
                          patients.isEmpty) {
                        return Column(
                          children: [
                            const SizedBox(height: 20),
                            const CircularProgressIndicator(
                              color: Color(0xFF14c7eb),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Loading patient roster...",
                              style: GoogleFonts.exo(
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        );
                      }

                      // Case 2 → Not loading + empty
                      if (!dashboardVM.isLoadingPatientRoaster &&
                          patients.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(
                                LucideIcons.circleAlert,
                                size: 48,
                                color: isDark ? Colors.white38 : Colors.black26,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "No patients found",
                                style: GoogleFonts.exo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isDark ? Colors.white70 : Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Patients will appear here once they grant you access",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.exo(
                                  fontSize: 13,
                                  color:
                                      isDark ? Colors.white60 : Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Case 3 → List has data
                      return Stack(
                        children: [
                          Column(
                            children: [
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: patients.length,
                                itemBuilder: (context, index) {
                                  final patientDetails =
                                      patients[index] as Map<String, dynamic>;

                                  // Determine access status (matching web version)
                                  final bool hasAccess =
                                      patientDetails["hasAccess"] == true;
                                  final String statusText =
                                      hasAccess
                                          ? "Full Access"
                                          : "Last Visit Only";
                                  final Color statusColor =
                                      hasAccess
                                          ? const Color(0xFF0D9488)
                                          : Colors.grey;

                                  return PatientCard(
                                    name:
                                        patientDetails["name"] ??
                                        patientDetails["patientName"] ??
                                        "Unknown",
                                    sex:
                                        patientDetails["gender"] ??
                                        patientDetails["sex"] ??
                                        "N/A",
                                    lastVisited: _formatLastVisit(
                                      patientDetails["lastVisit"],
                                    ),
                                    status: statusText,
                                    statusColor: statusColor,
                                    onPressed: () {
                                      if (hasAccess) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => PatientDetailsScreen(
                                                  patientId:
                                                      patientDetails["id"] ??
                                                      patientDetails["patientId"],
                                                ),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) =>
                                                    const PatientAccessScreen(),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),

                              // Pagination Controls
                              if (dashboardVM.totalPages > 1)
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _PaginationButton(
                                        icon: LucideIcons.chevronLeft,
                                        onPressed:
                                            dashboardVM.currentPage > 1 &&
                                                    !dashboardVM
                                                        .isPaginationLoading
                                                ? () => dashboardVM.goToPage(
                                                  dashboardVM.currentPage - 1,
                                                )
                                                : null,
                                        isDark: isDark,
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              isDark
                                                  ? Colors.white.withOpacity(
                                                    0.1,
                                                  )
                                                  : const Color(0xFFF3F4F6),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (dashboardVM
                                                .isPaginationLoading) ...[
                                              SizedBox(
                                                width: 14,
                                                height: 14,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(
                                                        isDark
                                                            ? Colors.white
                                                            : Colors.black87,
                                                      ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                            ],
                                            Text(
                                              "Page ${dashboardVM.currentPage} of ${dashboardVM.totalPages}",
                                              style: GoogleFonts.exo(
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    isDark
                                                        ? Colors.white
                                                        : Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      _PaginationButton(
                                        icon: LucideIcons.chevronRight,
                                        onPressed:
                                            dashboardVM.currentPage <
                                                        dashboardVM
                                                            .totalPages &&
                                                    !dashboardVM
                                                        .isPaginationLoading
                                                ? () => dashboardVM.goToPage(
                                                  dashboardVM.currentPage + 1,
                                                )
                                                : null,
                                        isDark: isDark,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),

                          // Loading overlay during pagination
                          if (dashboardVM.isPaginationLoading)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: (isDark ? Colors.black : Colors.white)
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color:
                                          isDark
                                              ? const Color(0xFF1E293B)
                                              : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const CircularProgressIndicator(
                                          color: Color(0xFF14c7eb),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          "Loading page ${dashboardVM.currentPage}...",
                                          style: GoogleFonts.exo(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                isDark
                                                    ? Colors.white
                                                    : Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderPalette {
  final String title;
  final List<Color> colors;
  const _HeaderPalette({required this.title, required this.colors});
}

class _CircleIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final bool isDarkHeader;

  const _CircleIconButton({
    required this.onTap,
    required this.icon,
    required this.isDarkHeader,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.18),
          border: Border.all(color: Colors.white.withOpacity(0.22)),
        ),
        child: Icon(icon, size: 18, color: Colors.white.withOpacity(0.95)),
      ),
    );
  }
}

// Pagination Button Widget
class _PaginationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isDark;

  const _PaginationButton({
    required this.icon,
    required this.onPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              onPressed != null
                  ? (isDark
                      ? Colors.white.withOpacity(0.1)
                      : const Color(0xFFF3F4F6))
                  : (isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isDark
                    ? Colors.white.withOpacity(onPressed != null ? 0.2 : 0.1)
                    : Colors.black.withOpacity(onPressed != null ? 0.1 : 0.05),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color:
              onPressed != null
                  ? (isDark ? Colors.white : Colors.black87)
                  : (isDark ? Colors.white38 : Colors.black38),
        ),
      ),
    );
  }
}

class _DashboardEndDrawer extends StatelessWidget {
  final bool isDark;
  const _DashboardEndDrawer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor =
        isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.06);
    final subtleText =
        isDark
            ? Colors.white.withOpacity(0.72)
            : Colors.black.withOpacity(0.65);

    Widget item({
      required IconData icon,
      required String title,
      required VoidCallback onTap,
    }) {
      return InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color:
                isDark
                    ? Colors.white.withOpacity(0.04)
                    : const Color(0xFFF3F4F8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(
                    0xFF14c7eb,
                  ).withOpacity(isDark ? 0.14 : 0.10),
                  border: Border.all(
                    color: const Color(
                      0xFF14c7eb,
                    ).withOpacity(isDark ? 0.25 : 0.18),
                  ),
                ),
                child: Icon(icon, size: 22, color: const Color(0xFF14c7eb)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.exo(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Icon(LucideIcons.chevronRight, size: 18, color: subtleText),
            ],
          ),
        ),
      );
    }

    return Drawer(
      width: 320,
      shape: const RoundedRectangleBorder(),
      backgroundColor: cardColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Quick Access",
                      style: GoogleFonts.exo(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  // ── Theme toggle ──────────────────────────────
                  Consumer<ThemeViewModel>(
                    builder: (context, themeProvider, _) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(999),
                        onTap: () {
                          themeProvider.setThemeMode(
                            themeProvider.isDarkMode
                                ? ThemeMode.light
                                : ThemeMode.dark,
                          );
                        },
                        child: Container(
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isDark
                                    ? Colors.white.withOpacity(0.06)
                                    : Colors.black.withOpacity(0.04),
                            border: Border.all(color: borderColor),
                          ),
                          child: Icon(
                            themeProvider.isDarkMode
                                ? LucideIcons.sun
                                : LucideIcons.moon,
                            size: 18,
                            color:
                                isDark
                                    ? Colors.white.withOpacity(0.85)
                                    : Colors.black.withOpacity(0.8),
                          ),
                        ),
                      );
                    },
                  ),
                  // ─────────────────────────────────────────────
                  const SizedBox(width: 8),
                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.06)
                                : Colors.black.withOpacity(0.04),
                        border: Border.all(color: borderColor),
                      ),
                      child: Icon(
                        LucideIcons.x,
                        size: 18,
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.85)
                                : Colors.black.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                "Tools for clinical workflow & patient operations.",
                style: GoogleFonts.exo(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: subtleText,
                ),
              ),

              const SizedBox(height: 14),

              item(
                icon: LucideIcons.dollarSign,
                title: "Consultation Fee",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ConsultationFeeScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),

              item(
                icon: LucideIcons.users,
                title: "Patient Access",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PatientAccessScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              item(
                icon: LucideIcons.fileText,
                title: "Digital Prescriber",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DigitalPrescriberScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              item(
                icon: LucideIcons.stethoscope,
                title: "Clinical Review",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ClinicalReviewScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              item(
                icon: LucideIcons.messagesSquare,
                title: "Case Discussion",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WioCaseDiscussionScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),
              item(
                icon: LucideIcons.dollarSign,
                title: "Earning",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EarningScreen()),
                  );
                },
              ),

              const SizedBox(height: 10),
              item(
                icon: LucideIcons.dollarSign,
                title: "Report Verification",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportVerificationScreen(),
                    ),
                  );
                },
              ),

              const Spacer(),

              // Disclaimer
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? Colors.white.withOpacity(0.04)
                          : const Color(0xFFF3F4F8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  "Disclaimer: This section provides quick access to tools. Always follow clinical guidelines and verify patient information before making decisions.",
                  style: GoogleFonts.exo(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: subtleText,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Decorative wave/hills like bKash header (no images needed)
class _HeaderWavePainter extends CustomPainter {
  final bool isDark;
  final Color accent;

  _HeaderWavePainter({required this.isDark, required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final p1 =
        Paint()
          ..color = Colors.white.withOpacity(isDark ? 0.06 : 0.10)
          ..style = PaintingStyle.fill;

    final p2 =
        Paint()
          ..color = Colors.white.withOpacity(isDark ? 0.08 : 0.12)
          ..style = PaintingStyle.fill;

    final p3 =
        Paint()
          ..color = accent.withOpacity(isDark ? 0.10 : 0.10)
          ..style = PaintingStyle.fill;

    // Layer 1 (far)
    final path1 =
        Path()
          ..moveTo(0, size.height * 0.55)
          ..quadraticBezierTo(
            size.width * 0.25,
            size.height * 0.48,
            size.width * 0.52,
            size.height * 0.56,
          )
          ..quadraticBezierTo(
            size.width * 0.78,
            size.height * 0.64,
            size.width,
            size.height * 0.58,
          )
          ..lineTo(size.width, 0)
          ..lineTo(0, 0)
          ..close();
    canvas.drawPath(path1, p1);

    // Layer 2 (mid)
    final path2 =
        Path()
          ..moveTo(0, size.height * 0.70)
          ..quadraticBezierTo(
            size.width * 0.22,
            size.height * 0.62,
            size.width * 0.50,
            size.height * 0.70,
          )
          ..quadraticBezierTo(
            size.width * 0.78,
            size.height * 0.78,
            size.width,
            size.height * 0.72,
          )
          ..lineTo(size.width, 0)
          ..lineTo(0, 0)
          ..close();
    canvas.drawPath(path2, p2);

    // Accent blob
    final path3 =
        Path()
          ..moveTo(size.width * 0.62, size.height * 0.18)
          ..quadraticBezierTo(
            size.width * 0.78,
            size.height * 0.10,
            size.width * 0.88,
            size.height * 0.22,
          )
          ..quadraticBezierTo(
            size.width * 0.98,
            size.height * 0.36,
            size.width * 0.78,
            size.height * 0.40,
          )
          ..quadraticBezierTo(
            size.width * 0.56,
            size.height * 0.42,
            size.width * 0.62,
            size.height * 0.18,
          )
          ..close();
    canvas.drawPath(path3, p3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
