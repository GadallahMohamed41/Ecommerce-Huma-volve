import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_categories_usecase.dart';
import '../../features/home/domain/usecases/get_products_usecase.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';

class ServiceLocator {
  ServiceLocator._();

  static final AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSourceImpl();
  static final AuthRepository authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
  static final LoginUseCase loginUseCase = LoginUseCase(authRepository);
  static final SignUpUseCase signUpUseCase = SignUpUseCase(authRepository);
  static final ResetPasswordUseCase resetPasswordUseCase = ResetPasswordUseCase(authRepository);
  static final LogoutUseCase logoutUseCase = LogoutUseCase(authRepository);
  static final GetCurrentUserUseCase getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);

  static AuthCubit createAuthCubit() {
    return AuthCubit(
      repository: authRepository,
      loginUseCase: loginUseCase,
      signUpUseCase: signUpUseCase,
      resetPasswordUseCase: resetPasswordUseCase,
      logoutUseCase: logoutUseCase,
      getCurrentUserUseCase: getCurrentUserUseCase,
    );
  }

  static final HomeRemoteDataSource homeRemoteDataSource = HomeRemoteDataSourceImpl();
  static final HomeRepository homeRepository = HomeRepositoryImpl(remoteDataSource: homeRemoteDataSource);
  static final GetProductsUseCase getProductsUseCase = GetProductsUseCase(homeRepository);
  static final GetCategoriesUseCase getCategoriesUseCase = GetCategoriesUseCase(homeRepository);

  static HomeCubit createHomeCubit() {
    return HomeCubit(
      repository: homeRepository,
      getProductsUseCase: getProductsUseCase,
      getCategoriesUseCase: getCategoriesUseCase,
    );
  }
}
