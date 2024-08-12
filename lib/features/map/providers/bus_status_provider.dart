import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:burrito/services/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:burrito/features/map/providers/follow_burrito_provider.dart';
import 'package:burrito/features/map/providers/map_controller_provider.dart';

/// Sames as Stream.periodic but fires immediately
Stream<T> periodic<T>(Duration period, T Function(int) cb) async* {
  yield cb(0);
  yield* Stream.periodic(period, (i) => cb(i + 1));
}

final busStatusProvider = StreamProvider<BurritoState>((ref) async* {
  final stream = periodic(const Duration(seconds: 1), (i) => i)
      .asyncMap<BurritoState?>((_) async {
    try {
      final response = await getInfoAcrossTime();
      return response;
    } catch (e, st) {
      debugPrint('🫏 Error fetching burrito: $e\n$st');
      log('Error fetching burrito info', error: e, stackTrace: st);
      return null;
    } finally {
      FlutterNativeSplash.remove();
    }
  });

  await for (final state in stream) {
    if (state != null) {
      final mapController = ref.read(mapControllerProvider);
      final followingBurrito = ref.read(followBurritoProvider);

      if (followingBurrito && state.isBurritoVisible) {
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(
              state.lastInfo.pos.latitude,
              state.lastInfo.pos.longitude,
            ),
            17,
          ),
        );
      }

      yield state;
    }
  }
});
