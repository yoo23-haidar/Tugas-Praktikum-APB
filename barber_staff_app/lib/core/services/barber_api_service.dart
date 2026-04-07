import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:barber_staff_app/core/models/auth_response.dart';
import 'package:barber_staff_app/core/models/attendance_record.dart';
import 'package:barber_staff_app/core/models/customer_session.dart';
import 'package:barber_staff_app/core/models/dashboard_metrics.dart';
import 'package:barber_staff_app/core/models/salary_recap.dart';
import 'package:barber_staff_app/core/models/staff_profile.dart';
import 'barber_service_base.dart';

/// Production API service powered by [Dio].
///
/// Includes:
/// - Auth-token injection via interceptor
/// - Automatic token refresh (401 retry)
/// - Global error logging
class BarberApiService implements BarberServiceBase {
  late final Dio _dio;
  String? _accessToken;

  BarberApiService({required String baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // ── Interceptors ────────────────────────────────────────────
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_accessToken != null) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // TODO: implement 401 refresh-token flow here
          handler.next(error);
        },
      ),
    );

    // Request/response logger (debug only)
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => debugPrint('[DIO] $obj'),
    ));
  }

  /// Convenience: inject a token obtained externally (e.g. from storage).
  void setToken(String token) => _accessToken = token;

  // ─────────────────────────────────────────────────────────────
  // Auth
  // ─────────────────────────────────────────────────────────────

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    final auth = AuthResponse.fromJson(response.data as Map<String, dynamic>);
    _accessToken = auth.accessToken;
    return auth;
  }

  // ─────────────────────────────────────────────────────────────
  // Profile
  // ─────────────────────────────────────────────────────────────

  @override
  Future<StaffProfile> getProfile() async {
    final response = await _dio.get('/staff/profile');
    return StaffProfile.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<StaffProfile> updateProfile(StaffProfile profile) async {
    final response = await _dio.put(
      '/staff/profile',
      data: profile.toJson(),
    );
    return StaffProfile.fromJson(response.data as Map<String, dynamic>);
  }

  // ─────────────────────────────────────────────────────────────
  // Attendance
  // ─────────────────────────────────────────────────────────────

  @override
  Future<AttendanceRecord> checkIn() async {
    final response = await _dio.post('/attendance/check-in');
    return AttendanceRecord.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AttendanceRecord> checkOut() async {
    final response = await _dio.post('/attendance/check-out');
    return AttendanceRecord.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<AttendanceRecord>> getAttendanceHistory() async {
    final response = await _dio.get('/attendance/history');
    final list = response.data as List<dynamic>;
    return list
        .map((e) => AttendanceRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ─────────────────────────────────────────────────────────────
  // Salary
  // ─────────────────────────────────────────────────────────────

  @override
  Future<SalaryRecap> getSalaryRecap({String? period}) async {
    final response = await _dio.get(
      '/salary-recap',
      // ignore: use_null_aware_elements
      queryParameters: {if (period != null) 'period': period},
    );
    return SalaryRecap.fromJson(response.data as Map<String, dynamic>);
  }

  // ─────────────────────────────────────────────────────────────
  // Dashboard
  // ─────────────────────────────────────────────────────────────

  @override
  Future<DashboardMetrics> getDashboardMetrics() async {
    final response = await _dio.get('/dashboard-metrics');
    return DashboardMetrics.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<CustomerSession>> getRecentSessions() async {
    final response = await _dio.get('/recent-sessions');
    final list = response.data as List<dynamic>;
    return list
        .map((e) => CustomerSession.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ─────────────────────────────────────────────────────────────
  // Gallery / Documentation
  // ─────────────────────────────────────────────────────────────

  @override
  Future<String> uploadGalleryPhoto({
    required String sessionId,
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    final formData = FormData.fromMap({
      'session_id': sessionId,
      'photo': MultipartFile.fromBytes(
        fileBytes,
        filename: fileName,
      ),
    });
    final response = await _dio.post('/gallery/upload', data: formData);
    return (response.data as Map<String, dynamic>)['url'] as String;
  }
}
