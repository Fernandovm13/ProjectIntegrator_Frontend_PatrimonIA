import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/models/user.dart';

class AuthState {
  final bool isAuthenticated;
  final AppUser? user;
  final bool isGuardian;
  final String? token;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.isAuthenticated = false,
    this.user,
    this.isGuardian = false,
    this.token,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    AppUser? user,
    bool? isGuardian,
    String? token,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      isGuardian: isGuardian ?? this.isGuardian,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._apiClient) : super(const AuthState());

  final ApiClient _apiClient;

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await _apiClient.post(
        '/auth/login',
        body: {'email': email, 'password': password},
      );

      final data = _asMap(response.data);
      if (!response.isSuccess) {
        throw Exception(_errorFrom(data) ?? 'No se pudo iniciar sesion.');
      }

      final token = data['token'] as String?;
      if (token == null || token.isEmpty) {
        throw Exception('El servidor no devolvio un token.');
      }

      final profile = await _fetchProfile(token);

      state = state.copyWith(
        isAuthenticated: true,
        user: profile,
        isGuardian: _isGuardianRole(profile.roleId, profile.roleName),
        token: token,
        isLoading: false,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        errorMessage: _friendlyError(error),
      );
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final roleId = role == 'guardian' ? 3 : 2;

    try {
      final response = await _apiClient.post(
        '/auth/register',
        body: {
          'username': name,
          'email': email,
          'password': password,
          'role_id': roleId,
          'is_premium': false,
        },
      );

      final data = _asMap(response.data);
      if (!response.isSuccess) {
        throw Exception(_errorFrom(data) ?? 'No se pudo crear la cuenta.');
      }

      final token = data['token'] as String?;
      final sessionUser = _asMap(data['user']);
      final profile = token == null || token.isEmpty
          ? _userFromProfile({
              ...sessionUser,
              if (sessionUser.isEmpty) ...{
                'username': name,
                'email': email,
                'role_id': roleId,
                'role_name': role == 'guardian' ? 'contribuidor' : 'turista',
              },
            })
          : await _fetchProfile(token, fallback: sessionUser);

      state = state.copyWith(
        isAuthenticated: true,
        user: profile,
        isGuardian: _isGuardianRole(profile.roleId, profile.roleName),
        token: token,
        isLoading: false,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        errorMessage: _friendlyError(error),
      );
    }
  }

  void loginAnonymously() {}

  Future<void> fetchProfile() async {
    final token = state.token;
    if (token == null) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final profile = await _fetchProfile(token);
      state = state.copyWith(
        user: profile,
        isGuardian: _isGuardianRole(profile.roleId, profile.roleName),
        isLoading: false,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _friendlyError(error),
      );
    }
  }

  void updateUser(AppUser user) {
    state = state.copyWith(user: user);
  }

  void logout() {
    state = const AuthState();
  }

  Future<AppUser> _fetchProfile(
    String token, {
    Map<String, dynamic> fallback = const {},
  }) async {
    final response = await _apiClient.get('/users/profile', token: token);
    final data = _asMap(response.data);

    if (!response.isSuccess) {
      if (fallback.isNotEmpty) return _userFromProfile(fallback);
      throw Exception(_errorFrom(data) ?? 'No se pudo cargar el perfil.');
    }

    return _userFromProfile(data);
  }

  Map<String, dynamic> _asMap(dynamic data) {
    return data is Map<String, dynamic> ? data : {};
  }

  AppUser _userFromProfile(Map<String, dynamic> data) {
    final roleId = _intFrom(data['role_id'] ?? data['roleId']);
    final roleName = data['role_name'] is String
        ? data['role_name'] as String
        : data['roleName'] is String
        ? data['roleName'] as String
        : null;
    final username = data['username'] is String
        ? data['username'] as String
        : null;
    final email = data['email'] is String ? data['email'] as String : null;

    return AppUser(
      id: _intFrom(data['id']),
      name: username ?? email ?? 'Usuario',
      email: email ?? 'user@patrimonia.app',
      role: _displayRole(roleId, roleName),
      roleId: roleId,
      roleName: roleName,
      isPremium: _boolFrom(data['is_premium'] ?? data['isPremium']),
      reputationScore:
          _intFrom(data['reputation_score'] ?? data['reputationScore']) ?? 0,
      createdAt: _dateFrom(data['created_at'] ?? data['createdAt']),
      storiesSaved:
          _intFrom(data['stories_saved'] ?? data['storiesSaved']) ?? 0,
      storiesRead: _intFrom(data['stories_read'] ?? data['storiesRead']) ?? 0,
      storiesCreated:
          _intFrom(data['stories_created'] ?? data['storiesCreated']) ?? 0,
      communities: _intFrom(data['communities']) ?? 0,
    );
  }

  String _displayRole(int? roleId, String? roleName) {
    final normalized = roleName?.toLowerCase();
    if (roleId == 1 || normalized == 'admin') return 'Admin';
    if (roleId == 3 || normalized == 'contribuidor') return 'Guardian';
    return 'Explorador';
  }

  bool _isGuardianRole(int? roleId, String? roleName) {
    final normalized = roleName?.toLowerCase();
    return roleId == 3 || normalized == 'contribuidor';
  }

  int? _intFrom(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  bool _boolFrom(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.toLowerCase();
      return normalized == 'true' || normalized == '1';
    }
    return false;
  }

  DateTime? _dateFrom(dynamic value) {
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  String? _errorFrom(Map<String, dynamic> data) {
    final message = data['message'] ?? data['error'];
    return message is String && message.isNotEmpty ? message : null;
  }

  String _friendlyError(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '');
    if (message.contains('Connection refused') ||
        message.contains('Failed host lookup') ||
        message.contains('Connection timed out')) {
      return 'No se pudo conectar con el backend local configurado.';
    }
    return message;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(apiClientProvider));
});
