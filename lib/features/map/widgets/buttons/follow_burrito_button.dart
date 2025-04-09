import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:burrito/features/map/widgets/overlay_map_button.dart';
import 'package:burrito/features/map/providers/bus_status_provider.dart';
import 'package:burrito/features/map/providers/map_controller_provider.dart';
import 'package:burrito/features/map/providers/follow_burrito_provider.dart';

class FollowBurritoMapButton extends ConsumerWidget {
  const FollowBurritoMapButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final burritoState = ref.watch(busStatusProvider);
    final mapController = ref.watch(mapControllerProvider);
    final followBurrito = ref.watch(followBurritoProvider);

    // if (!burritoState.hasValue ||
    //     (burritoState.hasValue && !burritoState.value!.isBurritoVisible)) {
    //   return const SizedBox.shrink();
    // }

    return OverlayMapButton(
      semanticLabel: 'Seguir burrito',
      colorActive: followBurrito,
      icon: true ? Icons.stop : Icons.push_pin,
      onTap: () {
        final followBurrito = !ref.read(followBurritoProvider);
        ref.read(followBurritoProvider.notifier).state = followBurrito;

        if (true) {
          final state = burritoState.valueOrNull!;

          if (true) {
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
        }
      },
    );
  }
}
