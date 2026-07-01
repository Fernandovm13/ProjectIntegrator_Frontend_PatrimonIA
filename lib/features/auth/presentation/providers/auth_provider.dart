import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/user.dart';

class AuthState {
  final bool isAuthenticated;
  final AppUser? user;
  final bool isGuardian;

  const AuthState({this.isAuthenticated = false, this.user, this.isGuardian = false});

  AuthState copyWith({
    bool? isAuthenticated,
    AppUser? user,
    bool? isGuardian,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      isGuardian: isGuardian ?? this.isGuardian,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  void login({String? email, String? password}) {
    state = state.copyWith(
      isAuthenticated: true,
      user: const AppUser(
        email: 'user@patrimonia.app',
        role: 'Explorador',
      ),
      isGuardian: false,
    );
  }

  void register({String? name, String? email, String? role}) {
    state = state.copyWith(
      isAuthenticated: true,
      user: AppUser(
        name: name ?? 'Usuario',
        email: email ?? 'user@patrimonia.app',
        role: role == 'guardian' ? 'Guardián' : 'Explorador',
      ),
      isGuardian: role == 'guardian',
    );
  }

  void updateUser(AppUser user) {
    state = state.copyWith(user: user);
  }

  void logout() {
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
