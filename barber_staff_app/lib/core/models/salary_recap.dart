/// Monthly / periodic salary recap for a staff member.
class SalaryRecap {
  final String id;
  final String staffId;
  final String period; // e.g. "2026-04", "March 2026"
  final double baseSalary;
  final double commission;
  final double bonus;
  final double deductions;
  final double totalEarnings;
  final int totalDaysWorked;
  final double totalHoursWorked;
  final int totalCustomersServed;
  final String status; // "draft", "finalized", "paid"

  const SalaryRecap({
    required this.id,
    required this.staffId,
    required this.period,
    required this.baseSalary,
    required this.commission,
    this.bonus = 0,
    this.deductions = 0,
    required this.totalEarnings,
    required this.totalDaysWorked,
    required this.totalHoursWorked,
    required this.totalCustomersServed,
    required this.status,
  });

  factory SalaryRecap.fromJson(Map<String, dynamic> json) {
    return SalaryRecap(
      id: json['id'] as String,
      staffId: json['staff_id'] as String,
      period: json['period'] as String,
      baseSalary: (json['base_salary'] as num).toDouble(),
      commission: (json['commission'] as num).toDouble(),
      bonus: (json['bonus'] as num?)?.toDouble() ?? 0,
      deductions: (json['deductions'] as num?)?.toDouble() ?? 0,
      totalEarnings: (json['total_earnings'] as num).toDouble(),
      totalDaysWorked: json['total_days_worked'] as int,
      totalHoursWorked: (json['total_hours_worked'] as num).toDouble(),
      totalCustomersServed: json['total_customers_served'] as int,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staff_id': staffId,
      'period': period,
      'base_salary': baseSalary,
      'commission': commission,
      'bonus': bonus,
      'deductions': deductions,
      'total_earnings': totalEarnings,
      'total_days_worked': totalDaysWorked,
      'total_hours_worked': totalHoursWorked,
      'total_customers_served': totalCustomersServed,
      'status': status,
    };
  }

  @override
  String toString() =>
      'SalaryRecap($period, total=Rp ${totalEarnings.toStringAsFixed(0)})';
}
