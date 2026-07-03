import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../core/models/user.dart';

const _apiBaseUrl = 'http://10.0.2.2:8080/api';

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
  AuthNotifier() : super(const AuthState());

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await http.post(
        Uri.parse('$_apiBaseUrl/auth/login'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = _decodeResponse(response.body);
      if (response.statusCode != 200) {
        throw Exception(_errorFrom(data) ?? 'No se pudo iniciar sesion.');
      }

      final token = data['token'] as String?;
      if (token == null || token.isEmpty) {
        throw Exception('El servidor no devolvio un token.');
      }

      state = state.copyWith(
        isAuthenticated: true,
        user: AppUser(email: email, role: 'Explorador'),
        isGuardian: false,
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
      final response = await http.post(
        Uri.parse('$_apiBaseUrl/auth/register'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': name,
          'email': email,
          'password': password,
          'role_id': roleId,
          'is_premium': false,
        }),
      );

      final data = _decodeResponse(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(_errorFrom(data) ?? 'No se pudo crear la cuenta.');
      }

      state = state.copyWith(
        isAuthenticated: true,
        user: AppUser(
          name: name,
          email: email,
          role: role == 'guardian' ? 'Guardian' : 'Explorador',
        ),
        isGuardian: role == 'guardian',
        token: data['token'] as String?,
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

  void loginAnonymously() {
    state = state.copyWith(
      isAuthenticated: true,
      user: const AppUser(
        email: 'anonimo@patrimonia.app',
        role: 'Explorador',
      ),
      isGuardian: false,
      isLoading: false,
      clearError: true,
    );
  }

  void updateUser(AppUser user) {
    state = state.copyWith(user: user);
  }

  void logout() {
    state = const AuthState();
  }

  Map<String, dynamic> _decodeResponse(String body) {
    if (body.isEmpty) return {};

    final decoded = jsonDecode(body);
    return decoded is Map<String, dynamic> ? decoded : {};
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
      return 'No se pudo conectar con el backend local en 10.0.2.2:8080.';
    }
    return message;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
