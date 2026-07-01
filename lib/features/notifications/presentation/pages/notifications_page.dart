import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/theme_colors_extension.dart';
import '../../../../core/models/notification_item.dart';
import '../../../explore/presentation/providers/notification_provider.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);

    final grouped = <String, List<NotificationItem>>{};
    for (final n in notifications) {
      final section = n.time == 'Hace 2h' || n.time == 'Hace 5h' ? 'Hoy' : 'Esta semana';
      grouped.putIfAbsent(section, () => []).add(n);
    }

    return Scaffold(
      backgroundColor: context.surface,
      appBar: AppBar(
        backgroundColor: context.appBarBg,
        elevation: 0,
        leading: Icon(
          Icons.arrow_back,
          color: context.textPrimary,
        ),
        title: Text(
          'Notificaciones',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: context.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => ref.read(notificationProvider.notifier).markAllRead(),
            child: Text(
              'Mark all read',
              style: TextStyle(
                color: context.sacredJade,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          for (final entry in grouped.entries) ...[
            _buildSectionHeader(context, entry.key),
            for (final notification in entry.value)
              _buildNotificationItem(
                context,
                icon: notification.icon,
                title: notification.title,
                time: notification.time,
                dotColor: notification.dotColor,
                isUnread: notification.isUnread,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: context.textSecondary,
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String time,
    required Color dotColor,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(12),
        border: isUnread
            ? Border.all(color: dotColor.withValues(alpha: 0.5), width: 1)
            : null,
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: dotColor),
          const SizedBox(width: 12),
          Icon(icon, color: context.textPrimary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: context.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
