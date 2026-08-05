import '../repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository _repository;

  const LogoutUsecase({required AuthRepository repository})
      : _repository = repository;

  Future<void> call() {
    return _repository.logout();
  }
}
