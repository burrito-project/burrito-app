import 'package:google_maps_flutter/google_maps_flutter.dart';

const initialPos = CameraPosition(
  target: LatLng(-12.0564, -77.0842),
  zoom: 15.8,
  bearing: initialBearing,
);

// Defines the area where the UNMSM campus is located
final unmsmSafeBounds = LatLngBounds(
  northeast: const LatLng(-12.046289722547598, -77.07152485225949),
  southwest: const LatLng(-12.067094492529293, -77.09482359102397),
);

const initialBearing = 169.696969;

const mapStyleString = """
[
    {
        "featureType": "all",
        "elementType": "labels.text",
        "stylers": [
            {
                "color": "#878787"
            }
        ]
    },
    {
        "featureType": "all",
        "elementType": "labels.text.stroke",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "all",
        "stylers": [
            {
                "color": "#f9f5ed"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "all",
        "stylers": [
            {
                "color": "#f5f5f5"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#c9c9c9"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "all",
        "stylers": [
            {
                "color": "#aee0f4"
            }
        ]
    },
    {
      "featureType": "poi.medical",
      "stylers": [
          {
                "visibility": "off"
          }
      ]
    },
    {
        "featureType": "poi.place_of_worship",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "poi.sports_complex",
        "elementType": "labels.icon",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "transit.station.bus",
        "elementType": "labels.icon",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "poi.attraction",
          "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "poi.school",
        "elementType": "labels.text",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    }
]""";

/*
Styles to consider:
{
    "featureType": "poi.business",
    "elementType": "labels.icon",
    "stylers": [
        {
            "visibility": "off"
        }
    ]
}
*/
