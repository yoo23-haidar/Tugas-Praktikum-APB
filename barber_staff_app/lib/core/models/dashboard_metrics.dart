/// Aggregated metrics shown on the dashboard metric cards.
class DashboardMetrics {
  final double todayEarnings;
  final double earningsTrendPercent; // e.g. +29.0
  final int customersServed;
  final double customersTrendPercent; // e.g. +8.0
  final double hoursWorked;
  final double hoursTrendPercent; // e.g. -3.0
  final bool isCheckedIn;

  const DashboardMetrics({
    required this.todayEarnings,
    required this.earningsTrendPercent,
    required this.customersServed,
    required this.customersTrendPercent,
    required this.hoursWorked,
    required this.hoursTrendPercent,
    required this.isCheckedIn,
  });

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    return DashboardMetrics(
      todayEarnings: (json['today_earnings'] as num).toDouble(),
      earningsTrendPercent:
          (json['earnings_trend_percent'] as num).toDouble(),
      customersServed: json['customers_served'] as int,
      customersTrendPercent:
          (json['customers_trend_percent'] as num).toDouble(),
      hoursWorked: (json['hours_worked'] as num).toDouble(),
      hoursTrendPercent: (json['hours_trend_percent'] as num).toDouble(),
      isCheckedIn: json['is_checked_in'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'today_earnings': todayEarnings,
      'earnings_trend_percent': earningsTrendPercent,
      'customers_served': customersServed,
      'customers_trend_percent': customersTrendPercent,
      'hours_worked': hoursWorked,
      'hours_trend_percent': hoursTrendPercent,
      'is_checked_in': isCheckedIn,
    };
  }
}
