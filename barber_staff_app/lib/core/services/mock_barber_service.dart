import 'dart:math';
import 'dart:typed_data';
import 'package:barber_staff_app/core/models/auth_response.dart';
import 'package:barber_staff_app/core/models/attendance_record.dart';
import 'package:barber_staff_app/core/models/customer_session.dart';
import 'package:barber_staff_app/core/models/dashboard_metrics.dart';
import 'package:barber_staff_app/core/models/salary_recap.dart';
import 'package:barber_staff_app/core/models/staff_profile.dart';
import 'barber_service_base.dart';

/// Fully in-memory mock service that simulates realistic barbershop
/// operations, including stateful check-in/out and cumulative earnings.
///
/// Usage:
/// ```dart
/// final service = MockBarberService();
/// final auth = await service.login(email: 'demo@barber.id', password: '1234');
/// ```
class MockBarberService implements BarberServiceBase {
  // ── Internal state ──────────────────────────────────────────
  bool _isLoggedIn = false;
  bool _isCheckedIn = false;
  DateTime? _todayCheckIn;
  final List<AttendanceRecord> _attendanceLog = [];
  final List<CustomerSession> _sessions = [];
  final List<String> _uploadedPhotos = [];
  final _rng = Random();

  /// Simulated network latency range.
  Future<void> _simulateLatency() =>
      Future.delayed(Duration(milliseconds: 200 + _rng.nextInt(400)));

  // ── Seed data ───────────────────────────────────────────────
  static final _mockStaff = StaffProfile(
    id: 'STF-001',
    name: 'Rizky Pratama',
    email: 'rizky@barber.id',
    phone: '+6281234567890',
    role: 'Senior Barber',
    bio: 'Specialist in Fade Cuts & Modern Styles. 5 years experience.',
    profilePictureUrl: null,
    barbershopId: 'BS-001',
    barbershopName: 'Urban Cuts Studio',
    status: 'active',
    createdAt: DateTime(2024, 1, 15),
    updatedAt: DateTime.now(),
  );

  StaffProfile _currentProfile = _mockStaff;

  static const _customerNames = [
    'Ahmad Rizki',
    'Budi Santoso',
    'Cahya Putra',
    'Dimas Arya',
    'Eko Prasetyo',
    'Fajar Nugroho',
    'Gilang Aditya',
    'Hendra Wijaya',
    'Irfan Maulana',
    'Joko Susilo',
    'Kevin Anggara',
    'Lukman Hakim',
  ];

  static const _services = [
    {'name': 'Fade Cut', 'price': 75000.0, 'commission': 22500.0},
    {'name': 'Buzz Cut', 'price': 50000.0, 'commission': 15000.0},
    {'name': 'Side Part', 'price': 80000.0, 'commission': 24000.0},
    {'name': 'Beard Trim', 'price': 40000.0, 'commission': 12000.0},
    {'name': 'Full Package', 'price': 120000.0, 'commission': 36000.0},
    {'name': 'Undercut', 'price': 70000.0, 'commission': 21000.0},
    {'name': 'Pompadour', 'price': 85000.0, 'commission': 25500.0},
    {'name': 'Kids Cut', 'price': 45000.0, 'commission': 13500.0},
  ];


  MockBarberService() {
    _seedHistoricalData();
  }

