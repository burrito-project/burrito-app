import 'package:burrito/data/entities/burrito_status.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit show LatLng;

class BurritoInfoInTime {
  final LatLng pos;
  final BurritoStatus status;
  final DateTime timestamp;
  final double velocity;

  BurritoInfoInTime({
    required this.pos,
    required this.status,
    required this.timestamp,
    required this.velocity,
  });

  factory BurritoInfoInTime.fromJson(Map<String, dynamic> json) {
    return BurritoInfoInTime(
      pos: LatLng(json['lt'], json['lg']),
      status: BurritoStatus.fromInt(json['sts']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        json['timestamp']['secs_since_epoch'] * 1000 +
            json['timestamp']['nanos_since_epoch'] ~/ 1000000,
      ),
      velocity: json['velocity'],
    );
  }
}

extension XBurritoInfo on double {
  // 2 digits precision
  String get tempString => '${toStringAsFixed(2)}°';
  String get humidityString => '${toStringAsFixed(2)}%';
  String get kmphString => '${toStringAsFixed(2)} km/h';
}

extension XBurritoTimeInfo on DateTime {
  // In seconds, minutes, hours
  String get timeAgoString {
    final diff = DateTime.now().difference(this);
    if (diff.inSeconds < 60) {
      return '${diff.inSeconds} s';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} m';
    } else {
      return '${diff.inHours} h';
    }
  }
}

extension XLatLng on LatLng {
  maps_toolkit.LatLng get asTKLatLng =>
      maps_toolkit.LatLng(latitude, longitude);
}
