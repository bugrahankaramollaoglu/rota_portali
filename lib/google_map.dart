import 'package:backpack_pal/directions_model.dart';
import 'package:backpack_pal/directions_repository.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

class MyMap extends StatefulWidget {
  const MyMap({Key? key}) : super(key: key);

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  Logger logger = Logger();

  static const _initialLocation = CameraPosition(
    target: LatLng(
      41.0086,
      28.9802,
    ),
    zoom: 14.5,
  );

  late GoogleMapController _googleMapController;
  Marker? _cikisNoktasi; // Initialize markers as nullable
  Marker? _varisNoktasi;
  Directions? _info;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Google Maps'),
        actions: [
          if (_cikisNoktasi != null)
            TextButton(
              child: Text('BASLANGIC'),
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _cikisNoktasi!.position,
                    zoom: 15.0,
                    tilt: 50.0,
                  ),
                ),
              ),
            ),
          if (_varisNoktasi != null)
            TextButton(
              child: Text('VARIS'),
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _varisNoktasi!.position,
                    zoom: 15.0,
                    tilt: 50.0,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialLocation,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {
              if (_cikisNoktasi != null) _cikisNoktasi!,
              if (_varisNoktasi != null) _varisNoktasi!,
            },
            polylines: _info != null
                ? {
                    Polyline(
                      polylineId: PolylineId('overview_polyline'),
                      color: Colors.red,
                      width: 5,
                      points: _info!.polyLinePoints
                          .map((e) => LatLng(e.latitude, e.longitude))
                          .toList(),
                    ),
                  }
                : {},
            onLongPress: _addMarker,
          ),
          if (_info != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Text(
                  '${_info?.totalDistance}, ${_info?.totalDuration}',
                  style: const TextStyle(
                    fontSize: 8.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
void _addMarker(LatLng pos) async {
    if (_cikisNoktasi == null ||
        (_varisNoktasi != null && _cikisNoktasi != null)) {
      setState(() {
        _cikisNoktasi = Marker(
          markerId: const MarkerId('cikisNoktasi'),
          infoWindow: const InfoWindow(title: 'Çıkış Noktası'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        _varisNoktasi = null;
        _info = null;
      });
    } else {
      setState(() {
        _varisNoktasi = Marker(
          markerId: const MarkerId('varisNoktasi'),
          infoWindow: const InfoWindow(title: 'Varış Noktası'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });

      // Only calculate directions if both start and end points are available
      if (_cikisNoktasi != null && _varisNoktasi != null) {
        final directions = await DirectionsRepository().getDirections(
          cikisNoktasi: _cikisNoktasi!.position,
          varisNoktasi: _varisNoktasi!.position,
        );
        setState(() {
          _info = directions;
        });
        _googleMapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            directions!.bounds!,
            100.0,
          ),
        );
      }
    }
  }

}
