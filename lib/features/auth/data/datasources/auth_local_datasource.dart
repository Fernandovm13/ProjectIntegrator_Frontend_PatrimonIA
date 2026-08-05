import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> login({String? email, String? password});

  Future<UserModel> register({String? name, String? email, String? role});
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl();

  @override
  Future<UserModel> login({String? email, String? password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return UserModel(
      name: 'María Xochitl López',
      email: email ?? 'user@patrimonia.app',
      role: 'Explorador',
      community: 'San Cristóbal de las Casas',
      location: 'San Cristóbal de las Casas, Chiapas',
      storiesSaved: 12,
      storiesRead: 45,
      communities: 3,
    );
  }

  @override
  Future<UserModel> register({String? name, String? email, String? role}) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return UserModel(
      name: name ?? 'Usuario',
      email: email ?? 'user@patrimonia.app',
      role: role == 'guardian' ? 'Guardián' : 'Explorador',
      community: 'San Cristóbal de las Casas',
      location: 'San Cristóbal de las Casas, Chiapas',
      storiesSaved: 12,
      storiesRead: 45,
      communities: 3,
    );
  }
}