  /// Generates 30 days of attendance and session history.
  void _seedHistoricalData() {
    final now = DateTime.now();
    for (int day = 30; day >= 1; day--) {
      final date = now.subtract(Duration(days: day));
      // Skip weekends randomly (20% chance of day off)
      if (_rng.nextDouble() < 0.2) continue;

      final checkIn = DateTime(date.year, date.month, date.day,
          8 + _rng.nextInt(2), _rng.nextInt(60));
      final hoursWorked = 6.0 + _rng.nextDouble() * 3; // 6-9 hours
      final checkOut = checkIn.add(Duration(minutes: (hoursWorked * 60).round()));

      _attendanceLog.add(AttendanceRecord(
        id: 'ATT-${1000 + _attendanceLog.length}',
        staffId: _mockStaff.id,
        date: date,
        checkInTime: checkIn,
        checkOutTime: checkOut,
        hoursWorked: double.parse(hoursWorked.toStringAsFixed(1)),
        status: 'checked_out',
      ));

      // Generate 3-8 sessions per working day
      final sessionCount = 3 + _rng.nextInt(6);
      for (int s = 0; s < sessionCount; s++) {
        final svc = _services[_rng.nextInt(_services.length)];
        final customer = _customerNames[_rng.nextInt(_customerNames.length)];
        final sessionTime = checkIn.add(
          Duration(minutes: 30 + _rng.nextInt((hoursWorked * 50).round())),
        );
        _sessions.add(CustomerSession(
          id: 'DS${2000 + _sessions.length}',
          staffId: _mockStaff.id,
          customerName: customer,
          customerId: 'CUS-${_rng.nextInt(500).toString().padLeft(3, '0')}',
          service: svc['name'] as String,
          price: svc['price'] as double,
          commissionEarned: svc['commission'] as double,
          status: 'completed',
          createdAt: sessionTime,
          completedAt: sessionTime.add(
            Duration(minutes: 20 + _rng.nextInt(25)),
          ),
          galleryPhotoUrls: _rng.nextBool()
              ? ['https://placeholder.co/400x400/1a1a1a/ff6d00?text=Cut']
              : [],
        ));
      }
    }

    // Add today's sessions (mix of statuses)
    final today = DateTime(now.year, now.month, now.day);
    final todaySessions = [
      CustomerSession(
        id: 'DS1234',
        staffId: _mockStaff.id,
        customerName: 'Ahmad Rizki',
        customerId: 'CUS-042',
        service: 'Fade Cut',
        price: 75000,
        commissionEarned: 22500,
        status: 'completed',
        createdAt: today.add(const Duration(hours: 9, minutes: 15)),
        completedAt: today.add(const Duration(hours: 9, minutes: 45)),
        galleryPhotoUrls: [],
      ),
      CustomerSession(
        id: 'DS1235',
        staffId: _mockStaff.id,
        customerName: 'Budi Santoso',
        customerId: 'CUS-108',
        service: 'Beard Trim',
        price: 40000,
        commissionEarned: 12000,
        status: 'in_progress',
        createdAt: today.add(const Duration(hours: 10, minutes: 30)),
        galleryPhotoUrls: [],
      ),
      CustomerSession(
        id: 'DS1236',
        staffId: _mockStaff.id,
        customerName: 'Cahya Putra',
        customerId: 'CUS-215',
        service: 'Full Package',
        price: 120000,
        commissionEarned: 36000,
        status: 'completed',
        createdAt: today.add(const Duration(hours: 11, minutes: 0)),
        completedAt: today.add(const Duration(hours: 11, minutes: 40)),
        galleryPhotoUrls: [
          'https://placeholder.co/400x400/1a1a1a/00e676?text=Done'
        ],
      ),
      CustomerSession(
        id: 'DS1237',
        staffId: _mockStaff.id,
        customerName: 'Dimas Arya',
        customerId: 'CUS-331',
        service: 'Buzz Cut',
        price: 50000,
        commissionEarned: 15000,
        status: 'cancelled',
        createdAt: today.add(const Duration(hours: 12, minutes: 15)),
        galleryPhotoUrls: [],
      ),
      CustomerSession(
        id: 'DS1238',
        staffId: _mockStaff.id,
        customerName: 'Eko Prasetyo',
        customerId: 'CUS-044',
        service: 'Side Part',
        price: 80000,
        commissionEarned: 24000,
        status: 'completed',
        createdAt: today.add(const Duration(hours: 13, minutes: 0)),
        completedAt: today.add(const Duration(hours: 13, minutes: 30)),
        galleryPhotoUrls: [],
      ),
    ];
    _sessions.addAll(todaySessions);
  }

  // ═══════════════════════════════════════════════════════════════
  //  AUTH
  // ═══════════════════════════════════════════════════════════════

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    await _simulateLatency();

