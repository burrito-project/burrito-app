import 'package:burrito/data/entities/burrito_status.dart';
import 'package:burrito/data/entities/last_stop_info.dart';
import 'package:burrito/data/entities/positions_response.dart';
import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'http://elenadb.live:6969',
    connectTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);

class BurritoState {
  final List<BurritoInfoInTime> inTime;
  final LastStopInfo? lastStop;

  BurritoState({
    required this.inTime,
    required this.lastStop,
  });

  BurritoInfoInTime get lastInfo => inTime.first;
  bool get isBurritoVisible =>
      lastInfo.status == ServiceStatus.working ||
      lastInfo.status == ServiceStatus.accident;
}

Future<BurritoState> getInfoAcrossTime() async {
  final response = await dio.get('/status');
  final burritoInfo = response.data['positions'] as List<dynamic>;
  final lastStopInfo = response.data['last_stop'];

  return BurritoState(
    inTime: burritoInfo.map((e) => BurritoInfoInTime.fromJson(e)).toList(),
    lastStop: lastStopInfo != null ? LastStopInfo.fromJson(lastStopInfo) : null,
  );
}
