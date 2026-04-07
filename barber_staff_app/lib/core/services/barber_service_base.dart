import 'dart:typed_data';
import 'package:barber_staff_app/core/models/auth_response.dart';
import 'package:barber_staff_app/core/models/attendance_record.dart';
import 'package:barber_staff_app/core/models/customer_session.dart';
import 'package:barber_staff_app/core/models/dashboard_metrics.dart';
import 'package:barber_staff_app/core/models/salary_recap.dart';
import 'package:barber_staff_app/core/models/staff_profile.dart';

/// Abstract contract for all barbershop API interactions.
///
/// Swap between [BarberApiService] (real Dio) and
/// [MockBarberService] (in-memory) without touching UI code.
abstract class BarberServiceBase {
  // ── Auth ──────────────────────────────────────────────────────
  /// POST /auth/login
  Future<AuthResponse> login({
    required String email,
    required String password,
  });

  // ── Profile ───────────────────────────────────────────────────
  /// GET /staff/profile
  Future<StaffProfile> getProfile();

  /// PUT /staff/profile
  Future<StaffProfile> updateProfile(StaffProfile profile);

  // ── Attendance ────────────────────────────────────────────────
  /// POST /attendance/check-in
  Future<AttendanceRecord> checkIn();

  /// POST /attendance/check-out
  Future<AttendanceRecord> checkOut();

  /// GET /attendance/history
  Future<List<AttendanceRecord>> getAttendanceHistory();

  // ── Salary ────────────────────────────────────────────────────
  /// GET /salary-recap
  Future<SalaryRecap> getSalaryRecap({String? period});

  // ── Dashboard ─────────────────────────────────────────────────
  /// GET /dashboard-metrics
  Future<DashboardMetrics> getDashboardMetrics();

  /// GET /recent-sessions
  Future<List<CustomerSession>> getRecentSessions();

  // ── Gallery / Documentation ───────────────────────────────────
  /// POST /gallery/upload
  Future<String> uploadGalleryPhoto({
    required String sessionId,
    required String fileName,
    required Uint8List fileBytes,
  });
}
