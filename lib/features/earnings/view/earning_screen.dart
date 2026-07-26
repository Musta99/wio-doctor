import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/features/earnings/viewmodel/earning_view_model.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key});

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EarningViewModel>(context, listen: false).loadWallet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = Provider.of<EarningViewModel>(context);

    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.06);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.wallet, size: 24),
            const SizedBox(width: 12),
            Text(
              'Earnings & Payouts',
              style: GoogleFonts.exo(fontSize: 20, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:
          vm.isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF14c7eb)),
              )
              : RefreshIndicator(
                onRefresh: vm.loadWallet,
                color: const Color(0xFF14c7eb),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Balance Cards Grid
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          _BalanceCard(
                            isDark: isDark,
                            label: 'Pending',
                            value: vm.formatMoney(
                              vm.wallet?.pendingBalance ?? 0,
                            ),
                            hint: 'In clearing hold',
                            color: const Color(0xFFF59E0B),
                          ),
                          _BalanceCard(
                            isDark: isDark,
                            label: 'Withdrawable',
                            value: vm.formatMoney(
                              vm.wallet?.withdrawableBalance ?? 0,
                            ),
                            hint: 'Available now',
                            color: const Color(0xFF10B981),
                          ),
                          _BalanceCard(
                            isDark: isDark,
                            label: 'Current Balance',
                            value: vm.formatMoney(
                              vm.wallet?.currentBalance ?? 0,
                            ),
                            hint: 'Pending + withdrawable',
                            color: const Color(0xFF3B82F6),
                          ),
                          _BalanceCard(
                            isDark: isDark,
                            label: 'Lifetime Earned',
                            value: vm.formatMoney(vm.wallet?.totalEarned ?? 0),
                            hint: 'Total earnings',
                            color: const Color(0xFF8B5CF6),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Withdrawal Card
                      _WithdrawalCard(
                        isDark: isDark,
                        borderColor: borderColor,
                        vm: vm,
                      ),

                      const SizedBox(height: 16),

                      // Payout Method Card
                      _PayoutMethodCard(
                        isDark: isDark,
                        borderColor: borderColor,
                        vm: vm,
                      ),

                      const SizedBox(height: 20),

                      // Earnings History
                      _EarningsHistoryCard(
                        isDark: isDark,
                        borderColor: borderColor,
                        vm: vm,
                      ),

                      const SizedBox(height: 16),

                      // Payout History
                      if (vm.payouts.isNotEmpty)
                        _PayoutHistoryCard(
                          isDark: isDark,
                          borderColor: borderColor,
                          vm: vm,
                        ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
    );
  }
}

// Balance Card Widget
class _BalanceCard extends StatelessWidget {
  final bool isDark;
  final String label;
  final String value;
  final String? hint;
  final Color color;

