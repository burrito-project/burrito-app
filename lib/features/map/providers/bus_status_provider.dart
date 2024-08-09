import 'dart:async';
import 'dart:developer';
import 'package:burrito/features/map/providers/follow_burrito_provider.dart';
import 'package:burrito/features/map/providers/map_controller_provider.dart';
import 'package:burrito/services/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final busStatusProvider = StreamProvider<BurritoState>((ref) async* {
  final stream = Stream.periodic(const Duration(seconds: 1), (i) => i)
      .asyncMap<BurritoState?>((_) async {
    try {
      final response = await getInfoAcrossTime();
      return response;
    } catch (e, st) {
      // ignore: avoid_print
      print('🫏 Error fetching burrito: $e\n$st');
      log('Error fetching burrito info', error: e, stackTrace: st);
      return null;
    }
  });

  await for (final state in stream) {
    if (state != null) {
      final mapController = ref.read(mapControllerProvider);
      final followingBurrito = ref.read(followBurritoProvider);

      if (followingBurrito) {
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
