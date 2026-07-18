import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const sessionInactivityTimeout = Duration(minutes: 5);

abstract interface class SessionStorage {
  Future<void> saveSession({
    required String token,
    required DateTime lastActivityAt,
    required Duration timeout,
  });

  Future<void> saveLastActivity(DateTime lastActivityAt);

  Future<void> markExpired({
    required String token,
    required DateTime lastActivityAt,
    required DateTime expiredAt,
    required Duration timeout,
  });

  Future<void> clear();
}

class SecureSessionStorage implements SessionStorage {
  SecureSessionStorage({FlutterSecureStorage? storage})
    : _storage =
          storage ?? const FlutterSecureStorage(aOptions: AndroidOptions());

  static const tokenKey = 'session_token';
  static const lastActivityKey = 'session_last_activity_at';
  static const timeoutMinutesKey = 'session_timeout_minutes';
  static const expiredAtKey = 'session_expired_at';

  final FlutterSecureStorage _storage;

  @override
  Future<void> saveSession({
    required String token,
    required DateTime lastActivityAt,
    required Duration timeout,
  }) async {
    await _writeSafely(tokenKey, token);
    await _writeSafely(lastActivityKey, lastActivityAt.toIso8601String());
    await _writeSafely(timeoutMinutesKey, timeout.inMinutes.toString());
    await _deleteSafely(expiredAtKey);
  }

  @override
  Future<void> saveLastActivity(DateTime lastActivityAt) {
    return _writeSafely(lastActivityKey, lastActivityAt.toIso8601String());
  }

  @override
  Future<void> markExpired({
    required String token,
    required DateTime lastActivityAt,
    required DateTime expiredAt,
    required Duration timeout,
  }) async {
    await _writeSafely(tokenKey, token);
    await _writeSafely(lastActivityKey, lastActivityAt.toIso8601String());
    await _writeSafely(expiredAtKey, expiredAt.toIso8601String());
    await _writeSafely(timeoutMinutesKey, timeout.inMinutes.toString());
  }

  @override
  Future<void> clear() async {
    try {
      await Future.wait([
        _storage.delete(key: tokenKey),
        _storage.delete(key: lastActivityKey),
        _storage.delete(key: timeoutMinutesKey),
        _storage.delete(key: expiredAtKey),
      ]);
    } on MissingPluginException {
      // Secure storage is unavailable in widget tests and unsupported targets.
    }
  }

  Future<void> _writeSafely(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } on MissingPluginException {
      // Secure storage is unavailable in widget tests and unsupported targets.
    }
  }

  Future<void> _deleteSafely(String key) async {
    try {
      await _storage.delete(key: key);
    } on MissingPluginException {
      // Secure storage is unavailable in widget tests and unsupported targets.
    }
  }
}
