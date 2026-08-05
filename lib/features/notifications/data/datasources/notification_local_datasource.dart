import 'package:flutter/material.dart';

import '../../domain/models/notification_item.dart';

abstract class NotificationLocalDataSource {
  Future<List<NotificationItem>> getNotifications();

  Future<void> addNotification(NotificationItem notification);
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  const NotificationLocalDataSourceImpl();

  @override
  Future<List<NotificationItem>> getNotifications() async => [
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

  @override
  Future<void> addNotification(NotificationItem notification) async {}
}
