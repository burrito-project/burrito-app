import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:burrito/data/geojson/unmsm.dart';
import 'package:burrito/features/map/config.dart';
import 'package:burrito/services/dio_client.dart';
import 'package:burrito/data/markers/bitmaps.dart';
import 'package:burrito/data/geojson/entrances.dart';
import 'package:burrito/data/geojson/faculties.dart';
import 'package:burrito/data/geojson/bus_stops.dart';
import 'package:burrito/data/geojson/burrito_path.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:burrito/features/map/widgets/app_top_bar.dart';
import 'package:burrito/features/map/widgets/app_bottom_bar.dart';

class BurritoMap extends StatefulWidget {
  const BurritoMap({super.key});

  @override
  State<BurritoMap> createState() => BurritoMapState();
}

class BurritoMapState extends State<BurritoMap> {
  late GoogleMapController _controller;
  Position? userPos;

  LatLng? screenCenterLatLng;
  double mapRotation = 0;
  double mapZoom = initialPos.zoom;

  List<Marker> busStopsMarkers = [];
  List<Marker> entrancesMarkers = [];

  BurritoState? burritoState;
  bool loadingLastInfo = true;
  Marker? burritoMarker;
  bool followBurrito = false;

  @override
  void initState() {
    super.initState();
    backgroundPosUpdate();
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
  }

  @override
  Widget build(BuildContext context) {
    final userOnBounds = screenCenterLatLng == null
        ? true
        : unmsmSafeBounds.contains(screenCenterLatLng!);

    return Scaffold(
      body: Column(
        children: [
          BurritoTopAppBar(burritoState: burritoState),
          Expanded(
            child: Stack(
              children: [
                Listener(
                  onPointerDown: _onTapDown,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: initialPos,
                    padding: const EdgeInsets.only(bottom: 1000, top: 1000),
                    minMaxZoomPreference: const MinMaxZoomPreference(14, 20),
                    compassEnabled: false,
                    trafficEnabled: false,
                    buildingsEnabled: false,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: true,
                    mapToolbarEnabled: false,
                    style: mapStyleString,
                    polygons: {kUNMSMPolygon, ...kUNMSMPlacesPolygons},
                    polylines: {kBurritoPathPolyLine},
                    markers: {
                      ...busStopsMarkers,
                      ...entrancesMarkers.map((m) => m.copyWith(
                          rotationParam: mapRotation + initialBearing)),
                      if (burritoMarker != null) burritoMarker!,
                    },
                    // Events
                    onMapCreated: _onMapCreated,
                    onCameraMove: _onCameraMove,
                  ),
                ),
                if (!userOnBounds) ...[
                  // Go back button
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black87, width: 1.5),
                      ),
                      child: ClipOval(
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            splashColor: Colors.grey,
                            onTap: () {
                              _controller.animateCamera(
                                CameraUpdate.newLatLng(initialPos.target),
                              );
                            },
                            child: const SizedBox(
                              width: 48,
                              height: 48,
                              child: Icon(
                                Icons.keyboard_return_rounded,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                if (burritoState?.isBurritoVisible ?? false) ...[
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black87, width: 1.5),
                      ),
                      child: ClipOval(
                        child: Material(
                          color: followBurrito ? Colors.black : Colors.white,
                          child: InkWell(
                            splashColor: Colors.grey,
                            onTap: () {
                              setState(() {
                                followBurrito = !followBurrito;
                                if (followBurrito) {
                                  focusBurritoIfExists();
                                }
                              });
                            },
                            child: SizedBox(
                              width: 48,
                              height: 48,
                              child: Icon(
                                followBurrito ? Icons.stop : Icons.push_pin,
                                size: 32,
                                color: followBurrito
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          BurritoBottomAppBar(burritoState: burritoState),
        ],
      ),
    );
  }

  void backgroundPosUpdate() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        final response = await getInfoAcrossTime();
        final burritoPosIcon = await kBurritoPosIcon;

        setState(() {
          burritoState = response;
          loadingLastInfo = false;
          burritoMarker = Marker(
            markerId: const MarkerId('burrito'),
            position: LatLng(
              burritoState!.lastInfo.pos.latitude,
              burritoState!.lastInfo.pos.longitude,
            ),
            icon: burritoPosIcon,
            zIndex: 696969,
            alpha: 0.8,
          );
        });
        if (followBurrito && response.isBurritoVisible) {
          focusBurritoIfExists();
        }
      } catch (e, st) {
        // ignore: avoid_print
        print('🫏 Error fetching burrito: $e\n$st');
        log('Error fetching burrito info', error: e, stackTrace: st);
        setState(() {
          loadingLastInfo = true;
        });
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
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

    setState(() {
      screenCenterLatLng = screenCoords;
      mapRotation = -pos.bearing;
      mapZoom = pos.zoom;
    });
  }

  void _onTapDown(_) {
    if (followBurrito) {
      setState(() {
        followBurrito = false;
      });
    }
  }

  void focusBurritoIfExists() {
    if (burritoState != null) {
      _controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            burritoState!.lastInfo.pos.latitude,
            burritoState!.lastInfo.pos.longitude,
          ),
          17,
        ),
      );
    }
  }
}
