import 'package:backpack_pal/cities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:backpack_pal/directions_model.dart';
import 'package:backpack_pal/directions_repository.dart';
import 'package:logger/logger.dart';

class MyMap extends StatefulWidget {
  const MyMap({Key? key}) : super(key: key);

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  Logger logger = Logger();

  String city_from = '';
  String city_to = '';

  LatLng originLatLong = LatLng(41.0086, 28.9802);
  LatLng destinationLatLong = LatLng(41.0086, 28.9302);

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(
      41.0086,
      28.9802,
    ),
    zoom: 8,
  );

  late GoogleMapController _googleMapController;
  Marker? _origin;
  Marker? _destination;
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
        title: const Text('Google Maps'),
        actions: [
          if (_origin != null)
            TextButton(
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin!.position,
                    zoom: 10,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Row(
                children: [
                  Icon(Icons.gps_fixed),
                  SizedBox(width: 8),
                  Text('FROM'),
                ],
              ),
            ),
          if (_destination != null)
            TextButton(
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _destination!.position,
                    zoom: 10,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_on_rounded),
                  SizedBox(width: 8),
                  Text('TO'),
                ],
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Colors.black,
                  width: 4.0,
                ),
              ),
              height: MediaQuery.of(context).size.height / 2,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: GoogleMap(
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: true,
                      initialCameraPosition: _initialCameraPosition,
                      onMapCreated: (controller) =>
                          _googleMapController = controller,
                      markers: {
                        if (_origin != null) _origin!,
                        if (_destination != null) _destination!
                      },
                      polylines: {
                        if (_info != null && _info!.polylinePoints.isNotEmpty)
                          Polyline(
                            polylineId: const PolylineId('overview_polyline'),
                            color: Colors.red,
                            width: 5,
                            points: _info!.polylinePoints
                                .map((e) => LatLng(e.latitude, e.longitude))
                                .toList(),
                          ),
                      },
                      onLongPress: _addMarker,
                    ),
                  ),
                  Positioned(
                    bottom: 16.0,
                    right: 60.0,
                    child: Opacity(
                      opacity: 0.7,
                      child: FloatingActionButton(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.black,
                        onPressed: () {
                          if (_info != null) {
                            _googleMapController.animateCamera(
                              CameraUpdate.newLatLngBounds(
                                  _info!.bounds!, 100.0),
                            );
                          } else {
                            _googleMapController.animateCamera(
                              CameraUpdate.newCameraPosition(
                                  _initialCameraPosition),
                            );
                          }
                        },
                        child: const Icon(Icons.center_focus_strong),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_info != null)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Positioned(
                  top: 20.0,
                  child: Container(),
                ),
              ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GFButton(
                  onPressed: chooseFrom,
                  text: city_from,
                  color: Colors.black,
                  icon: Icon(Icons.gps_fixed_rounded),
                  type: GFButtonType.outline2x,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/route.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                GFButton(
                  onPressed: chooseTo,
                  text: city_to,
                  color: Colors.black,
                  icon: Icon(Icons.location_on_rounded),
                  type: GFButtonType.outline2x,
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: GFButton(
                    onPressed: rotaOlustur,
                    text: "ROTA OLUŞTUR",
                    textStyle: TextStyle(
                      fontFamily: GoogleFonts.luckiestGuy().fontFamily,
                      color: Colors.black,
                    ),
                    icon: Icon(Icons.route),
                    color: Colors.green,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );

        _destination = null;

        _info = null;
      });
    } else {
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });

      final directions = await DirectionsRepository()
          .getDirections(origin: _origin!.position, destination: pos);
      setState(() => _info = directions);
    }
  }

  void addOriginMarker(LatLng position) {
    setState(() {
      _origin = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: position,
      );
      // _destination = null;
      _info = null;
    });
  }

  void addDestinationMarker(LatLng position) {
    setState(() {
      _destination = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: position,
      );
      _info = null; // Reset info if needed, but not _destination
    });
  }

  void chooseFrom() {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Nereden?'),
          actions: turkishCitiesCoordinates.keys.map((String cityChosen) {
            return CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  city_from = cityChosen;
                });
                Navigator.pop(context, cityChosen);
              },
              child: Text(cityChosen),
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('İptal'),
          ),
        );
      },
    );
  }

  void chooseTo() {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Nereye?'),
          actions: turkishCitiesCoordinates.keys.map((String cityChosen) {
            return CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  city_to = cityChosen;
                });
                Navigator.pop(context, cityChosen);
              },
              child: Text(cityChosen),
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('İptal'),
          ),
        );
      },
    );
  }

  void rotaOlustur() {
    if (city_from.isNotEmpty && city_to.isNotEmpty) {
      LatLng originLatLng = turkishCitiesCoordinates[city_from]!;
      LatLng destinationLatLng = turkishCitiesCoordinates[city_to]!;

      addOriginMarker(originLatLng);
      addDestinationMarker(destinationLatLng);

      _googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(originLatLng, 7),
      );
    } else {
      // Show a message or handle the case when both cities are not selected
      
      print("Both origin and destination cities must be selected.");
    }
  }
}
