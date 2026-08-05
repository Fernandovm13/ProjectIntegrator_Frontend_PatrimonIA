import '../repositories/notification_repository.dart';

class MarkAllReadUsecase {
  final NotificationRepository _repository;

  const MarkAllReadUsecase({required NotificationRepository repository})
      : _repository = repository;

  Future<void> call() {
    return _repository.markAllRead();
  }
}
