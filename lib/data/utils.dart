import 'package:google_maps_flutter/google_maps_flutter.dart';

List<LatLng> asPoints(List<List<double>> data) {
  return data.map((coord) => LatLng(coord[1], coord[0])).toList();
}
