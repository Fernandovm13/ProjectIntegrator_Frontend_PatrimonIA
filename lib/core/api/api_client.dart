import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';

final apiConfigProvider = Provider<ApiConfig>((ref) => const ApiConfig());

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    config: ref.watch(apiConfigProvider),
    client: ref.watch(httpClientProvider),
  );
});

class ApiResponse {
  final int statusCode;
  final dynamic data;

  const ApiResponse({required this.statusCode, required this.data});

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

class ApiClient {
  final ApiConfig config;
  final http.Client client;

  const ApiClient({required this.config, required this.client});

  Future<ApiResponse> get(
    String path, {
    String? token,
    Map<String, String?> queryParameters = const {},
  }) {
    return _send('GET', path, token: token, queryParameters: queryParameters);
  }

  Future<ApiResponse> post(String path, {String? token, Object? body}) {
    return _send('POST', path, token: token, body: body);
  }

  Future<ApiResponse> patch(String path, {String? token, Object? body}) {
    return _send('PATCH', path, token: token, body: body);
  }

  Future<ApiResponse> delete(String path, {String? token}) {
    return _send('DELETE', path, token: token);
  }

  Future<ApiResponse> _send(
    String method,
    String path, {
    String? token,
    Object? body,
    Map<String, String?> queryParameters = const {},
  }) async {
    final uri = _uri(path, queryParameters);
    final headers = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    final response = switch (method) {
      'GET' => await client.get(uri, headers: headers),
      'POST' => await client.post(uri, headers: headers, body: _encoded(body)),
      'PATCH' => await client.patch(
        uri,
        headers: headers,
        body: _encoded(body),
      ),
      'DELETE' => await client.delete(uri, headers: headers),
      _ => throw ArgumentError('Unsupported HTTP method: $method'),
    };

    return ApiResponse(
      statusCode: response.statusCode,
      data: _decode(response.body),
    );
  }

  Uri _uri(String path, Map<String, String?> queryParameters) {
    final cleanBaseUrl = config.baseUrl.endsWith('/')
        ? config.baseUrl.substring(0, config.baseUrl.length - 1)
        : config.baseUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('$cleanBaseUrl$cleanPath');
    final query = <String, String>{};
    for (final entry in queryParameters.entries) {
      final value = entry.value;
      if (value != null && value.isNotEmpty) {
        query[entry.key] = value;
      }
    }
    return query.isEmpty ? uri : uri.replace(queryParameters: query);
  }

  String? _encoded(Object? body) {
    if (body == null) return null;
    return jsonEncode(body);
  }

  dynamic _decode(String body) {
    if (body.isEmpty) return {};
    return jsonDecode(body);
  }
}
