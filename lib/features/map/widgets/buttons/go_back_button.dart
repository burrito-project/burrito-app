import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:burrito/features/map/config.dart';
import 'package:burrito/features/map/widgets/overlay_map_button.dart';
import 'package:burrito/features/map/providers/map_controller_provider.dart';
import 'package:burrito/features/map/providers/center_coords_provider.dart';

class GoBackMapButton extends ConsumerWidget {
  const GoBackMapButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenCenterLatLng = ref.watch(centerCoordsProvider);
    final mapController = ref.watch(mapControllerProvider);

    final userOnBounds = screenCenterLatLng == null
        ? true
        : unmsmSafeBounds.contains(screenCenterLatLng);

    if (userOnBounds) {
      return const SizedBox.shrink();
    }

    return OverlayMapButton(
      semanticLabel: 'Volver a la UNMSM',
      buttonActive: false,
      icon: Icons.keyboard_return_rounded,
      onTap: () {
        mapController?.animateCamera(
          CameraUpdate.newLatLng(initialPos.target),
        );
      },
    );
  }
}
