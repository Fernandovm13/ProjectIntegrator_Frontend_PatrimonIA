import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/app_container.dart';
import '../data/datasources/notification_local_datasource.dart';
import '../data/repositories/notification_repository_impl.dart';
import '../domain/repositories/notification_repository.dart';
import '../domain/usecases/add_notification_usecase.dart';
import '../domain/usecases/get_notifications_usecase.dart';
import '../domain/usecases/mark_all_read_usecase.dart';

final notificationDIProvider = Provider<NotificationsDI>((ref) {
  final container = ref.watch(appContainerProvider);
  return NotificationsDI(container!);
});

class NotificationsDI {
  final AppContainer appContainer;

  late final NotificationLocalDataSource notificationLocalDataSource;
  late final NotificationRepository notificationRepository;
  late final GetNotificationsUsecase getNotificationsUsecase;
  late final AddNotificationUsecase addNotificationUsecase;
  late final MarkAllReadUsecase markAllReadUsecase;

  NotificationsDI(this.appContainer) {
    _init();
  }

  void _init() {
    notificationLocalDataSource = const NotificationLocalDataSourceImpl();

    notificationRepository = NotificationRepositoryImpl(
      localDataSource: notificationLocalDataSource,
    );

    getNotificationsUsecase = GetNotificationsUsecase(
      repository: notificationRepository,
    );
    addNotificationUsecase = AddNotificationUsecase(
      repository: notificationRepository,
    );
    markAllReadUsecase = MarkAllReadUsecase(
      repository: notificationRepository,
    );
  }
}
