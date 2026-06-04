class User {
  final String id;
  final String username;
  final String password;
  final String role;
  final String? cityId;
  final String fullName;
  final bool isActive;
  final DateTime? lastLogin;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    this.cityId,
    required this.fullName,
    this.isActive = true,
    this.lastLogin,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'role': role,
      'city_id': cityId,
      'full_name': fullName,
      'is_active': isActive ? 1 : 0,
      'last_login': lastLogin?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      role: map['role'],
      cityId: map['city_id'],
      fullName: map['full_name'],
      isActive: map['is_active'] == 1,
      lastLogin: map['last_login'] != null
          ? DateTime.parse(map['last_login'])
          : null,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  bool get isAdmin => role == 'admin';
  bool get isCityManager => role == 'city_manager';
}
