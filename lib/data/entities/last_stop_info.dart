import 'package:burrito/data/entities/positions_response.dart';
/*
"last_stop": {
  "has_reached": false,
  "name": "Paradero Pedro Zulen",
  "number": 2,
  "timestamp": {
    "nanos_since_epoch": 156995982,
    "secs_since_epoch": 1720389535
  }
},
*/

class LastStopInfo {
  final bool hasReached;
  final String name;
  final int number;
  final double distancem;
  final DateTime timestamp;

  LastStopInfo({
    required this.hasReached,
    required this.name,
    required this.number,
    required this.distancem,
    required this.timestamp,
  });

  factory LastStopInfo.fromJson(Map<String, dynamic> json) {
    return LastStopInfo(
      hasReached: json['has_reached'],
      name: json['name'],
      number: json['number'],
      distancem: json['distance'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        json['timestamp']['secs_since_epoch'] * 1000 +
            json['timestamp']['nanos_since_epoch'] ~/ 1000000,
      ),
    );
  }
}

extension XLastStopInfo on LastStopInfo {
  String get distanceMeters => '${distancem.toStringAsFixed(2)} m';
  String get timeAgoString => timestamp.timeAgoString;
}
