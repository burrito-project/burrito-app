import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:burrito/data/markers/bitmaps.dart';

final List<Map<String, dynamic>> kUNMSMEntrancesGeoJSON = [
  {
    "type": "Feature",
    "properties": {"number": 6},
    "geometry": {
      "coordinates": [-77.08342230621332, -12.054217441072467],
      "type": "Point"
    }
  },
  {
    "type": "Feature",
    "properties": {"number": 7},
    "geometry": {
      "coordinates": [-77.0842368583137, -12.053668059545402],
      "type": "Point"
    }
  },
  {
    "type": "Feature",
    "properties": {"number": 1},
    "geometry": {
      "coordinates": [-77.0858171948412, -12.061290863015955],
      "type": "Point"
    }
  },
  {
    "type": "Feature",
    "properties": {"number": 2},
    "geometry": {
      "coordinates": [-77.07929807923772, -12.05941868121461],
      "type": "Point"
    }
  },
  {
    "type": "Feature",
    "properties": {"number": 3},
    "geometry": {
      "coordinates": [-77.07987872153393, -12.057030023595345],
      "type": "Point"
    }
  },
  {
    "type": "Feature",
    "properties": {"number": 4},
    "geometry": {
      "coordinates": [-77.08076742885393, -12.055887024909097],
      "type": "Point"
    }
  },
  {
    "type": "Feature",
    "properties": {"number": 5},
    "geometry": {
      "coordinates": [-77.08213443503038, -12.055043378906959],
      "type": "Point"
    }
  },
  {
    "type": "Feature",
    "properties": {"number": 8},
    "geometry": {
      "coordinates": [-77.08766887143001, -12.05144822918568],
      "type": "Point"
    }
  },
];

final kUNMSMEntrances =
    Future.wait(kUNMSMEntrancesGeoJSON.map((entrance) async {
  final location = entrance['geometry']['coordinates'] as List<double>;
  final number = entrance['properties']['number'] as int;

  final icon = await entranceIcon(number);

  return Marker(
    markerId: MarkerId('entrance_p$number'),
    position: LatLng(location[1], location[0]),
    icon: icon,
  );
}));
