import '../../../core/di/app_container.dart';
import '../data/datasources/auth_local_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/register_usecase.dart';

class AuthDI {
  final AppContainer appContainer;

  late final AuthLocalDataSource authLocalDataSource;
  late final AuthRepository authRepository;
  late final LoginUsecase loginUsecase;
  late final RegisterUsecase registerUsecase;
  late final LogoutUsecase logoutUsecase;

  AuthDI(this.appContainer) {
    _init();
  }

  void _init() {
    authLocalDataSource = const AuthLocalDataSourceImpl();

    authRepository = AuthRepositoryImpl(localDataSource: authLocalDataSource);

    loginUsecase = LoginUsecase(repository: authRepository);
    registerUsecase = RegisterUsecase(repository: authRepository);
    logoutUsecase = LogoutUsecase(repository: authRepository);
  }
}