    // Accept any credentials for mock; reject empty
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required.');
    }

    _isLoggedIn = true;
    return AuthResponse(
      accessToken: 'mock_jwt_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_${DateTime.now().millisecondsSinceEpoch}',
      tokenType: 'Bearer',
      expiresIn: 3600,
      staff: _currentProfile,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  PROFILE
  // ═══════════════════════════════════════════════════════════════

  @override
  Future<StaffProfile> getProfile() async {
    await _simulateLatency();
    _requireAuth();
    return _currentProfile;
  }

  @override
  Future<StaffProfile> updateProfile(StaffProfile profile) async {
    await _simulateLatency();
    _requireAuth();
    _currentProfile = profile;
    return _currentProfile;
  }

  // ═══════════════════════════════════════════════════════════════
  //  ATTENDANCE
  // ═══════════════════════════════════════════════════════════════

  @override
  Future<AttendanceRecord> checkIn() async {
    await _simulateLatency();
    _requireAuth();

    if (_isCheckedIn) {
      throw Exception('Already checked in today. Check out first.');
    }

    _isCheckedIn = true;
    _todayCheckIn = DateTime.now();

    final record = AttendanceRecord(
      id: 'ATT-${1000 + _attendanceLog.length}',
      staffId: _currentProfile.id,
      date: DateTime.now(),
      checkInTime: _todayCheckIn,
      status: 'checked_in',
    );

    _attendanceLog.add(record);
    return record;
  }

  @override
  Future<AttendanceRecord> checkOut() async {
    await _simulateLatency();
    _requireAuth();

    if (!_isCheckedIn || _todayCheckIn == null) {
      throw Exception('Not checked in. Cannot check out.');
    }

    final checkOutTime = DateTime.now();
    final hours =
        checkOutTime.difference(_todayCheckIn!).inMinutes / 60.0;

    // Update the last record in the log
    final idx = _attendanceLog.length - 1;
    final updated = _attendanceLog[idx].copyWith(
      checkOutTime: checkOutTime,
      hoursWorked: double.parse(hours.toStringAsFixed(1)),
      status: 'checked_out',
    );
    _attendanceLog[idx] = updated;

    _isCheckedIn = false;
    _todayCheckIn = null;

    return updated;
  }

  @override
  Future<List<AttendanceRecord>> getAttendanceHistory() async {
    await _simulateLatency();
    _requireAuth();
    // Return most recent first
    return _attendanceLog.reversed.toList();
  }

  // ═══════════════════════════════════════════════════════════════
  //  SALARY RECAP
  // ═══════════════════════════════════════════════════════════════

  @override
  Future<SalaryRecap> getSalaryRecap({String? period}) async {
    await _simulateLatency();
    _requireAuth();

    // Compute from historical sessions
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthSessions = _sessions.where((s) =>
        s.status == 'completed' && s.createdAt.isAfter(monthStart));

    final totalCommission = monthSessions.fold<double>(
        0, (sum, s) => sum + s.commissionEarned);

    final monthAttendance = _attendanceLog.where(
        (a) => a.date.isAfter(monthStart) && a.status == 'checked_out');
    final totalHours = monthAttendance.fold<double>(
        0, (sum, a) => sum + (a.hoursWorked ?? 0));

    // Base salary: Rp 2,500,000 + daily rate * days worked
    const baseSalary = 2500000.0;
    final bonus = monthSessions.length >= 100 ? 500000.0 : 0.0;

    return SalaryRecap(
      id: 'SAL-${now.year}${now.month.toString().padLeft(2, '0')}',
      staffId: _currentProfile.id,
      period: '${_monthName(now.month)} ${now.year}',
      baseSalary: baseSalary,
      commission: totalCommission,
      bonus: bonus,
      deductions: 0,
      totalEarnings: baseSalary + totalCommission + bonus,
      totalDaysWorked: monthAttendance.length,
      totalHoursWorked: double.parse(totalHours.toStringAsFixed(1)),
      totalCustomersServed: monthSessions.length,
      status: 'draft',
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  DASHBOARD
  // ═══════════════════════════════════════════════════════════════

  @override
  Future<DashboardMetrics> getDashboardMetrics() async {
    await _simulateLatency();
    _requireAuth();

    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todaySessions = _sessions.where(
        (s) => s.createdAt.isAfter(todayStart) && s.status == 'completed');

    final earnings =
        todaySessions.fold<double>(0, (sum, s) => sum + s.price);
    final commission =
        todaySessions.fold<double>(0, (sum, s) => sum + s.commissionEarned);

    double hoursWorked = 0;
    if (_isCheckedIn && _todayCheckIn != null) {
      hoursWorked = DateTime.now().difference(_todayCheckIn!).inMinutes / 60.0;
    }

    return DashboardMetrics(
      todayEarnings: earnings + commission,
      earningsTrendPercent: 29.0,
      customersServed: todaySessions.length,
      customersTrendPercent: 8.0,
      hoursWorked: double.parse(hoursWorked.toStringAsFixed(1)),
      hoursTrendPercent: -3.0,
      isCheckedIn: _isCheckedIn,
    );
  }

  @override
  Future<List<CustomerSession>> getRecentSessions() async {
    await _simulateLatency();
    _requireAuth();
    // Return the 10 most recent sessions
    final sorted = List<CustomerSession>.from(_sessions)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(10).toList();
  }

  // ═══════════════════════════════════════════════════════════════
  //  GALLERY / DOCUMENTATION
  // ═══════════════════════════════════════════════════════════════

  @override
  Future<String> uploadGalleryPhoto({
    required String sessionId,
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    // Simulate upload with longer delay
    await Future.delayed(
        Duration(milliseconds: 500 + _rng.nextInt(1000)));
    _requireAuth();

    final url =
        'https://cdn.barber.id/gallery/$sessionId/$fileName';
    _uploadedPhotos.add(url);

    // Attach to the matching session
    final idx = _sessions.indexWhere((s) => s.id == sessionId);
    if (idx != -1) {
      final old = _sessions[idx];
      _sessions[idx] = CustomerSession(
        id: old.id,
        staffId: old.staffId,
        customerName: old.customerName,
        customerId: old.customerId,
        service: old.service,
        price: old.price,
        commissionEarned: old.commissionEarned,
        status: old.status,
        createdAt: old.createdAt,
        completedAt: old.completedAt,
        galleryPhotoUrls: [...old.galleryPhotoUrls, url],
      );
    }

    return url;
  }

  // ═══════════════════════════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════════════════════════

  void _requireAuth() {
    if (!_isLoggedIn) throw Exception('Not authenticated. Call login() first.');
  }

  String _monthName(int month) {
    const names = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return names[month];
  }

  // ── Introspection (useful for tests & debugging) ─────────────
  bool get isLoggedIn => _isLoggedIn;
  bool get isCheckedIn => _isCheckedIn;
  int get totalSessions => _sessions.length;
  int get totalAttendanceRecords => _attendanceLog.length;
  List<String> get uploadedPhotos => List.unmodifiable(_uploadedPhotos);
}
