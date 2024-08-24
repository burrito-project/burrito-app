import 'package:burrito/features/core/fingerprint.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'package:dio/dio.dart';
import 'package:burrito/features/notifications/entities/notification_ad.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:burrito/data/entities/burrito_status.dart';
import 'package:burrito/data/entities/last_stop_info.dart';
import 'package:burrito/data/entities/positions_response.dart';
import 'package:burrito/features/app_updates/entities/pending_updates_response.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'https://api.contigosanmarcos.com',
    // baseUrl: 'http://192.168.1.86:6969',
    connectTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);

class BurritoState {
  final List<BurritoInfoInTime> records;
  final LastStopInfo? lastStop;

  BurritoState({
    required this.records,
    required this.lastStop,
  });

  /// The newer bus state. Equivalent to state.records.first.
  /// lastInfo is guaranteed to exists in server response
  BurritoInfoInTime get lastInfo => records.first;

  bool get isBurritoVisible =>
      lastInfo.status == BusServiceStatus.working ||
      lastInfo.status == BusServiceStatus.accident;
}

Future<BurritoState> getInfoAcrossTime() async {
  final response = await dio.get('/status');
  final burritoInfo = response.data['positions'] as List<dynamic>;
  final lastStopInfo = response.data['last_stop'];

  return BurritoState(
    records: burritoInfo.map((e) => BurritoInfoInTime.fromJson(e)).toList(),
    lastStop: lastStopInfo != null ? LastStopInfo.fromJson(lastStopInfo) : null,
  );
}

final kPackageInfo = PackageInfo.fromPlatform();

Future<PendingUpdatesResponse> getPendingUpdates() async {
  final info = await kPackageInfo;

  // NOTE: don't ever change this code until iOS is supported
  final response = await dio.get('/pending_updates', queryParameters: {
    'version': info.version,
    'platform': Platform.isAndroid ? 'android' : 'ios',
  });
  return PendingUpdatesResponse.fromJson(response.data);
}

Future<List<NotificationAd>> getNotifications() async {
  final response = await dio.get('/notifications');
  return (response.data as List<dynamic>)
      .map((e) => NotificationAd.fromJson(e))
      .toList();
}

Future<void> registerSession() async {
  final info = await kPackageInfo;

  try {
    await dio.post('/session', data: {
      'fingerprint': UserFingerprint.get(),
      'last_version': info.version,
      'platform': kIsWeb
          ? 'web'
          : Platform.isAndroid
              ? 'android'
              : 'ios',
    });
  } catch (e, st) {
    debugPrint('Error registering session: $e\n$st');
  }
}
