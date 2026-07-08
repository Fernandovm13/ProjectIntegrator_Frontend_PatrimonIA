import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:patrimonia/core/api/api_client.dart';
import 'package:patrimonia/core/api/api_config.dart';
import 'package:patrimonia/features/auth/presentation/providers/auth_provider.dart';
import 'package:patrimonia/features/explore/presentation/providers/community_provider.dart';
import 'package:patrimonia/features/explore/presentation/providers/memory_provider.dart';
import 'package:patrimonia/features/explore/presentation/providers/notification_provider.dart';

void main() {
  const baseUrl = 'http://10.0.2.2:8080/api';

  test('default API base URL points to the Android emulator backend', () {
    expect(const ApiConfig().baseUrl, baseUrl);
  });

  test(
    'ApiClient builds requests for every backend endpoint under /api',
    () async {
      final requested = <String>[];
      final client = ApiClient(
        config: const ApiConfig(baseUrl: baseUrl),
        client: MockClient((request) async {
          requested.add('${request.method} ${request.url}');
          return http.Response('{}', request.method == 'DELETE' ? 204 : 200);
        }),
      );

      await client.post('/auth/register', body: {});
      await client.post('/auth/login', body: {});
      await client.get('/categories');
      await client.get('/communities');
      await client.get(
        '/topics/popular',
        queryParameters: {'community_id': '1', 'limit': '3'},
      );
      await client.get('/stories', queryParameters: {'status': 'approved'});
      await client.get('/stories/10');
      await client.get('/events');
      await client.get('/users/profile', token: 'token');
      await client.post('/stories', token: 'token', body: {});
      await client.get('/users/profile/favorites', token: 'token');
      await client.get('/users/profile/stories', token: 'token');
      await client.post('/stories/10/favorite', token: 'token');
      await client.post('/stories/10/read', token: 'token');
      await client.patch('/stories/10', token: 'token', body: {});
      await client.delete('/stories/10', token: 'token');
      await client.post('/stories/10/validate', token: 'token', body: {});
      await client.post('/events', token: 'token', body: {});
      await client.get('/notifications', token: 'token');

      expect(requested, contains('POST $baseUrl/auth/register'));
      expect(requested, contains('POST $baseUrl/auth/login'));
      expect(requested, contains('GET $baseUrl/categories'));
      expect(requested, contains('GET $baseUrl/communities'));
      expect(
        requested,
        contains('GET $baseUrl/topics/popular?community_id=1&limit=3'),
      );
      expect(requested, contains('GET $baseUrl/stories?status=approved'));
      expect(requested, contains('GET $baseUrl/stories/10'));
      expect(requested, contains('GET $baseUrl/events'));
      expect(requested, contains('GET $baseUrl/users/profile'));
      expect(requested, contains('POST $baseUrl/stories'));
      expect(requested, contains('GET $baseUrl/users/profile/favorites'));
      expect(requested, contains('GET $baseUrl/users/profile/stories'));
      expect(requested, contains('POST $baseUrl/stories/10/favorite'));
      expect(requested, contains('POST $baseUrl/stories/10/read'));
      expect(requested, contains('PATCH $baseUrl/stories/10'));
      expect(requested, contains('DELETE $baseUrl/stories/10'));
      expect(requested, contains('POST $baseUrl/stories/10/validate'));
      expect(requested, contains('POST $baseUrl/events'));
      expect(requested, contains('GET $baseUrl/notifications'));
    },
  );

  test('auth provider logs in and maps backend profile fields', () async {
    final container = _containerWithClient((request) async {
      if (request.url.path.endsWith('/auth/login')) {
        expect(jsonDecode(request.body), {
          'email': 'ana@patrimonia.app',
          'password': 'PatrimonIA123',
        });
        return _json({
          'token': 'jwt-token',
          'user': {
            'id': 7,
            'username': 'Ana Exploradora',
            'email': 'ana@patrimonia.app',
          },
        });
      }
      if (request.url.path.endsWith('/users/profile')) {
        expect(request.headers['Authorization'], 'Bearer jwt-token');
        return _json({
          'id': 7,
          'username': 'Ana Exploradora',
          'email': 'ana@patrimonia.app',
          'role_id': 2,
          'role_name': 'turista',
          'is_premium': false,
          'reputation_score': 2,
          'stories_saved': 2,
          'stories_read': 4,
          'stories_created': 0,
          'communities': 1,
        });
      }
      return http.Response('Not found', 404);
    });
    addTearDown(container.dispose);

    await container
        .read(authProvider.notifier)
        .login(email: 'ana@patrimonia.app', password: 'PatrimonIA123');

    final state = container.read(authProvider);
    expect(state.isAuthenticated, true);
    expect(state.token, 'jwt-token');
    expect(state.user?.name, 'Ana Exploradora');
    expect(state.user?.storiesSaved, 2);
    expect(state.isGuardian, false);
  });

  test(
    'memory provider loads public stories from backend response shape',
    () async {
      final container = _containerWithClient((request) async {
        expect(request.url.toString(), '$baseUrl/stories?status=approved');
        return _json([
          {
            'id': 10,
            'title': 'La memoria del rio',
            'content_text': 'Relato comunitario',
            'category_id': 1,
            'category': {'id': 1, 'name': 'Leyendas'},
            'community_id': 1,
            'community': {
              'id': 1,
              'name': 'Suchiapa',
              'location': 'Region Metropolitana',
            },
            'author': {'id': 2, 'username': 'Maria'},
            'favorites_count': 3,
            'isFavorite': true,
            'status': 'approved',
            'created_at': '2026-07-08T00:00:00.000Z',
          },
        ]);
      });
      addTearDown(container.dispose);

      await container
          .read(memoryProvider.notifier)
          .loadStories(status: 'approved');

      final memories = container.read(memoryProvider);
      expect(memories, hasLength(1));
      expect(memories.first.id, '10');
      expect(memories.first.category, 'Leyenda');
      expect(memories.first.community, 'Suchiapa');
      expect(memories.first.likes, 3);
      expect(memories.first.isFavorite, true);
    },
  );

  test(
    'community provider loads backend communities without seed data',
    () async {
      final container = _containerWithClient((request) async {
        expect(request.url.toString(), '$baseUrl/communities');
        return _json([
          {
            'id': 1,
            'name': 'Suchiapa',
            'location': 'Region Metropolitana',
            'memory_count': 4,
          },
        ]);
      });
      addTearDown(container.dispose);

      await container.read(communityProvider.notifier).loadCommunities();

      final state = container.read(communityProvider);
      expect(state.communities.single.name, 'Suchiapa');
      expect(state.selected?.name, 'Suchiapa');
      expect(state.communities.single.memoryCount, 4);
    },
  );

  test('notification provider uses protected notifications endpoint', () async {
    final container = _containerWithClient((request) async {
      if (request.url.path.endsWith('/auth/login')) {
        return _json({'token': 'jwt-token'});
      }
      if (request.url.path.endsWith('/users/profile')) {
        return _json({
          'id': 7,
          'username': 'Ana',
          'email': 'ana@patrimonia.app',
          'role_id': 2,
          'role_name': 'turista',
        });
      }
      if (request.url.path.endsWith('/notifications')) {
        expect(request.headers['Authorization'], 'Bearer jwt-token');
        return _json([
          {
            'id': 'story-10',
            'type': 'story',
            'title': 'Nueva memoria comunitaria',
            'message': 'La memoria del rio',
            'created_at': DateTime.now().toIso8601String(),
          },
        ]);
      }
      return _json([]);
    });
    addTearDown(container.dispose);

    await container
        .read(authProvider.notifier)
        .login(email: 'ana@patrimonia.app', password: 'PatrimonIA123');
    await container.read(notificationProvider.notifier).loadNotifications();

    final notifications = container.read(notificationProvider);
    expect(notifications.single.id, 'story-10');
    expect(notifications.single.title, contains('La memoria del rio'));
  });
}

ProviderContainer _containerWithClient(
  Future<http.Response> Function(http.Request) handler,
) {
  return ProviderContainer(
    overrides: [
      apiConfigProvider.overrideWithValue(
        const ApiConfig(baseUrl: 'http://10.0.2.2:8080/api'),
      ),
      httpClientProvider.overrideWithValue(MockClient(handler)),
    ],
  );
}

http.Response _json(Object body, {int status = 200}) {
  return http.Response(
    jsonEncode(body),
    status,
    headers: {'Content-Type': 'application/json'},
  );
}
