/// Single attendance log entry (one check-in / check-out pair).
class AttendanceRecord {
  final String id;
  final String staffId;
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final double? hoursWorked;
  final String status; // "checked_in", "checked_out", "missed"

  const AttendanceRecord({
    required this.id,
    required this.staffId,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.hoursWorked,
    required this.status,
  });

  /// Whether the staff is currently clocked in but hasn't checked out.
  bool get isActive => checkInTime != null && checkOutTime == null;

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as String,
      staffId: json['staff_id'] as String,
      date: DateTime.parse(json['date'] as String),
      checkInTime: json['check_in_time'] != null
          ? DateTime.parse(json['check_in_time'] as String)
          : null,
      checkOutTime: json['check_out_time'] != null
          ? DateTime.parse(json['check_out_time'] as String)
          : null,
      hoursWorked: (json['hours_worked'] as num?)?.toDouble(),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staff_id': staffId,
      'date': date.toIso8601String(),
      'check_in_time': checkInTime?.toIso8601String(),
      'check_out_time': checkOutTime?.toIso8601String(),
      'hours_worked': hoursWorked,
      'status': status,
    };
  }

  AttendanceRecord copyWith({
    DateTime? checkOutTime,
    double? hoursWorked,
    String? status,
  }) {
    return AttendanceRecord(
      id: id,
      staffId: staffId,
      date: date,
      checkInTime: checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      hoursWorked: hoursWorked ?? this.hoursWorked,
      status: status ?? this.status,
    );
  }

  @override
  String toString() =>
      'AttendanceRecord($id, $date, in=$checkInTime, out=$checkOutTime)';
}
