import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late final LoginUseCase _loginUseCase;
  late final SignUpUseCase _signUpUseCase;
  late final ResetPasswordUseCase _resetPasswordUseCase;
  late final LogoutUseCase _logoutUseCase;
  late final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthCubit({
    AuthRepository? repository,
    LoginUseCase? loginUseCase,
    SignUpUseCase? signUpUseCase,
    ResetPasswordUseCase? resetPasswordUseCase,
    LogoutUseCase? logoutUseCase,
    GetCurrentUserUseCase? getCurrentUserUseCase,
  }) : super(AuthInitialState()) {
    final repo = repository ?? AuthRepositoryImpl();
    _loginUseCase = loginUseCase ?? LoginUseCase(repo);
    _signUpUseCase = signUpUseCase ?? SignUpUseCase(repo);
    _resetPasswordUseCase = resetPasswordUseCase ?? ResetPasswordUseCase(repo);
    _logoutUseCase = logoutUseCase ?? LogoutUseCase(repo);
    _getCurrentUserUseCase = getCurrentUserUseCase ?? GetCurrentUserUseCase(repo);
  }

  static AuthCubit get(BuildContext context) => BlocProvider.of<AuthCubit>(context);

  UserEntity? get currentUser => _getCurrentUserUseCase();

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoadingState());
    try {
      final user = await _loginUseCase(email: email, password: password);
      emit(
        AuthSuccessState(
          user: user,
          message: 'Welcome back, ${user.name}!',
        ),
      );
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoadingState());
    try {
      final user = await _signUpUseCase(
        name: name,
        email: email,
        password: password,
      );
      emit(
        AuthSuccessState(
          user: user,
          message: 'Account created! Welcome, ${user.name}!',
        ),
      );
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _resetPasswordUseCase(email: email);
      emit(AuthPasswordResetSentState(email.trim()));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoadingState());
    try {
      await _logoutUseCase();
      emit(AuthLoggedOutState());
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }
}
