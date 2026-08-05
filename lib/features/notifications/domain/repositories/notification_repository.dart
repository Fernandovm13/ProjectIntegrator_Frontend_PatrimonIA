import '../models/notification_item.dart';

abstract class NotificationRepository {
  Future<List<NotificationItem>> getNotifications();

  Future<void> addNotification(NotificationItem notification);

  Future<void> markAllRead();
}
