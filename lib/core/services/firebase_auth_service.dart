import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuthService._internal();

  /// Currently logged in Firebase User
  User? get currentUser => _auth.currentUser;

  /// Stream of user auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Check if user is logged in
  bool get isAuthenticated => _auth.currentUser != null;

  /// Register new user with Email, Password and Name
  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Save user display name
      if (credential.user != null && name.trim().isNotEmpty) {
        await credential.user!.updateDisplayName(name.trim());
        await credential.user!.reload();
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw getErrorMessage(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  /// Sign in existing user with Email and Password
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw getErrorMessage(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  /// Send password reset link to user email
  Future<void> sendPasswordReset({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw getErrorMessage(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Convert Firebase error codes into user-friendly messages
  static String getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
