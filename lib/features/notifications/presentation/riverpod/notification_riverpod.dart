import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/notifications_di.dart';
import '../../domain/models/notification_item.dart';
import '../../domain/usecases/add_notification_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_all_read_usecase.dart';

final _getNotificationsUsecaseProvider = Provider<GetNotificationsUsecase>((ref) {
  return ref.watch(notificationDIProvider).getNotificationsUsecase;
});

final _addNotificationUsecaseProvider = Provider<AddNotificationUsecase>((ref) {
  return ref.watch(notificationDIProvider).addNotificationUsecase;
});

final _markAllReadUsecaseProvider = Provider<MarkAllReadUsecase>((ref) {
  return ref.watch(notificationDIProvider).markAllReadUsecase;
});

class NotificationState {
  final List<NotificationItem> notifications;

  const NotificationState({this.notifications = const []});

  NotificationState copyWith({List<NotificationItem>? notifications}) {
    return NotificationState(notifications: notifications ?? this.notifications);
  }
}

class NotificationNotifier extends AsyncNotifier<NotificationState> {
  @override
  Future<NotificationState> build() async {
    final notifications = await ref.read(_getNotificationsUsecaseProvider)();
    return NotificationState(notifications: notifications);
  }

  Future<void> addNotification(NotificationItem item) async {
    await ref.read(_addNotificationUsecaseProvider)(item);
    state = AsyncValue.data(
      state.requireValue.copyWith(
        notifications: [item, ...state.requireValue.notifications],
      ),
    );
  }

  Future<void> markAllRead() async {
    await ref.read(_markAllReadUsecaseProvider)();
    final updated = state.requireValue.notifications
        .map(
          (n) => NotificationItem(
            id: n.id,
            title: n.title,
            time: n.time,
            icon: n.icon,
            dotColor: n.dotColor,
            isUnread: false,
          ),
        )
        .toList();
    state = AsyncValue.data(state.requireValue.copyWith(notifications: updated));
  }
}

final notificationProvider =
    AsyncNotifierProvider<NotificationNotifier, NotificationState>(
      NotificationNotifier.new,
    );

final unreadCountProvider = Provider<int>((ref) {
  return ref
          .watch(notificationProvider)
          .asData
          ?.value
          .notifications
          .where((n) => n.isUnread)
          .length ??
      0;
});
