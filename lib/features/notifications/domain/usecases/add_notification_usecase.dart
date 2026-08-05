import '../models/notification_item.dart';
import '../repositories/notification_repository.dart';

class AddNotificationUsecase {
  final NotificationRepository _repository;

  const AddNotificationUsecase({
    required NotificationRepository repository,
  }) : _repository = repository;

  Future<void> call(NotificationItem notification) {
    return _repository.addNotification(notification);
  }
}
