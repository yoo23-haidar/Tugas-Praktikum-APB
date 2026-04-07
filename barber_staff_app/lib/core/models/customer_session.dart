/// A single customer service session (haircut / treatment).
///
/// Maps to the rows displayed in the "Recent Visits" table
/// on the dashboard.
class CustomerSession {
  final String id; // e.g. "DS1234"
  final String staffId;
  final String customerName;
  final String? customerId;
  final String service; // e.g. "Fade Cut", "Beard Trim"
  final double price;
  final double commissionEarned;
  final String status; // "completed", "in_progress", "cancelled"
  final DateTime createdAt;
  final DateTime? completedAt;
  final List<String> galleryPhotoUrls;

  const CustomerSession({
    required this.id,
    required this.staffId,
    required this.customerName,
    this.customerId,
    required this.service,
    required this.price,
    required this.commissionEarned,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.galleryPhotoUrls = const [],
  });

  /// Formatted display ID shown in the UI (e.g. "#DS1234").
  String get displayId => '#$id';

  /// Whether at least one documentation photo has been uploaded.
  bool get hasDocumentation => galleryPhotoUrls.isNotEmpty;

  factory CustomerSession.fromJson(Map<String, dynamic> json) {
    return CustomerSession(
      id: json['id'] as String,
      staffId: json['staff_id'] as String,
      customerName: json['customer_name'] as String,
      customerId: json['customer_id'] as String?,
      service: json['service'] as String,
      price: (json['price'] as num).toDouble(),
      commissionEarned: (json['commission_earned'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      galleryPhotoUrls: (json['gallery_photo_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staff_id': staffId,
      'customer_name': customerName,
      'customer_id': customerId,
      'service': service,
      'price': price,
      'commission_earned': commissionEarned,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'gallery_photo_urls': galleryPhotoUrls,
    };
  }

  @override
  String toString() => 'CustomerSession($displayId, $customerName, $service)';
}
