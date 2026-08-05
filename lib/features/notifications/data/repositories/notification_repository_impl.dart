import '../../domain/models/notification_item.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource localDataSource;

  const NotificationRepositoryImpl({required this.localDataSource});

  @override
  Future<List<NotificationItem>> getNotifications() {
    return localDataSource.getNotifications();
  }

  @override
  Future<void> addNotification(NotificationItem notification) {
    return localDataSource.addNotification(notification);
  }

  @override
  Future<void> markAllRead() async {}
}
