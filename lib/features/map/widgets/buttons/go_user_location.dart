import 'package:burrito/features/core/alerts/simple_dialog.dart';
import 'package:burrito/features/map/providers/map_restart_key_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:burrito/features/map/widgets/overlay_map_button.dart';
import 'package:burrito/features/map/providers/bus_status_provider.dart';
import 'package:burrito/features/map/providers/map_controller_provider.dart';
import 'package:burrito/features/map/providers/follow_burrito_provider.dart';

class GoUserLocationMapButton extends ConsumerWidget {
  const GoUserLocationMapButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final burritoState = ref.watch(busStatusProvider);
    final mapController = ref.watch(mapControllerProvider);

    bool shouldBePushedUp = false;

    if (burritoState.hasValue &&
        (!burritoState.hasValue || burritoState.value!.isBurritoVisible)) {
      shouldBePushedUp = true;
    }

    return FutureBuilder(
      future: isLocationEnabled(),
      builder: (context, snapshot) {
        LocationStatus locationStatus = LocationStatus.noPermission();

        if (snapshot.hasData) {
          locationStatus = snapshot.data as LocationStatus;
        }

        bool locationDisabled = locationStatus.isEnabled == false;

        return Column(
          children: [
            OverlayMapButton(
              semanticLabel: 'Ir a ubicación en el mapa',
              colorActive: false,
              icon: locationDisabled
                  ? Icons.location_disabled
                  : Icons.location_searching,
              onTap: () async {
                if (!locationStatus.enabled) {
                  final enabled = await loc.Location().requestService();
                  if (!enabled) return;
                }

                if (!locationStatus.granted) {
                  final permission = await Geolocator.requestPermission();
                  locationStatus.updateFrom(permission);

                  if (locationStatus.granted) {
                    // We need to reload the map to start streaming the position
                    reloadMap(ref);
                  }
                }

                if (locationStatus.deniedForever) {
                  if (!context.mounted) return;
                  // NOTE: work better on this
                  await showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return SimpleAppDialog(
                        title: 'Necesitamos permisos',
                        content:
                            'Activa los permisos de ubicación en Permisos > Ubicación.',
                        showAcceptButton: true,
                        onAccept: () async {
                          // Open app settings
                          await Geolocator.openAppSettings();
                        },
                      );
                    },
                  );
                  return;
                }

                try {
                  final userLocation = await Geolocator.getCurrentPosition(
                    locationSettings: const LocationSettings(
                      accuracy: LocationAccuracy.high,
                    ),
                  );

                  ref.read(followBurritoProvider.notifier).state = false;
                  mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      LatLng(
                        userLocation.latitude,
                        userLocation.longitude,
                      ),
                      17,
                    ),
                  );
                } catch (e, st) {
                  debugPrint('Error obtaining user location: $e\n$st');
                  return;
                }
              },
            ),
            if (shouldBePushedUp) ...[
              const SizedBox(height: 64),
            ],
          ],
        );
      },
    );
  }
}

class LocationStatus {
  bool enabled;
  bool granted;
  bool deniedForever;

  LocationStatus({
    required this.enabled,
    required this.granted,
    required this.deniedForever,
  });

  bool get isEnabled => enabled && granted;

  factory LocationStatus.noPermission() {
    return LocationStatus(
      enabled: false,
      granted: false,
      deniedForever: false,
    );
  }

  void updateFrom(LocationPermission locationPermission) {
    granted = locationPermission == LocationPermission.always ||
        locationPermission == LocationPermission.whileInUse;
    deniedForever = locationPermission == LocationPermission.deniedForever;
  }
}

Future<LocationStatus> isLocationEnabled() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  final permission = await Geolocator.checkPermission();

  bool permissionGranted = permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse;

  return LocationStatus(
    enabled: serviceEnabled,
    granted: permissionGranted,
    deniedForever: permission == LocationPermission.deniedForever,
  );
}
