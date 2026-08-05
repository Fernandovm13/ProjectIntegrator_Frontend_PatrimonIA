import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<UserEntity> login({String? email, String? password}) async {
    final model = await localDataSource.login(email: email, password: password);
    return model.toEntity();
  }

  @override
  Future<UserEntity> register({
    String? name,
    String? email,
    String? role,
  }) async {
    final model = await localDataSource.register(
      name: name,
      email: email,
      role: role,
    );
    return model.toEntity();
  }

  @override
  Future<void> logout() async {}
}
