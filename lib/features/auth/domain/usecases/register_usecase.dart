import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository _repository;

  const RegisterUsecase({required AuthRepository repository})
      : _repository = repository;

  Future<UserEntity> call({String? name, String? email, String? role}) {
    return _repository.register(name: name, email: email, role: role);
  }
}
