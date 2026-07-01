import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/notification_item.dart';

List<NotificationItem> _seedNotifications() {
  return [
    const NotificationItem(
      id: '1',
      title: 'Nueva memoria agregada en tu comunidad',
      time: 'Hace 2h',
      icon: Icons.auto_stories,
      dotColor: Colors.blueAccent,
      isUnread: true,
    ),
    const NotificationItem(
      id: '2',
      title: 'El Narrador tiene nuevas historias para ti',
      time: 'Hace 5h',
      icon: Icons.chat_bubble_outline,
      dotColor: Color(0xFFE8940A),
      isUnread: true,
    ),
    const NotificationItem(
      id: '3',
      title: 'Tu testimonio fue aprobado al corpus',
      time: 'Ayer',
      icon: Icons.verified_user_outlined,
      dotColor: Color(0xFF1A5C3A),
      isUnread: false,
    ),
  ];
}

class NotificationNotifier extends StateNotifier<List<NotificationItem>> {
  NotificationNotifier() : super(_seedNotifications());

  void addNotification(NotificationItem item) {
    state = [item, ...state];
  }

  void markAllRead() {
    state = state.map((n) => NotificationItem(
      id: n.id,
      title: n.title,
      time: n.time,
      icon: n.icon,
      dotColor: n.dotColor,
      isUnread: false,
    )).toList();
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, List<NotificationItem>>((ref) {
  return NotificationNotifier();
});

final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).where((n) => n.isUnread).length;
});
