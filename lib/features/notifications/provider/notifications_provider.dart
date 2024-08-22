import 'dart:async';

import 'package:burrito/features/map/providers/bottomsheet_provider.dart';
import 'package:burrito/services/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:burrito/features/notifications/entities/notification_ad.dart';
import 'package:localstorage/localstorage.dart';

const kSeenNotificationsStorageKey = 'seen_notifications';

final unseenNotificationsProvider = StateProvider<int>((ref) => 0);

final notificationsProvider = StateNotifierProvider<NotificationsStateNotifier,
    AsyncValue<List<NotificationAd>>>((ref) {
  return NotificationsStateNotifier(ref);
});

class NotificationsStateNotifier
    extends StateNotifier<AsyncValue<List<NotificationAd>>> {
  Ref ref;

  NotificationsStateNotifier(this.ref) : super(const AsyncValue.loading()) {
    _fetchNotifications();
    final t = Timer.periodic(const Duration(seconds: 30), _fetchNotifications);

    ref.listen(isBottomSheetExpandedProvider, (prev, opened) {
      if (opened) {
        triggerOpenNotificationsFeed();
      }
    });
    ref.onDispose(t.cancel);
  }

  void _fetchNotifications([_]) async {
    try {
      final notifications = await getNotifications();
      final seenIds = getSawIds();

      final seenCount = notifications.fold(
        0,
        (prev, val) => prev + (seenIds.contains(val.id) ? 1 : 0),
      );

      ref.read(unseenNotificationsProvider.notifier).state =
          notifications.length - seenCount;

      state = AsyncValue.data(
        notifications.map((n) => n.withSeen(seenIds.contains(n.id))).toList(),
      );
    } catch (e, st) {
      debugPrint('Error fetching notifications: $e\n$st');
      return;
    }
  }

  Set<int> getSawIds() {
    final seen = localStorage.getItem(kSeenNotificationsStorageKey) ?? '';
    return seen
        .split(',')
        .map((e) => int.tryParse(e))
        .where((r) => r != null)
        .map((e) => e!)
        .toSet();
  }

  void triggerOpenNotificationsFeed() {
    if (state.hasValue) {
      final seenIds = getSawIds();
      seenIds.addAll(state.valueOrNull!.map((n) => n.id));
      localStorage.setItem(kSeenNotificationsStorageKey, seenIds.join(','));
      // set seenNotificationsProvider to zero
      ref.read(unseenNotificationsProvider.notifier).state = 0;
    }
  }
}