  const _BalanceCard({
    required this.isDark,
    required this.label,
    required this.value,
    this.hint,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.exo(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color:
                        isDark
                            ? Colors.white.withOpacity(0.5)
                            : Colors.black.withOpacity(0.5),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.exo(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (hint != null)
            Text(
              hint!,
              style: GoogleFonts.exo(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color:
                    isDark
                        ? Colors.white.withOpacity(0.4)
                        : Colors.black.withOpacity(0.4),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}

// Withdrawal Card Widget
class _WithdrawalCard extends StatelessWidget {
  final bool isDark;
  final Color borderColor;
  final EarningViewModel vm;

  const _WithdrawalCard({
    required this.isDark,
    required this.borderColor,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    final hasPending = vm.payouts.any((p) => p.status == 'PENDING');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Request a withdrawal',
            style: GoogleFonts.exo(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (vm.payoutMethod == null)
            Text(
              'Add a payout method before requesting a withdrawal.',
              style: GoogleFonts.exo(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color:
                    isDark
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
              ),
            )
          else if (hasPending)
            Text(
              'You already have a payout request awaiting review.',
              style: GoogleFonts.exo(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color:
                    isDark
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
              ),
            )
          else ...[
            TextField(
              controller: vm.withdrawalAmountController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.exo(fontSize: 14, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: 'Amount (BDT)',
                hintStyle: GoogleFonts.exo(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:
                      isDark
                          ? Colors.white.withOpacity(0.4)
                          : Colors.black.withOpacity(0.4),
                ),
                filled: true,
                fillColor:
                    isDark
                        ? Colors.white.withOpacity(0.05)
                        : const Color(0xFFF3F4F6),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Minimum: ${vm.formatMoney(vm.minWithdrawal)} • Withdrawable: ${vm.formatMoney(vm.wallet?.withdrawableBalance ?? 0)}',
              style: GoogleFonts.exo(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color:
                    isDark
                        ? Colors.white.withOpacity(0.5)
                        : Colors.black.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 16),
            ShadButton(
              width: double.infinity,
              height: 46,
              backgroundColor: const Color(0xFF14c7eb),
              pressedBackgroundColor: const Color(0xFF0EA5C9),
              onPressed:
                  vm.isWithdrawing ||
                          vm.withdrawalAmountController.text.isEmpty ||
                          (double.tryParse(
                                    vm.withdrawalAmountController.text,
                                  ) ??
                                  0) <
                              vm.minWithdrawal
                      ? null
                      : () => vm.requestWithdrawal(context),
              child:
                  vm.isWithdrawing
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
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.send, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Request withdrawal',
                            style: GoogleFonts.exo(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
            ),
          ],
        ],
      ),
    );
  }
}

// Payout Method Card Widget
class _PayoutMethodCard extends StatelessWidget {
  final bool isDark;
  final Color borderColor;
  final EarningViewModel vm;

  const _PayoutMethodCard({
    required this.isDark,
    required this.borderColor,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payout method',
            style: GoogleFonts.exo(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Type Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color:
                  isDark
                      ? Colors.white.withOpacity(0.05)
                      : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: vm.payoutType,
                isExpanded: true,
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                style: GoogleFonts.exo(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                items: const [
                  DropdownMenuItem(value: 'bkash', child: Text('bKash')),
                  DropdownMenuItem(value: 'nagad', child: Text('Nagad')),
                  DropdownMenuItem(value: 'rocket', child: Text('Rocket')),
                  DropdownMenuItem(value: 'bank', child: Text('Bank transfer')),
                ],
                onChanged: (v) => vm.setPayoutType(v ?? 'bkash'),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Account Name
          TextField(
            controller: vm.accountNameController,
            style: GoogleFonts.exo(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: _inputDecoration(
              isDark: isDark,
              borderColor: borderColor,
              hint: 'Account name',
            ),
          ),

          const SizedBox(height: 12),

          // Account Number
          TextField(
            controller: vm.accountNumberController,
            keyboardType: TextInputType.phone,
            style: GoogleFonts.exo(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: _inputDecoration(
              isDark: isDark,
              borderColor: borderColor,
              hint:
                  vm.payoutType == 'bank' ? 'Account number' : 'Mobile number',
            ),
          ),

          if (vm.payoutType == 'bank') ...[
            const SizedBox(height: 12),
            TextField(
              controller: vm.bankNameController,
              style: GoogleFonts.exo(fontSize: 14, fontWeight: FontWeight.w600),
              decoration: _inputDecoration(
                isDark: isDark,
                borderColor: borderColor,
                hint: 'Bank name',
              ),
            ),
          ],

          const SizedBox(height: 16),

          ShadButton(
            width: double.infinity,
            height: 46,
            backgroundColor:
                isDark
                    ? Colors.white.withOpacity(0.1)
                    : const Color(0xFFF3F4F6),
            pressedBackgroundColor:
                isDark
                    ? Colors.white.withOpacity(0.15)
                    : const Color(0xFFE5E7EB),
            onPressed:
                vm.isSavingMethod ||
                        vm.accountNameController.text.isEmpty ||
                        vm.accountNumberController.text.isEmpty
                    ? null
                    : () => vm.savePayoutMethod(context),
            child:
                vm.isSavingMethod
                    ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.save,
                          size: 16,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Save payout method',
                          style: GoogleFonts.exo(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required bool isDark,
    required Color borderColor,
    required String hint,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.exo(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color:
            isDark
                ? Colors.white.withOpacity(0.4)
                : Colors.black.withOpacity(0.4),
      ),
      filled: true,
      fillColor:
          isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF3F4F6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF14c7eb)),
      ),
    );
  }
}

// Earnings History Card Widget
class _EarningsHistoryCard extends StatelessWidget {
  final bool isDark;
  final Color borderColor;
  final EarningViewModel vm;

  const _EarningsHistoryCard({
    required this.isDark,
    required this.borderColor,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Earnings history',
                style: GoogleFonts.exo(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Source Filters
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                [
                  'all',
                  'consultation',
                  'report_verification',
                  'prescription_review',
                ].map((source) {
                  final isSelected = vm.selectedSource == source;
                  return InkWell(
                    onTap: () => vm.setSourceFilter(source),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? const Color(0xFF14c7eb)
                                : (isDark
                                    ? Colors.white.withOpacity(0.05)
                                    : const Color(0xFFF3F4F6)),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              isSelected
                                  ? const Color(0xFF14c7eb)
                                  : borderColor,
                        ),
                      ),
                      child: Text(
                        _getSourceLabel(source),
                        style: GoogleFonts.exo(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color:
                              isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),

          const SizedBox(height: 16),

          if (vm.filteredEarnings.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No earnings yet.',
                  style: GoogleFonts.exo(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color:
                        isDark
                            ? Colors.white.withOpacity(0.5)
                            : Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
            )
          else
            ...vm.filteredEarnings.map((earning) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? Colors.white.withOpacity(0.03)
                          : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _getServiceLabel(earning.serviceType),
                            style: GoogleFonts.exo(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              earning.status,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _getStatusColor(
                                earning.status,
                              ).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            earning.status.toUpperCase(),
                            style: GoogleFonts.exo(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: _getStatusColor(earning.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gross',
                              style: GoogleFonts.exo(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color:
                                    isDark
                                        ? Colors.white.withOpacity(0.5)
                                        : Colors.black.withOpacity(0.5),
                              ),
                            ),
                            Text(
                              vm.formatMoney(earning.gross),
                              style: GoogleFonts.exo(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Your earning',
                              style: GoogleFonts.exo(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color:
                                    isDark
                                        ? Colors.white.withOpacity(0.5)
                                        : Colors.black.withOpacity(0.5),
                              ),
                            ),
                            Text(
                              vm.formatMoney(earning.doctorEarning),
                              style: GoogleFonts.exo(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _formatDate(earning.createdAt),
                        style: GoogleFonts.exo(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color:
                              isDark
                                  ? Colors.white.withOpacity(0.4)
                                  : Colors.black.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  String _getSourceLabel(String source) {
    switch (source) {
      case 'all':
        return 'All sources';
      case 'consultation':
        return 'Consultation';
      case 'report_verification':
        return 'Report Verification';
      case 'prescription_review':
        return 'Prescription Review';
      default:
        return source;
    }
  }

  String _getServiceLabel(String service) {
    switch (service) {
      case 'consultation':
        return 'Consultation';
      case 'report_verification':
        return 'Report Verification';
      case 'prescription_review':
        return 'Prescription Review';
      default:
        return service;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'cleared':
        return const Color(0xFF10B981);
      case 'reversed':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return isoDate.substring(0, 10);
    }
  }
}

// Payout History Card Widget
class _PayoutHistoryCard extends StatelessWidget {
  final bool isDark;
  final Color borderColor;
  final EarningViewModel vm;

  const _PayoutHistoryCard({
    required this.isDark,
    required this.borderColor,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payout requests',
            style: GoogleFonts.exo(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...vm.payouts.map((payout) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? Colors.white.withOpacity(0.03)
                        : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vm.formatMoney(payout.amount),
                          style: GoogleFonts.exo(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(payout.timestamp),
                          style: GoogleFonts.exo(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color:
                                isDark
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getPayoutStatusColor(
                        payout.status,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _getPayoutStatusColor(
                          payout.status,
                        ).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      payout.status,
                      style: GoogleFonts.exo(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: _getPayoutStatusColor(payout.status),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Color _getPayoutStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return const Color(0xFFF59E0B);
      case 'COMPLETED':
        return const Color(0xFF10B981);
      case 'REJECTED':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return isoDate.substring(0, 10);
    }
  }
}
