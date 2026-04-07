import 'package:flutter/material.dart';

/// Centralized app color constants used throughout the Staff App.
/// All screens MUST reference these constants — never inline hex colors.
class AppColors {
  AppColors._();

  // ── Backgrounds ──────────────────────────────────────────────
  static const Color scaffoldBg     = Color(0xFF0A0A0A);
  static const Color cardBg         = Color(0xFF141414);
  static const Color cardBgElevated = Color(0xFF1A1A1A);
  static const Color surfaceDark    = Color(0xFF111111);
  static const Color divider        = Color(0xFF2A2A2A);
  static const Color border         = Color(0xFF252525);

  // ── Accents ──────────────────────────────────────────────────
  static const Color accentOrange   = Color(0xFFFF6D00);
  static const Color accentGreen    = Color(0xFF00E676);
  static const Color accentRed      = Color(0xFFFF3B30);
  static const Color accentBlue     = Color(0xFF448AFF);
  static const Color accentYellow   = Color(0xFFFFD600);

  // ── Text ─────────────────────────────────────────────────────
  static const Color textHigh       = Color(0xFFE8E8E8);
  static const Color textMedium     = Color(0xFFB0B0B0);
  static const Color textLow        = Color(0xFF666666);
  static const Color textDisabled   = Color(0xFF444444);

  // ── Status badges ────────────────────────────────────────────
  static const Color statusDone     = Color(0xFF00E676);
  static const Color statusPending  = Color(0xFFFFD600);
  static const Color statusCanceled = Color(0xFFFF3B30);
  static const Color statusActive   = Color(0xFF448AFF);
}
