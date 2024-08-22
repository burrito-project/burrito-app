import 'dart:async';

import 'package:burrito/features/notifications/entities/notification_ad.dart';
import 'package:burrito/services/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationsProvider = FutureProvider<List<NotificationAd>>((ref) async {
  Timer.periodic(const Duration(seconds: 30), (timer) {
    ref.invalidateSelf();
  });

  return getNotifications();
});
