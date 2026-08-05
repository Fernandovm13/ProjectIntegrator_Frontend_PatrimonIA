import 'dart:convert';

import 'package:http/http.dart' as http;

import '../storage/token_storage.dart';

class ApiClient {
  final String baseUrl;
  final TokenStorage tokenStorage;

  ApiClient({required this.baseUrl, required this.tokenStorage});

  Future<Map<String, dynamic>> request({
    required String query,
    Map<String, dynamic>? variables,
    bool requiresAuth = false,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (requiresAuth) {
      final token = await tokenStorage.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    final body = jsonEncode({
      'query': query,
      if (variables != null) 'variables': variables,
    });

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode != 200) {
      final message =
          _tryExtractErrorMessage(response.body) ??
          'Error HTTP ${response.statusCode}';
      throw ApiException(message);
    }

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException('Respuesta inválida del servidor');
    }

    if (decoded.containsKey('errors')) {
      final errors = decoded['errors'] as List;
      final message = errors.isNotEmpty
          ? errors.first['message'] as String? ?? 'Error desconocido'
          : 'Error desconocido';
      throw ApiException(message);
    }

    final data = decoded['data'];
    if (data == null) {
      throw ApiException('No se recibieron datos del servidor');
    }

    return data as Map<String, dynamic>;
  }

  String? _tryExtractErrorMessage(String body) {
    try {
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      if (decoded.containsKey('error')) {
        return decoded['error'] as String?;
      }
      if (decoded.containsKey('errors')) {
        final errors = decoded['errors'] as List?;
        if (errors != null && errors.isNotEmpty) {
          return errors.first['message'] as String?;
        }
      }
    } catch (_) {}
    return null;
  }
}

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}
