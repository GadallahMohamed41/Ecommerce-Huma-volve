import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/dummy_data.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.avatarUrl,
  });

  factory UserModel.fromFirebaseUser(User user, {String? fallbackName}) {
    final displayName = (user.displayName != null && user.displayName!.trim().isNotEmpty)
        ? user.displayName!.trim()
        : (fallbackName != null && fallbackName.trim().isNotEmpty)
            ? fallbackName.trim()
            : (user.email?.split('@').first ?? 'User');

    return UserModel(
      id: user.uid,
      name: displayName,
      email: user.email ?? '',
      avatarUrl: user.photoURL ?? dummyUser.profilePictureUrl,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '0',
      name: json['name']?.toString() ?? 'User',
      email: json['email']?.toString() ?? '',
      avatarUrl: json['avatar']?.toString() ?? dummyUser.profilePictureUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatarUrl,
    };
  }
}
