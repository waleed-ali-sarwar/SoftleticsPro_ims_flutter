class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;
  final DateTime createdAt;
  final String? avatar;
  final String? phone;
  final String? department;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.createdAt,
    this.avatar,
    this.phone,
    this.department,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      avatar: json['avatar'],
      phone: json['phone'],
      department: json['department'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'avatar': avatar,
      'phone': phone,
      'department': department,
    };
  }
}
