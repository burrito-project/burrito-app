import 'package:burrito/data/entities/burrito_status.dart';
import 'package:burrito/data/entities/last_stop_info.dart';
import 'package:burrito/data/entities/positions_response.dart';
import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'https://elenadb.live',
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
