import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barber_staff_app/core/theme/app_colors.dart';
import 'package:barber_staff_app/core/theme/app_text_styles.dart';
import 'package:barber_staff_app/core/models/attendance_record.dart';
import 'package:barber_staff_app/core/services/service_locator.dart';

/// Attendance screen — check-in/out + attendance history.
class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _isCheckedIn = false;
  bool _isLoading = false;
  AttendanceRecord? _todayRecord;
  List<AttendanceRecord> _history = [];
  bool _historyLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _historyLoading = true);
    try {
      final history = await ServiceLocator.barberService.getAttendanceHistory();
      setState(() {
        _history = history;
        // Check if today already has an active record
        final now = DateTime.now();
        final todayRecords = history.where((r) =>
            r.date.year == now.year &&
            r.date.month == now.month &&
            r.date.day == now.day);
        if (todayRecords.isNotEmpty) {
          _todayRecord = todayRecords.first;
          _isCheckedIn = _todayRecord!.isActive;
        }
      });
    } catch (e) {
      // handle silently
    } finally {
      if (mounted) setState(() => _historyLoading = false);
    }
  }

  Future<void> _handleCheckIn() async {
    setState(() => _isLoading = true);
    try {
      final record = await ServiceLocator.barberService.checkIn();
      setState(() {
        _isCheckedIn = true;
        _todayRecord = record;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Checked in at ${DateFormat('HH:mm').format(record.checkInTime!)}',
                style: AppTextStyles.caption.copyWith(color: AppColors.scaffoldBg)),
            backgroundColor: AppColors.accentGreen,
          ),
        );
      }
      _loadHistory();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e', style: AppTextStyles.caption.copyWith(color: AppColors.textHigh)),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCheckOut() async {
    setState(() => _isLoading = true);
    try {
      final record = await ServiceLocator.barberService.checkOut();
      setState(() {
        _isCheckedIn = false;
        _todayRecord = record;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Checked out · ${record.hoursWorked?.toStringAsFixed(1)} hrs worked',
                style: AppTextStyles.caption.copyWith(color: AppColors.scaffoldBg)),
            backgroundColor: AppColors.accentGreen,
          ),
        );
      }
      _loadHistory();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e', style: AppTextStyles.caption.copyWith(color: AppColors.textHigh)),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        title: Text('ATTENDANCE',
            style: AppTextStyles.sectionHeader.copyWith(fontSize: 14)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Check-in / Check-out card ──────────────────────
            _buildStatusCard(),
            const SizedBox(height: 24),

            // ── History section ────────────────────────────────
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
                Text('ATTENDANCE HISTORY', style: AppTextStyles.sectionHeader),
              ],
            ),
            const SizedBox(height: 12),
            _historyLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(
                          color: AppColors.accentOrange),
                    ),
                  )
                : _history.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text('No attendance records yet.',
                              style: AppTextStyles.alertBody),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _history.length > 15 ? 15 : _history.length,
                        separatorBuilder: (context, i) => const SizedBox(height: 8),
                        itemBuilder: (context, index) =>
                            _buildHistoryTile(_history[index]),
                      ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final now = DateTime.now();
    final timeStr = DateFormat('HH:mm').format(now);
    final dateStr = DateFormat('EEEE, dd MMMM yyyy').format(now);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isCheckedIn
              ? AppColors.accentGreen.withValues(alpha: 0.4)
              : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          // Current time
          Text(timeStr,
              style: AppTextStyles.metricValue.copyWith(fontSize: 42)),
          const SizedBox(height: 4),
          Text(dateStr, style: AppTextStyles.headerDate),
          const SizedBox(height: 20),

          // Status indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: (_isCheckedIn
                      ? AppColors.accentGreen
                      : AppColors.textLow)
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isCheckedIn
                        ? AppColors.accentGreen
                        : AppColors.textLow,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _isCheckedIn ? 'WORKING' : 'NOT CHECKED IN',
                  style: AppTextStyles.caption.copyWith(
                    color: _isCheckedIn
                        ? AppColors.accentGreen
                        : AppColors.textLow,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),

          // Today's check-in/out info
          if (_todayRecord != null) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_todayRecord!.checkInTime != null)
                  _buildTimeChip(
                    'IN',
                    DateFormat('HH:mm').format(_todayRecord!.checkInTime!),
                    AppColors.accentGreen,
                  ),
                if (_todayRecord!.checkOutTime != null) ...[
                  const SizedBox(width: 16),
                  _buildTimeChip(
                    'OUT',
                    DateFormat('HH:mm').format(_todayRecord!.checkOutTime!),
                    AppColors.accentRed,
                  ),
                ],
                if (_todayRecord!.hoursWorked != null) ...[
                  const SizedBox(width: 16),
                  _buildTimeChip(
                    'HOURS',
                    '${_todayRecord!.hoursWorked!.toStringAsFixed(1)}h',
                    AppColors.accentOrange,
                  ),
                ],
              ],
            ),
          ],

          const SizedBox(height: 24),

          // Action button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : (_isCheckedIn ? _handleCheckOut : _handleCheckIn),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isCheckedIn ? AppColors.accentRed : AppColors.accentGreen,
                foregroundColor: AppColors.scaffoldBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.scaffoldBg),
                    )
                  : Text(
                      _isCheckedIn ? 'CHECK-OUT' : 'CHECK-IN',
                      style: AppTextStyles.buttonLabel.copyWith(
                        fontSize: 14,
                        color: AppColors.scaffoldBg,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeChip(String label, String value, Color color) {
    return Column(
      children: [
        Text(label,
            style: AppTextStyles.caption
                .copyWith(color: color, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.tableCell.copyWith(color: color)),
      ],
    );
  }

  Widget _buildHistoryTile(AttendanceRecord record) {
    final dateStr = DateFormat('dd MMM yyyy').format(record.date);
    final inStr = record.checkInTime != null
        ? DateFormat('HH:mm').format(record.checkInTime!)
        : '--:--';
    final outStr = record.checkOutTime != null
        ? DateFormat('HH:mm').format(record.checkOutTime!)
        : '--:--';
    final hours = record.hoursWorked?.toStringAsFixed(1) ?? '-';
    final isActive = record.isActive;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive
              ? AppColors.accentGreen.withValues(alpha: 0.3)
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          // Date
          Expanded(
            flex: 3,
            child:
                Text(dateStr, style: AppTextStyles.tableCell.copyWith(fontSize: 11)),
          ),
          // Check-in
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('IN',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.accentGreen)),
                Text(inStr,
                    style: AppTextStyles.tableCell.copyWith(fontSize: 11)),
              ],
            ),
          ),
          // Check-out
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('OUT',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.accentRed)),
                Text(outStr,
                    style: AppTextStyles.tableCell.copyWith(fontSize: 11)),
              ],
            ),
          ),
          // Hours
          SizedBox(
            width: 50,
            child: Text(
              '${hours}h',
              textAlign: TextAlign.right,
              style: AppTextStyles.tableCell.copyWith(
                fontSize: 11,
                color: AppColors.accentOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
