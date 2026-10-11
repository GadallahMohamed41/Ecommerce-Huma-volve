class UserModel {
  final int id;
  final String email;
  final String name;
  final String role;
  final String avatar;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'customer',
      avatar: json['avatar'] ?? 'https://picsum.photos/800',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'avatar': avatar,
    };
  }
}
