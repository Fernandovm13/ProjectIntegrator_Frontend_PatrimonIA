import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final String title;
  final String time;
  final IconData icon;
  final Color dotColor;
  final bool isUnread;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.time,
    required this.icon,
    required this.dotColor,
    this.isUnread = true,
  });
}
