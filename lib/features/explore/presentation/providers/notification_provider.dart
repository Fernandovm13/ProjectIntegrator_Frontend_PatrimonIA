import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/models/notification_item.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class NotificationNotifier extends StateNotifier<List<NotificationItem>> {
  NotificationNotifier(this._ref, this._apiClient) : super(const []);

  final Ref _ref;
  final ApiClient _apiClient;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadNotifications() async {
    final token = _ref.read(authProvider).token;
    if (token == null) {
      state = const [];
      return;
    }

    isLoading = true;
    errorMessage = null;

    try {
      final response = await _apiClient.get('/notifications', token: token);
      if (!response.isSuccess) {
        throw Exception(
          _errorFrom(response.data) ??
              'No se pudieron cargar las notificaciones.',
        );
      }

      state = _extractList(response.data).map(_notificationFromJson).toList();
    } catch (error) {
      state = const [];
      errorMessage = _friendlyError(error);
    } finally {
      isLoading = false;
    }
  }

  void addNotification(NotificationItem item) {
    state = [item, ...state];
  }

  void markAllRead() {
    state = state.map((n) {
      return NotificationItem(
        id: n.id,
        title: n.title,
        time: n.time,
        icon: n.icon,
        dotColor: n.dotColor,
        isUnread: false,
      );
    }).toList();
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final candidates = [data['notifications'], data['data'], data['items']];
      for (final candidate in candidates) {
        if (candidate is List) return candidate;
      }
    }
    return [];
  }

  NotificationItem _notificationFromJson(dynamic raw) {
    final json = raw is Map<String, dynamic> ? raw : <String, dynamic>{};
    final type = json['type'] is String ? json['type'] as String : 'story';
    return NotificationItem(
      id: '${json['id'] ?? DateTime.now().microsecondsSinceEpoch}',
      title: _titleFrom(json),
      time: _relativeTime(json['created_at'] ?? json['createdAt']),
      icon: type == 'event'
          ? Icons.event_available_outlined
          : Icons.auto_stories,
      dotColor: type == 'event'
          ? const Color(0xFFE8940A)
          : const Color(0xFF1A5C3A),
      isUnread: true,
    );
  }

  String _titleFrom(Map<String, dynamic> json) {
    final title = json['title'];
    final message = json['message'];
    if (title is String && message is String && message.isNotEmpty) {
      return '$title: $message';
    }
    if (title is String && title.isNotEmpty) return title;
    if (message is String && message.isNotEmpty) return message;
    return 'Nueva notificacion';
  }

  String _relativeTime(dynamic value) {
    final date = value is String ? DateTime.tryParse(value) : null;
    if (date == null) return 'Reciente';
    final diff = DateTime.now().difference(date.toLocal());
    if (diff.inMinutes < 1) return 'Ahora';
    if (diff.inHours < 1) return 'Hace ${diff.inMinutes} min';
    if (diff.inDays < 1) return 'Hace ${diff.inHours}h';
    if (diff.inDays == 1) return 'Ayer';
    return 'Hace ${diff.inDays} dias';
  }

  String? _errorFrom(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
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

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, List<NotificationItem>>((ref) {
      final notifier = NotificationNotifier(ref, ref.watch(apiClientProvider));
      if (ref.read(authProvider).token != null) {
        Future.microtask(notifier.loadNotifications);
      }
      ref.listen<AuthState>(authProvider, (previous, next) {
        if (previous?.token != next.token) {
          notifier.loadNotifications();
        }
      });
      return notifier;
    });

final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).where((n) => n.isUnread).length;
});
