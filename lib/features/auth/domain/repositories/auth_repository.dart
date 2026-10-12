import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({
    required String email,
    required String password,
  });

  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> sendPasswordReset({
    required String email,
  });

  Future<void> logout();

  UserEntity? getCurrentUser();
}
