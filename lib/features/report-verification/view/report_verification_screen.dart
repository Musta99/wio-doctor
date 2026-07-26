import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wio_doctor/features/report-verification/viewmodel/report_verification_view_model.dart';

class ReportVerificationScreen extends StatefulWidget {
  const ReportVerificationScreen({super.key});

  @override
  State<ReportVerificationScreen> createState() =>
      _ReportVerificationScreenState();
}

class _ReportVerificationScreenState extends State<ReportVerificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportVerificationViewModel>().loadQueue();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "Report Verification",
          style: GoogleFonts.exo(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<ReportVerificationViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoadingQueue && vm.queueItems.isEmpty) {
            return _QueueLoadingView(isDark: isDark);
          }

          if (vm.errorMessage != null &&
              vm.queueItems.isEmpty &&
              vm.selectedVerificationId == null) {
            return _ErrorState(
              isDark: isDark,
              message: vm.errorMessage!,
              onRetry: vm.loadQueue,
            );
          }

          return RefreshIndicator(
            color: const Color(0xFF14c7eb),
            onRefresh: vm.loadQueue,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeaderSection(isDark: isDark, vm: vm),
                  const SizedBox(height: 16),
                  if (vm.selectedVerificationId == null)
                    _QueueSection(isDark: isDark, vm: vm)
                  else
                    _DetailSection(isDark: isDark, vm: vm),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final bool isDark;
  final ReportVerificationViewModel vm;

  const _HeaderSection({required this.isDark, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Report Verification",
          style: GoogleFonts.exo(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Review patient medical reports and provide professional verification.",
          style: GoogleFonts.exo(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color:
                isDark
                    ? Colors.white.withOpacity(0.65)
                    : Colors.black.withOpacity(0.60),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                isDark: isDark,
                title: "Open Requests",
                value: vm.openCount.toString(),
                color: const Color(0xFFF59E0B),
                icon: LucideIcons.circleAlert,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                isDark: isDark,
                title: "Claimed",
                value: vm.claimedByMeCount.toString(),
                color: const Color(0xFF3B82F6),
                icon: LucideIcons.clipboardCheck,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatCard(
                isDark: isDark,
                title: "Verified",
                value: vm.verifiedByMeCount.toString(),
                color: const Color(0xFF10B981),
                icon: LucideIcons.badgeCheck,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final bool isDark;
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.isDark,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.exo(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: GoogleFonts.exo(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color:
                  isDark
                      ? Colors.white.withOpacity(0.6)
                      : Colors.black.withOpacity(0.55),
            ),
          ),
        ],
      ),
    );
  }
}

class _QueueSection extends StatelessWidget {
  final bool isDark;
  final ReportVerificationViewModel vm;

  const _QueueSection({required this.isDark, required this.vm});

  @override
  Widget build(BuildContext context) {
    if (vm.queueItems.isEmpty) {
      return _CardShell(
        isDark: isDark,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
          child: Column(
            children: [
              Icon(
                LucideIcons.clipboardCheck,
                size: 44,
                color:
                    isDark
                        ? Colors.white.withOpacity(0.25)
                        : Colors.black.withOpacity(0.20),
              ),
              const SizedBox(height: 12),
              Text(
                "Nothing to review",
                style: GoogleFonts.exo(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "No report verification requests right now.",
                textAlign: TextAlign.center,
                style: GoogleFonts.exo(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color:
                      isDark
                          ? Colors.white.withOpacity(0.6)
                          : Colors.black.withOpacity(0.55),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _CardShell(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Queue",
            style: GoogleFonts.exo(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 14),
          ...vm.queueItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => vm.openDetail(item.verificationId),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? Colors.white.withOpacity(0.04)
                            : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.black.withOpacity(0.06),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: _statusColor(item.status).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          LucideIcons.fileText,
                          size: 18,
                          color: _statusColor(item.status),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (item.reportType == null ||
                                      item.reportType!.isEmpty)
                                  ? "Medical Report"
                                  : item.reportType!,
                              style: GoogleFonts.exo(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              [item.reportProvider, item.reportDate]
                                  .where(
                                    (e) => e != null && e.toString().isNotEmpty,
                                  )
                                  .join(" • "),
                              style: GoogleFonts.exo(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color:
                                    isDark
                                        ? Colors.white.withOpacity(0.6)
                                        : Colors.black.withOpacity(0.55),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      _StatusChip(isDark: isDark, status: item.status),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final bool isDark;
  final ReportVerificationViewModel vm;

  const _DetailSection({required this.isDark, required this.vm});

  @override
  Widget build(BuildContext context) {
    if (vm.isLoadingDetail) {
      return _DetailLoadingView(isDark: isDark);
    }

    if (vm.selectedDetail == null) {
      return _CardShell(
        isDark: isDark,
        child: Column(
          children: [
            Text(
              "Failed to load the verification.",
              style: GoogleFonts.exo(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color:
                    isDark
                        ? Colors.white.withOpacity(0.7)
                        : Colors.black.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: vm.closeDetail,
                child: const Text("Back"),
              ),
            ),
          ],
        ),
      );
    }

    final detail = vm.selectedDetail!;
    final reportContent = detail.report.analysis?.reportContent;
    final finalSummary =
        detail.report.analysis?.finalSummary?['en']?.toString();
    final documentUrl = detail.report.documentUrl;

    return Column(
      children: [
        _CardShell(
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: vm.closeDetail,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? Colors.white.withOpacity(0.06)
                            : Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    LucideIcons.chevronLeft,
                    size: 20,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detail.report.type ?? "Medical Report",
                          style: GoogleFonts.exo(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          [detail.report.provider, detail.report.date]
                              .where(
                                (e) => e != null && e.toString().isNotEmpty,
                              )
                              .join(" • "),
                          style: GoogleFonts.exo(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color:
                                isDark
                                    ? Colors.white.withOpacity(0.6)
                                    : Colors.black.withOpacity(0.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _StatusChip(isDark: isDark, status: detail.status),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        if (documentUrl != null && documentUrl.isNotEmpty)
          _CardShell(
            isDark: isDark,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Open original report document",
                    style: GoogleFonts.exo(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _openDocument(context, documentUrl),
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text("Open"),
                ),
              ],
            ),
          ),

        if (documentUrl != null && documentUrl.isNotEmpty)
          const SizedBox(height: 12),

        if (finalSummary != null && finalSummary.isNotEmpty)
          _CardShell(
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Summary",
                  style: GoogleFonts.exo(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  finalSummary,
                  style: GoogleFonts.exo(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                    color:
                        isDark
                            ? Colors.white.withOpacity(0.8)
                            : Colors.black.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),

        if (finalSummary != null && finalSummary.isNotEmpty)
          const SizedBox(height: 12),

        if (reportContent != null && reportContent.isNotEmpty)
          _CardShell(
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Report Content",
                  style: GoogleFonts.exo(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 120),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? Colors.black.withOpacity(0.18)
                            : Colors.grey.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.black.withOpacity(0.06),
                    ),
                  ),
                  child: Text(
                    reportContent,
                    style: GoogleFonts.exo(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.55,
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.82)
                              : Colors.black.withOpacity(0.78),
                    ),
                  ),
                ),
              ],
            ),
          ),

        if (reportContent != null && reportContent.isNotEmpty)
          const SizedBox(height: 12),

        if (detail.status == "requested")
          _CardShell(
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "This request is still open.",
                  style: GoogleFonts.exo(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: vm.isClaiming ? null : vm.claimVerification,
                    icon:
                        vm.isClaiming
                            ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(
                              Icons.assignment_turned_in_outlined,
                              size: 18,
                            ),
                    label: Text(
                      vm.isClaiming ? "Claiming..." : "Claim & Review",
                      style: GoogleFonts.exo(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),

        if (detail.status == "claimed") ...[
          _CardShell(
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Professional Comments",
                  style: GoogleFonts.exo(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  key: ValueKey(
                    "${vm.selectedVerificationId}-${detail.status}",
                  ),
                  initialValue: vm.commentsText,
                  onChanged: vm.updateComments,
                  maxLines: 5,
                  maxLength: 5000,
                  style: GoogleFonts.exo(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        "Professional comments or observations (optional)",
                    hintStyle: GoogleFonts.exo(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.45)
                              : Colors.black.withOpacity(0.40),
                    ),
                    filled: true,
                    fillColor:
                        isDark
                            ? Colors.white.withOpacity(0.05)
                            : const Color(0xFFF3F4F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.08)
                                : Colors.black.withOpacity(0.06),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.08)
                                : Colors.black.withOpacity(0.06),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  "Select outcome",
                  style: GoogleFonts.exo(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                _OutcomeTile(
                  isDark: isDark,
                  title: "Verified",
                  subtitle: "Report is acceptable and clinically valid.",
                  selected: vm.selectedOutcome == "verified",
                  color: const Color(0xFF10B981),
                  icon: LucideIcons.badgeCheck,
                  onTap: () => vm.setOutcome("verified"),
                ),
                const SizedBox(height: 10),
                _OutcomeTile(
                  isDark: isDark,
                  title: "Needs Follow-up",
                  subtitle: "More review or clarification is needed.",
                  selected: vm.selectedOutcome == "needs_followup",
                  color: const Color(0xFFF59E0B),
                  icon: LucideIcons.circleAlert,
                  onTap: () => vm.setOutcome("needs_followup"),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: vm.closeDetail,
                        child: const Text("Back"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            vm.isVerifying ? null : vm.submitVerification,
                        child:
                            vm.isVerifying
                                ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  "Submit",
                                  style: GoogleFonts.exo(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],

        if (detail.status == "verified")
          _CardShell(
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You have verified this report.",
                        style: GoogleFonts.exo(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                      if (detail.comments != null &&
                          detail.comments!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          detail.comments!,
                          style: GoogleFonts.exo(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color:
                                isDark
                                    ? Colors.white.withOpacity(0.82)
                                    : Colors.black.withOpacity(0.78),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: vm.closeDetail,
                    child: const Text("Back"),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  static Future<void> _openDocument(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid document URL")));
      return;
    }

    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!success && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Could not open document")));
    }
  }
}

class _OutcomeTile extends StatelessWidget {
  final bool isDark;
  final String title;
  final String subtitle;
  final bool selected;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _OutcomeTile({
    required this.isDark,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              selected
                  ? color.withOpacity(0.12)
                  : (isDark
                      ? Colors.white.withOpacity(0.04)
                      : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                selected
                    ? color
                    : (isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.black.withOpacity(0.06)),
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: selected ? color : Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.exo(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color:
                          selected
                              ? color
                              : (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.exo(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color:
                          isDark
                              ? Colors.white.withOpacity(0.58)
                              : Colors.black.withOpacity(0.55),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? color : Colors.grey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool isDark;
  final String status;

  const _StatusChip({required this.isDark, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        _statusLabel(status),
        style: GoogleFonts.exo(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const _CardShell({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.30 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _QueueLoadingView extends StatelessWidget {
  final bool isDark;

  const _QueueLoadingView({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _LoadingCard(isDark: isDark),
          ),
        ),
      ),
    );
  }
}

class _DetailLoadingView extends StatelessWidget {
  final bool isDark;

  const _DetailLoadingView({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LoadingCard(isDark: isDark, height: 120),
        const SizedBox(height: 12),
        _LoadingCard(isDark: isDark, height: 220),
        const SizedBox(height: 12),
        _LoadingCard(isDark: isDark, height: 180),
      ],
    );
  }
}

class _LoadingCard extends StatelessWidget {
  final bool isDark;
  final double height;

  const _LoadingCard({required this.isDark, this.height = 90});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ShimmerLine(isDark: isDark, widthFactor: 0.65),
            const SizedBox(height: 10),
            _ShimmerLine(isDark: isDark, widthFactor: 1),
            const SizedBox(height: 10),
            _ShimmerLine(isDark: isDark, widthFactor: 0.45),
          ],
        ),
      ),
    );
  }
}

class _ShimmerLine extends StatelessWidget {
  final bool isDark;
  final double widthFactor;

  const _ShimmerLine({required this.isDark, required this.widthFactor});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: Container(
        height: 12,
        decoration: BoxDecoration(
          color:
              isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.06),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final bool isDark;
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({
    required this.isDark,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.withOpacity(0.25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 42, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                "Something went wrong",
                style: GoogleFonts.exo(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.exo(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color:
                      isDark
                          ? Colors.white.withOpacity(0.65)
                          : Colors.black.withOpacity(0.60),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => onRetry(),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _statusColor(String status) {
  switch (status) {
    case "requested":
      return const Color(0xFFF59E0B);
    case "claimed":
      return const Color(0xFF3B82F6);
    case "verified":
      return const Color(0xFF10B981);
    case "rejected":
      return const Color(0xFFEF4444);
    case "cancelled":
    case "invalidated":
      return const Color(0xFF6B7280);
    default:
      return const Color(0xFF6B7280);
  }
}

String _statusLabel(String status) {
  switch (status) {
    case "requested":
      return "Requested";
    case "claimed":
      return "Claimed";
    case "verified":
      return "Verified";
    case "rejected":
      return "Rejected";
    case "cancelled":
      return "Cancelled";
    case "invalidated":
      return "Invalidated";
    default:
      return status;
  }
}
