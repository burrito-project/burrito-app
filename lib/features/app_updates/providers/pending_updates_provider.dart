import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:burrito/services/dio_client.dart';
import 'package:burrito/features/app_updates/entities/pending_updates_response.dart';

final pendingUpdatesProvider =
    FutureProvider<PendingUpdatesResponse>((ref) async {
  if (kIsWeb) return Future.value(PendingUpdatesResponse.empty());

  final t = Timer.periodic(const Duration(minutes: 1), (_) {
    ref.invalidateSelf();
  });

  ref.onDispose(t.cancel);
  return await getPendingUpdates();
});
