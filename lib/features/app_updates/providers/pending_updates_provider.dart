import 'package:burrito/services/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:burrito/features/app_updates/entities/pending_updates_response.dart';

final pendingUpdatesProvider =
    FutureProvider<PendingUpdatesResponse>((ref) async {
  final response = await getPendingUpdates();
  return response;
});
