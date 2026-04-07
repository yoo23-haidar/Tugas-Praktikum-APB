/// Staff member profile model.
///
/// Maps to the `users/staff` resource on the backend.
class StaffProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role; // e.g. "Senior Barber", "Junior Barber"
  final String? bio;
  final String? profilePictureUrl;
  final String barbershopId;
  final String barbershopName;
  final String status; // "active", "inactive", "on_leave"
  final DateTime createdAt;
  final DateTime updatedAt;

  const StaffProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.bio,
    this.profilePictureUrl,
    required this.barbershopId,
    required this.barbershopName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StaffProfile.fromJson(Map<String, dynamic> json) {
    return StaffProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      bio: json['bio'] as String?,
      profilePictureUrl: json['profile_picture_url'] as String?,
      barbershopId: json['barbershop_id'] as String,
      barbershopName: json['barbershop_name'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'bio': bio,
      'profile_picture_url': profilePictureUrl,
      'barbershop_id': barbershopId,
      'barbershop_name': barbershopName,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  StaffProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? role,
    String? bio,
    String? profilePictureUrl,
    String? status,
  }) {
    return StaffProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      barbershopId: barbershopId,
      barbershopName: barbershopName,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() => 'StaffProfile($id, $name, $role)';
}
