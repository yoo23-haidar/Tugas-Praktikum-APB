import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Reusable text style presets – all JetBrains Mono.
/// Every widget should pull from here instead of creating ad-hoc styles.
class AppTextStyles {
  AppTextStyles._();

  // ── Hero data values (large metric numbers) ──────────────────
  static TextStyle metricValue = GoogleFonts.jetBrainsMono(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textHigh,
    letterSpacing: -0.5,
    height: 1.1,
  );

  // ── Metric sub-label ─────────────────────────────────────────
  static TextStyle metricLabel = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textLow,
    letterSpacing: 1.2,
  );

  // ── Trend badge (+29 %) ──────────────────────────────────────
  static TextStyle trendBadge = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.4,
  );

  // ── Section header (e.g. "RECENT VISITS") ────────────────────
  static TextStyle sectionHeader = GoogleFonts.jetBrainsMono(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textMedium,
    letterSpacing: 2.0,
  );

  // ── Table column header ──────────────────────────────────────
  static TextStyle tableHeader = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textLow,
    letterSpacing: 1.0,
  );

  // ── Table cell data ──────────────────────────────────────────
  static TextStyle tableCell = GoogleFonts.jetBrainsMono(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textHigh,
  );

  // ── Alert title ──────────────────────────────────────────────
  static TextStyle alertTitle = GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textHigh,
  );

  // ── Alert body ───────────────────────────────────────────────
  static TextStyle alertBody = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMedium,
  );

  // ── Timestamp / caption ──────────────────────────────────────
  static TextStyle caption = GoogleFonts.jetBrainsMono(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textLow,
  );

  // ── Header clock style ───────────────────────────────────────
  static TextStyle headerClock = GoogleFonts.jetBrainsMono(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textHigh,
    letterSpacing: 1.0,
  );

  // ── Header date style ────────────────────────────────────────
  static TextStyle headerDate = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMedium,
  );

  // ── Button label ─────────────────────────────────────────────
  static TextStyle buttonLabel = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );
}
