import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:patrimonia/core/api/api_client.dart';
import 'package:patrimonia/core/api/api_config.dart';
import 'package:patrimonia/core/security/inactivity_session_guard.dart';
import 'package:patrimonia/core/security/secure_session_storage.dart';
import 'package:patrimonia/features/auth/presentation/providers/auth_provider.dart';

void main() {
  testWidgets('reinicia el timer y cierra la sesión al quedar inactiva', (
    tester,
  ) async {
    final storage = _MemorySessionStorage();
    final notifier = AuthNotifier(
      ApiClient(
        config: const ApiConfig(baseUrl: 'http://localhost/api'),
        client: MockClient((request) async {
          if (request.url.path.endsWith('/auth/login')) {
            return _json({'token': 'token-seguro'});
          }
          return _json({
            'id': 1,
            'username': 'Usuario',
            'email': 'usuario@patrimonia.app',
            'role_id': 2,
          });
        }),
      ),
      storage,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => notifier),
          sessionStorageProvider.overrideWithValue(storage),
        ],
        child: InactivitySessionGuard(
          timeout: const Duration(seconds: 1),
          child: MaterialApp(
            home: Scaffold(
              body: TextButton(
                onPressed: () {},
                child: const Text('Interactuar'),
              ),
            ),
          ),
        ),
      ),
    );

    await notifier.login(email: 'usuario@patrimonia.app', password: 'password');
    await tester.pump();

    await tester.pump(const Duration(milliseconds: 800));
    await tester.tap(find.text('Interactuar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    expect(notifier.state.isAuthenticated, true);

    await tester.pump(const Duration(milliseconds: 201));
    await tester.pump();

    expect(notifier.state.isAuthenticated, false);
    expect(notifier.state.errorMessage, contains('inactividad'));
    expect(storage.token, 'token-seguro');
    expect(storage.expiredAt, isNotNull);
  });
}

class _MemorySessionStorage implements SessionStorage {
  String? token;
  DateTime? lastActivityAt;
  DateTime? expiredAt;

  @override
  Future<void> saveSession({
    required String token,
    required DateTime lastActivityAt,
    required Duration timeout,
  }) async {
    this.token = token;
    this.lastActivityAt = lastActivityAt;
  }

  @override
  Future<void> saveLastActivity(DateTime lastActivityAt) async {
    this.lastActivityAt = lastActivityAt;
  }

  @override
  Future<void> markExpired({
    required String token,
    required DateTime lastActivityAt,
    required DateTime expiredAt,
    required Duration timeout,
  }) async {
    this.token = token;
    this.lastActivityAt = lastActivityAt;
    this.expiredAt = expiredAt;
  }

  @override
  Future<void> clear() async {
    token = null;
    lastActivityAt = null;
    expiredAt = null;
  }
}

http.Response _json(Object body) {
  return http.Response(
    jsonEncode(body),
    200,
    headers: {'Content-Type': 'application/json'},
  );
}
