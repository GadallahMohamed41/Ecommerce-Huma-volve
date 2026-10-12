import '../../domain/entities/user_entity.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final UserEntity user;
  final String message;

  AuthSuccessState({
    required this.user,
    required this.message,
  });
}

class AuthPasswordResetSentState extends AuthState {
  final String email;

  AuthPasswordResetSentState(this.email);
}

class AuthLoggedOutState extends AuthState {}

class AuthErrorState extends AuthState {
  final String errorMessage;

  AuthErrorState(this.errorMessage);
}
