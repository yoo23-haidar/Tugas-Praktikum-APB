import 'package:flutter/material.dart';
import 'package:barber_staff_app/core/theme/app_colors.dart';
import 'package:barber_staff_app/core/theme/app_text_styles.dart';

/// Data model for a single customer visit row.
class VisitData {
  final String sessionId;
  final String customerName;
  final String service;
  final String status; // "Completed", "In Progress", "Cancelled"

  const VisitData({
    required this.sessionId,
    required this.customerName,
    required this.service,
    required this.status,
  });
}

/// A clean, monospaced DataTable for recent customer visits.
///
/// Adds a camera icon action on completed rows so staff can
/// jump directly to the documentation flow.
class RecentVisitsTable extends StatelessWidget {
  final List<VisitData> visits;

  /// Called when the camera icon on a completed row is tapped.
  /// Passes the session ID to the parent.
  final void Function(String sessionId)? onDocumentSession;

  const RecentVisitsTable({
    super.key,
    required this.visits,
    this.onDocumentSession,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.statusDone;
      case 'in progress':
        return AppColors.statusActive;
      case 'cancelled':
        return AppColors.statusCanceled;
      default:
        return AppColors.textLow;
    }
  }

  double _statusProgress(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 1.0;
      case 'in progress':
        return 0.55;
      case 'cancelled':
        return 0.15;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('RECENT VISITS', style: AppTextStyles.sectionHeader),
                Text(
                  '${visits.length} records',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Table ──────────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - 40,
              ),
              child: DataTable(
                headingRowHeight: 40,
                dataRowMinHeight: 52,
                dataRowMaxHeight: 52,
                horizontalMargin: 18,
                columnSpacing: 24,
                dividerThickness: 0.5,
                headingRowColor: WidgetStateProperty.all(AppColors.surfaceDark),
                dataRowColor: WidgetStateProperty.all(Colors.transparent),
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: AppColors.divider.withValues(alpha: 0.4),
                    width: 0.5,
                  ),
                ),
                columns: [
                  DataColumn(
                    label: Text('SESSION', style: AppTextStyles.tableHeader),
                  ),
                  DataColumn(
                    label: Text('CUSTOMER', style: AppTextStyles.tableHeader),
                  ),
                  DataColumn(
                    label: Text('SERVICE', style: AppTextStyles.tableHeader),
                  ),
                  DataColumn(
                    label: Text('STATUS', style: AppTextStyles.tableHeader),
                  ),
                  // New: action column for camera
                  DataColumn(
                    label: Text('', style: AppTextStyles.tableHeader),
                  ),
                ],
                rows: visits.map((v) {
                  final sColor = _statusColor(v.status);
                  final isCompleted =
                      v.status.toLowerCase() == 'completed';

                  return DataRow(
                    cells: [
                      // Session ID
                      DataCell(
                        Text(
                          v.sessionId,
                          style: AppTextStyles.tableCell.copyWith(
                            color: AppColors.accentOrange,
                          ),
                        ),
                      ),
                      // Customer name
                      DataCell(
                          Text(v.customerName, style: AppTextStyles.tableCell)),
                      // Service
                      DataCell(
                          Text(v.service, style: AppTextStyles.tableCell)),
                      // Status with mini progress bar
                      DataCell(
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              v.status,
                              style: AppTextStyles.caption.copyWith(
                                color: sColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: 60,
                              height: 3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: LinearProgressIndicator(
                                  value: _statusProgress(v.status),
                                  backgroundColor:
                                      AppColors.divider.withValues(alpha: 0.5),
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(sColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Camera action (only for completed)
                      DataCell(
                        isCompleted && onDocumentSession != null
                            ? IconButton(
                                icon: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 18,
                                  color: AppColors.accentOrange,
                                ),
                                tooltip: 'Document haircut',
                                onPressed: () =>
                                    onDocumentSession!(v.sessionId),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
