import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final centerCoordsProvider = StateProvider<LatLng?>(
  (ref) => null,
);
