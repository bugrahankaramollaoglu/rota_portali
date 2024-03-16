import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final LatLngBounds bounds;
  final String totalDuration;
  final String totalDistance;
  final List<PointLatLng> polyLinePoints;

  const Directions({
    required this.bounds,
    required this.polyLinePoints,
    required this.totalDuration,
    required this.totalDistance,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    // check if route is not available
    if ((map['routes'] as List).isEmpty) {
      // return null;
    }

    final data = Map<String, dynamic>.from(map['routes'][0]);

    // bounds
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast['lat'], northeast['lng']),
      southwest: LatLng(southwest['lat'], southwest['lng']),
    );

    // distance & duration
    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    return Directions(
      bounds: bounds,
      polyLinePoints:
          PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      totalDistance: distance,
      totalDuration: duration,
    );
  }
}
