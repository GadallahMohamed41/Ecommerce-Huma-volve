import '../../../../core/services/firebase_auth_service.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> sendPasswordReset({
    required String email,
  });

  Future<void> logout();

  UserModel? getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuthService _firebaseAuthService;

  AuthRemoteDataSourceImpl({FirebaseAuthService? firebaseAuthService})
      : _firebaseAuthService = firebaseAuthService ?? FirebaseAuthService();

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuthService.login(
      email: email,
      password: password,
    );
    final user = credential.user ?? _firebaseAuthService.currentUser;
    if (user == null) {
      throw 'Authentication failed. Please try again.';
    }
    return UserModel.fromFirebaseUser(user);
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuthService.signUp(
      name: name,
      email: email,
      password: password,
    );
    final user = credential.user ?? _firebaseAuthService.currentUser;
    if (user == null) {
      throw 'Registration failed. Please try again.';
    }
    return UserModel.fromFirebaseUser(user, fallbackName: name);
  }

  @override
  Future<void> sendPasswordReset({required String email}) {
    return _firebaseAuthService.sendPasswordReset(email: email);
  }

  @override
  Future<void> logout() {
    return _firebaseAuthService.signOut();
  }

  @override
  UserModel? getCurrentUser() {
    final user = _firebaseAuthService.currentUser;
    if (user == null) return null;
    return UserModel.fromFirebaseUser(user);
  }
}
