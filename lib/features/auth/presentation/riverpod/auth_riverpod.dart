import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_container.dart';
import '../../di/auth_di.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

final _authDIProvider = Provider<AuthDI>((ref) {
  final container = ref.watch(appContainerProvider);
  return AuthDI(container!);
});

final _loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  return ref.watch(_authDIProvider).loginUsecase;
});

final _registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  return ref.watch(_authDIProvider).registerUsecase;
});

final _logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  return ref.watch(_authDIProvider).logoutUsecase;
});

enum AuthStatus { initial, unauthenticated, authenticated }

class AuthState {
  final AuthStatus status;
  final bool isLoading;
  final String? error;
  final bool isGuardian;
  final UserEntity? user;

  const AuthState({
    this.status = AuthStatus.initial,
    this.isLoading = false,
    this.error,
    this.isGuardian = false,
    this.user,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    bool? isLoading,
    String? error,
    bool? isGuardian,
    UserEntity? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isGuardian: isGuardian ?? this.isGuardian,
      user: user ?? this.user,
    );
  }
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async => const AuthState();

  Future<void> login({String? email, String? password}) async {
    final previous = state.requireValue;
    state = const AsyncValue.loading();

    try {
      final user = await ref.read(_loginUsecaseProvider)(
        email: email,
        password: password,
      );
      state = AsyncValue.data(
        previous.copyWith(
          status: AuthStatus.authenticated,
          isLoading: false,
          isGuardian: user.isGuardian,
          user: user,
        ),
      );
    } on Exception catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> register({String? name, String? email, String? role}) async {
    final previous = state.requireValue;
    state = const AsyncValue.loading();

    try {
      final user = await ref.read(_registerUsecaseProvider)(
        name: name,
        email: email,
        role: role,
      );
      state = AsyncValue.data(
        previous.copyWith(
          status: AuthStatus.authenticated,
          isLoading: false,
          isGuardian: user.isGuardian,
          user: user,
        ),
      );
    } on Exception catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> logout() async {
    await ref.read(_logoutUsecaseProvider)();
    await ref.read(appContainerProvider)!.tokenStorage.clearTokens();
    state = const AsyncValue.data(
      AuthState(status: AuthStatus.unauthenticated),
    );
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
