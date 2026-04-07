import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barber_staff_app/core/theme/app_colors.dart';
import 'package:barber_staff_app/core/theme/app_text_styles.dart';
import 'package:barber_staff_app/core/models/salary_recap.dart';
import 'package:barber_staff_app/core/services/service_locator.dart';

/// Salary Recap screen — base salary, commissions, bonuses, total.
class SalaryScreen extends StatefulWidget {
  const SalaryScreen({super.key});

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  SalaryRecap? _recap;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecap();
  }

  Future<void> _loadRecap() async {
    setState(() => _isLoading = true);
    try {
      final recap = await ServiceLocator.barberService.getSalaryRecap();
      setState(() => _recap = recap);
    } catch (e) {
      // handle silently
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        title: Text('SALARY SUMMARY',
            style: AppTextStyles.sectionHeader.copyWith(fontSize: 14)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(color: AppColors.accentOrange))
          : _recap == null
              ? Center(
                  child: Text('Failed to load salary recap',
                      style: AppTextStyles.alertBody))
              : RefreshIndicator(
                  onRefresh: _loadRecap,
                  color: AppColors.accentOrange,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Period header ──────────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('PERIOD',
                                      style: AppTextStyles.metricLabel),
                                  const SizedBox(height: 4),
                                  Text(_recap!.period,
                                      style: AppTextStyles.alertTitle),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _recap!.status == 'paid'
                                      ? AppColors.accentGreen
                                          .withValues(alpha: 0.15)
                                      : AppColors.accentYellow
                                          .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _recap!.status.toUpperCase(),
                                  style: AppTextStyles.caption.copyWith(
                                    color: _recap!.status == 'paid'
                                        ? AppColors.accentGreen
                                        : AppColors.accentYellow,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── Total earnings hero card ──────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  AppColors.accentOrange.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text('TOTAL EARNINGS',
                                  style: AppTextStyles.metricLabel),
                              const SizedBox(height: 8),
                              Text(
                                _formatCurrency(_recap!.totalEarnings),
                                style: AppTextStyles.metricValue.copyWith(
                                  fontSize: 32,
                                  color: AppColors.accentOrange,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildMiniStat(
                                    '${_recap!.totalDaysWorked}',
                                    'WORK DAYS',
                                  ),
                                  const SizedBox(width: 24),
                                  _buildMiniStat(
                                    '${_recap!.totalHoursWorked}h',
                                    'WORK HOURS',
                                  ),
                                  const SizedBox(width: 24),
                                  _buildMiniStat(
                                    '${_recap!.totalCustomersServed}',
                                    'CUSTOMERS',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── Breakdown ─────────────────────────────
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 14,
                              decoration: BoxDecoration(
                                color: AppColors.accentOrange,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('DETAILS', style: AppTextStyles.sectionHeader),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildBreakdownItem(
                          'BASE SALARY',
                          _formatCurrency(_recap!.baseSalary),
                          AppColors.accentBlue,
                          Icons.account_balance_wallet_outlined,
                          subtitle: 'Based on attendance',
                        ),
                        _buildBreakdownItem(
                          'SERVICE COMMISSION',
                          _formatCurrency(_recap!.commission),
                          AppColors.accentGreen,
                          Icons.trending_up,
                          subtitle:
                              '${_recap!.totalCustomersServed} services completed',
                        ),
                        if (_recap!.bonus > 0)
                          _buildBreakdownItem(
                            'BONUS',
                            _formatCurrency(_recap!.bonus),
                            AppColors.accentYellow,
                            Icons.star_outline,
                            subtitle: 'Performance bonus',
                          ),
                        if (_recap!.deductions > 0)
                          _buildBreakdownItem(
                            'DEDUCTIONS',
                            '- ${_formatCurrency(_recap!.deductions)}',
                            AppColors.accentRed,
                            Icons.remove_circle_outline,
                          ),

                        const SizedBox(height: 16),

                        // ── Total line ────────────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('TOTAL',
                                  style: AppTextStyles.alertTitle
                                      .copyWith(fontSize: 14)),
                              Text(
                                _formatCurrency(_recap!.totalEarnings),
                                style: AppTextStyles.alertTitle.copyWith(
                                  fontSize: 16,
                                  color: AppColors.accentOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildMiniStat(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: AppTextStyles.tableCell.copyWith(
              color: AppColors.textHigh,
              fontWeight: FontWeight.w700,
            )),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildBreakdownItem(
    String title,
    String amount,
    Color color,
    IconData icon, {
    String? subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.tableCell),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ],
            ),
          ),
          Text(
            amount,
            style: AppTextStyles.alertTitle.copyWith(
              color: color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
