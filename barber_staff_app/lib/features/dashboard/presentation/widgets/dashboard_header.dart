import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barber_staff_app/core/theme/app_colors.dart';
import 'package:barber_staff_app/core/theme/app_text_styles.dart';

/// Dashboard header with live clock and current date.
/// Replicates the minimal top-right header bar from the reference.
class DashboardHeader extends StatefulWidget {
  const DashboardHeader({super.key});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('HH:mm:ss').format(_now);
    final dateStr = DateFormat('EEE, dd MMM yyyy').format(_now);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.scaffoldBg,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: Row(
        children: [
          // ── Left: Greeting ────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STAFF DASHBOARD',
                  style: AppTextStyles.sectionHeader.copyWith(
                    color: AppColors.accentOrange,
                    fontSize: 13,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '> session active',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.accentGreen,
                  ),
                ),
              ],
            ),
          ),

          // ── Right: Clock + Date + Calendar icon ───────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: AppColors.textLow,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(timeStr, style: AppTextStyles.headerClock),
                    const SizedBox(height: 1),
                    Text(dateStr, style: AppTextStyles.headerDate),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
