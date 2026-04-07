import 'package:flutter/material.dart';
import 'package:barber_staff_app/core/theme/app_colors.dart';
import 'package:barber_staff_app/core/theme/app_text_styles.dart';

/// Centralized error entry used by the global handler.
class AppError {
  final String message;
  final String source;
  final DateTime timestamp;
  final String severity; // 'error', 'warning', 'info'

  AppError({
    required this.message,
    required this.source,
    DateTime? timestamp,
    this.severity = 'error',
  }) : timestamp = timestamp ?? DateTime.now();
}

/// Global error handler that:
/// 1. Shows terminal-style snackbars on API failures
/// 2. Maintains a log of recent errors accessible by the dashboard
///
/// Usage:
/// ```dart
/// AppErrorHandler.instance.handleError(
///   context: context,
///   error: e,
///   source: 'attendance.checkIn',
/// );
/// ```
class AppErrorHandler {
  AppErrorHandler._();
  static final AppErrorHandler instance = AppErrorHandler._();

  final List<AppError> _errorLog = [];
  final ValueNotifier<List<AppError>> errorNotifier = ValueNotifier([]);

  /// Maximum errors kept in memory.
  static const int _maxLogSize = 50;

  /// All logged errors (most recent first).
  List<AppError> get errors => List.unmodifiable(_errorLog);

  /// Handle an error: log it and show a terminal-style snackbar.
  void handleError({
    required BuildContext context,
    required Object error,
    required String source,
    String severity = 'error',
  }) {
    final appError = AppError(
      message: _cleanMessage(error.toString()),
      source: source,
      severity: severity,
    );

    // Add to log
    _errorLog.insert(0, appError);
    if (_errorLog.length > _maxLogSize) {
      _errorLog.removeLast();
    }
    errorNotifier.value = List.from(_errorLog);

    // Show snackbar
    if (context.mounted) {
      _showTerminalSnackbar(context, appError);
    }
  }

  /// Show a warning (non-error) notification.
  void showWarning({
    required BuildContext context,
    required String message,
    required String source,
  }) {
    handleError(
      context: context,
      error: message,
      source: source,
      severity: 'warning',
    );
  }

  /// Show a success notification (terminal style).
  void showSuccess({
    required BuildContext context,
    required String message,
  }) {
    if (!context.mounted) return;
    final snackBar = SnackBar(
      content: _buildSnackContent(
        icon: Icons.check_circle_outline,
        color: AppColors.accentGreen,
        prefix: '> OK',
        message: message,
      ),
      backgroundColor: AppColors.cardBg,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: AppColors.accentGreen.withValues(alpha: 0.3),
        ),
      ),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Clear all logged errors.
  void clearErrors() {
    _errorLog.clear();
    errorNotifier.value = [];
  }

  // ─────────────────────────────────────────────────────────────
  // Private helpers
  // ─────────────────────────────────────────────────────────────

  void _showTerminalSnackbar(BuildContext context, AppError error) {
    final isError = error.severity == 'error';
    final color = isError ? AppColors.accentRed : AppColors.accentYellow;
    final prefix = isError ? '> ERR' : '> WARN';
    final icon = isError
        ? Icons.error_outline
        : Icons.warning_amber_outlined;

    final snackBar = SnackBar(
      content: _buildSnackContent(
        icon: icon,
        color: color,
        prefix: prefix,
        message: error.message,
        source: error.source,
      ),
      backgroundColor: AppColors.cardBg,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      duration: Duration(seconds: isError ? 5 : 3),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      action: SnackBarAction(
        label: 'DISMISS',
        textColor: color,
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Widget _buildSnackContent({
    required IconData icon,
    required Color color,
    required String prefix,
    required String message,
    String? source,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    prefix,
                    style: AppTextStyles.caption.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                  if (source != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      '[$source]',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textLow,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                message,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMedium,
                  fontSize: 11,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _cleanMessage(String raw) {
    // Remove "Exception: " prefix
    if (raw.startsWith('Exception: ')) {
      return raw.substring(11);
    }
    return raw;
  }
}
