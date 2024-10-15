import 'package:burrito/features/map/providers/map_restart_key_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:burrito/data/geojson/unmsm.dart';
import 'package:burrito/features/map/config.dart';
import 'package:burrito/data/markers/bitmaps.dart';
import 'package:burrito/data/geojson/entrances.dart';
import 'package:burrito/data/geojson/faculties.dart';
import 'package:burrito/data/geojson/bus_stops.dart';
import 'package:burrito/data/geojson/burrito_path.dart';
import 'package:burrito/features/map/providers/bus_status_provider.dart';
import 'package:burrito/features/map/providers/center_coords_provider.dart';
import 'package:burrito/features/map/providers/map_controller_provider.dart';
import 'package:burrito/features/map/providers/follow_burrito_provider.dart';

class BurritoMap extends ConsumerStatefulWidget {
  const BurritoMap({super.key});

  @override
  ConsumerState<BurritoMap> createState() => BurritoMapState();
}

class BurritoMapState extends ConsumerState<BurritoMap> {
  late GoogleMapController _controller;

  double mapRotation = 0;
  double mapZoom = initialPos.zoom;

  List<Marker> busStopsMarkers = [];
  List<Marker> entrancesMarkers = [];
  AssetMapBitmap? burritoPosIcon;

  Marker? burritoMarker;

  @override
  void initState() {
    super.initState();

    kUNMSMBusStopsMarkers.then((value) {
      setState(() {
        busStopsMarkers = value;
      });
    });
    kUNMSMEntrances.then((value) {
      setState(() {
        entrancesMarkers = value;
      });
    });
    kBurritoPosIcon.then((icon) {
      burritoPosIcon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    final burritoState = ref.watch(busStatusProvider);
    final mapKey = ref.watch(mapKeyProvider);

    burritoMarker = burritoState.whenOrNull(
      data: (state) {
        if (!state.isBurritoVisible || burritoPosIcon == null) {
          return null;
        }
        return Marker(
          markerId: const MarkerId('burrito'),
          position: LatLng(
            state.lastInfo.pos.latitude,
            state.lastInfo.pos.longitude,
          ),
          icon: burritoPosIcon!,
          zIndex: 696969,
          alpha: 0.9,
        );
      },
    );

    return Listener(
      onPointerDown: (_) => _onTapDown(context),
      child: GoogleMap(
        key: mapKey,
        mapType: MapType.normal,
        initialCameraPosition: initialPos,
        webGestureHandling: WebGestureHandling.greedy,
        padding: const EdgeInsets.only(bottom: 3, top: 3),
        minMaxZoomPreference: const MinMaxZoomPreference(13, 20),
        compassEnabled: true,
        trafficEnabled: false,
        buildingsEnabled: false,
        myLocationEnabled: true,
        mapToolbarEnabled: false,
        tiltGesturesEnabled: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        scrollGesturesEnabled: true,
        rotateGesturesEnabled: true,
        myLocationButtonEnabled: false,
        style: mapStyleString,
        polygons: {kUNMSMPolygon, ...kUNMSMPlacesPolygons},
        polylines: {kBurritoPathPolyLine},
        markers: {
          ...busStopsMarkers,
          ...entrancesMarkers.map(
              (m) => m.copyWith(rotationParam: mapRotation + initialBearing)),
          if (burritoMarker != null) burritoMarker!,
        },
        // Events
        onMapCreated: _onMapCreated,
        onCameraMove: _onCameraMove,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    ref.read(mapControllerProvider.notifier).state = controller;
  }

  void _onCameraMove(CameraPosition pos) async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final screenSize = MediaQuery.of(context).size;

    final deviceWidth = screenSize.width * pixelRatio;
    final deviceHeight = screenSize.height * pixelRatio;

    final screenCoords = await _controller.getLatLng(
      ScreenCoordinate(
        x: (deviceWidth / 2).round(),
        y: (deviceHeight / 2).round(),
      ),
    );

    ref.read(centerCoordsProvider.notifier).state = screenCoords;

    setState(() {
      mapRotation = -pos.bearing;
      mapZoom = pos.zoom;
    });
  }

  void _onTapDown(BuildContext ctx) {
    final followBurrito = ref.read(followBurritoProvider);

    if (followBurrito) {
      ref.read(followBurritoProvider.notifier).state = false;
    }
  }
}
