import 'package:flutter/material.dart';
import 'package:barber_staff_app/core/theme/app_colors.dart';
import 'package:barber_staff_app/core/theme/app_text_styles.dart';

/// Alert urgency level used for the colored tag on each alert card.
enum AlertUrgency { critical, warning, info }

/// Data model for a single alert entry.
class AlertData {
  final String title;
  final String body;
  final AlertUrgency urgency;
  final List<String> actions; // Button labels

  const AlertData({
    required this.title,
    required this.body,
    required this.urgency,
    this.actions = const [],
  });
}

/// A vertical list of card-based alerts/notifications.
/// Each alert has an urgency tag, title, body, and action buttons.
class AlertsPanel extends StatelessWidget {
  final List<AlertData> alerts;

  const AlertsPanel({super.key, required this.alerts});

  Color _urgencyColor(AlertUrgency u) {
    switch (u) {
      case AlertUrgency.critical:
        return AppColors.accentRed;
      case AlertUrgency.warning:
        return AppColors.accentYellow;
      case AlertUrgency.info:
        return AppColors.accentBlue;
    }
  }

  String _urgencyLabel(AlertUrgency u) {
    switch (u) {
      case AlertUrgency.critical:
        return 'CRITICAL';
      case AlertUrgency.warning:
        return 'WARNING';
      case AlertUrgency.info:
        return 'INFO';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ─────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.accentRed,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text('ALERTS', style: AppTextStyles.sectionHeader),
            ],
          ),
        ),

        // ── Alert cards ────────────────────────────────────────
        ...alerts.map((alert) {
          final uColor = _urgencyColor(alert.urgency);
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: uColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top bar with urgency tag ─────────────────────
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: uColor.withValues(alpha: 0.06),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(9),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Urgency tag pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: uColor.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _urgencyLabel(alert.urgency),
                          style: AppTextStyles.caption.copyWith(
                            color: uColor,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.notifications_active_outlined,
                        size: 14,
                        color: uColor.withValues(alpha: 0.6),
                      ),
                    ],
                  ),
                ),

                // ── Body ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(alert.title, style: AppTextStyles.alertTitle),
                      const SizedBox(height: 6),
                      Text(alert.body, style: AppTextStyles.alertBody),
                    ],
                  ),
                ),

                // ── Actions ─────────────────────────────────────
                if (alert.actions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: alert.actions.asMap().entries.map((entry) {
                        final isPrimary = entry.key == 0;
                        return SizedBox(
                          height: 34,
                          child: isPrimary
                              ? ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: uColor,
                                    foregroundColor: AppColors.scaffoldBg,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    textStyle: AppTextStyles.buttonLabel,
                                  ),
                                  child: Text(entry.value),
                                )
                              : OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.textMedium,
                                    side: BorderSide(
                                      color: AppColors.divider,
                                      width: 1,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    textStyle: AppTextStyles.buttonLabel,
                                  ),
                                  child: Text(entry.value),
                                ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
