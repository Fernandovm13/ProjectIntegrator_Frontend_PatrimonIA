import '../models/notification_item.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUsecase {
  final NotificationRepository _repository;

  const GetNotificationsUsecase({required NotificationRepository repository})
      : _repository = repository;

  Future<List<NotificationItem>> call() {
    return _repository.getNotifications();
  }
}
