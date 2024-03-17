import 'dart:math';

import 'package:backpack_pal/cities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:backpack_pal/directions_model.dart';
import 'package:backpack_pal/directions_repository.dart';
import 'package:logger/logger.dart';

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  Logger logger = Logger();

  bool shakeButtons = false;

  String city_from = '';
  String city_to = '';
  String cityChosenFrom = '';
  String cityChosenTo = '';

  double distanceBetween = 0.0;

  LatLng originLatLong = const LatLng(41.0086, 28.9802);
  LatLng destinationLatLong = const LatLng(41.0086, 28.9302);

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(
      41.0086,
      28.9802,
    ),
    zoom: 8,
  );

  late GoogleMapController _googleMapController;
  MapType _currentMapType = MapType.normal;
  List<String> _mapTypeOptions = ['Normal', 'Terrain', 'Satellite', 'Hybrid'];

  Marker? _origin;
  Marker? _destination;
  Directions? _info;

  String? _mapStyle = '';

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Future<String?> user_email = getUserEmail();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text('   Google Maps'),
          actions: [
            DropdownButton(
              icon: Icon(Icons.layers),
              value: _currentMapType.toString(),
              items: [
                DropdownMenuItem(
                  value: MapType.normal.toString(),
                  child: Text('Normal '),
                ),
                DropdownMenuItem(
                  value: MapType.terrain.toString(),
                  child: Text('Terrain '),
                ),
                DropdownMenuItem(
                  value: MapType.satellite.toString(),
                  child: Text('Satellite '),
                ),
                DropdownMenuItem(
                  value: MapType.hybrid.toString(),
                  child: Text('Hybrid '),
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _currentMapType = newValue != null
                      ? MapType.values
                          .firstWhere((type) => type.toString() == newValue)
                      : MapType.normal;
                });
              },
            ),
            SizedBox(width: 40),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
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
                        mapType: _currentMapType, // map tipi
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
                        // onLongPress: _addMarker,
                      ),
                    ),
                    Positioned(
                      bottom: 17.0,
                      right: 60.0,
                      child: Opacity(
                        opacity: 0.7,
                        child: FloatingActionButton(
                          backgroundColor: Colors.white.withOpacity(0.9),
                          foregroundColor: Colors.black,
                          onPressed: () {
                            if (_info != null) {
                              _googleMapController.animateCamera(
                                CameraUpdate.newLatLngBounds(
                                    _info!.bounds, 100.0),
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if (_origin != null)
                  TextButton(
                    onPressed: () {
                      if (_origin != null) {
                        _googleMapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: _origin!.position,
                              zoom: 10,
                              tilt: 50.0,
                            ),
                          ),
                        );
                      } else {
                        setState(() {
                          shakeButtons = true;
                        });

                        // Delay the restoration of the buttons
                        Future.delayed(const Duration(milliseconds: 500), () {
                          setState(() {
                            shakeButtons = false;
                          });
                        });
                      }
                    },
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
                  // const SizedBox(width: 110),
                  Image.asset(
                    'assets/route.png',
                    width: 100,
                    height: 50,
                  ),
                  const SizedBox(width: 20),
                  // if (_destination != null)
                  TextButton(
                    onPressed: () {
                      if (_destination != null) {
                        _googleMapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: _destination!.position,
                              zoom: 10,
                              tilt: 50.0,
                            ),
                          ),
                        );
                      } else {
                        setState(() {
                          shakeButtons = true;
                        });

                        // Delay the restoration of the buttons
                        Future.delayed(const Duration(milliseconds: 500), () {
                          setState(() {
                            shakeButtons = false;
                          });
                        });
                      }
                    },
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                        minWidth: 150), // Adjust the minWidth as needed
                    child: GFButton(
                      onPressed: chooseFrom,
                      text: _truncateCityName(city_from),
                      color: shakeButtons && city_from.isEmpty
                          ? Colors.red
                          : Colors.black,
                      // icon: Icon(Icons.gps_fixed_rounded),
                      type: GFButtonType.outline2x,
                      size: GFSize.LARGE,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                        minWidth: 150), // Adjust the minWidth as needed
                    child: GFButton(
                      onPressed: chooseTo,
                      text: _truncateCityName(city_to),
                      color: shakeButtons && city_to.isEmpty
                          ? Colors.red
                          : Colors.black,
                      // icon: const Ico  n(Icons.location_on_rounded),
                      type: GFButtonType.outline2x,
                      size: GFSize.LARGE,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: GFButton(
                      onPressed: rotaOlustur,
                      text: "ROTA HESAPLA",
                      textStyle: TextStyle(
                        fontFamily: GoogleFonts.luckiestGuy().fontFamily,
                        color: Colors.black,
                      ),
                      icon: const Icon(Icons.route),
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$distanceBetween km',
                    style: TextStyle(
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            width: 45,
            height: 45,
            child: FloatingActionButton(
                backgroundColor: Colors.blue,
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                onPressed: () {
                  show_add_dialog();
                }),
          ),
        ),
      ),
    );
  }

  void _changeMapType(String? selectedMapType) {
    // if (selectedMapType == 'Normal') {
    //   _googleMapController.setMapType(MapType.normal);
    // } else if (selectedMapType == 'Terrain') {
    //   _googleMapController.setMapType(MapType.terrain);
    // } else if (selectedMapType == 'Satellite') {
    //   _googleMapController.setMapType(MapType.satellite);
    // } else if (selectedMapType == 'Hybrid') {
    //   _googleMapController.setMapType(MapType.hybrid);
    // }
  }

  double calculateDistance(LatLng from, LatLng to) {
    const double earthRadius = 6371.0; // Radius of the Earth in kilometers

    // Convert latitude and longitude from degrees to radians
    double fromLatRadians = _degreesToRadians(from.latitude);
    double fromLngRadians = _degreesToRadians(from.longitude);
    double toLatRadians = _degreesToRadians(to.latitude);
    double toLngRadians = _degreesToRadians(to.longitude);

    // Calculate the differences between coordinates
    double latDiff = toLatRadians - fromLatRadians;
    double lngDiff = toLngRadians - fromLngRadians;

    // Apply the Haversine formula
    double a = pow(sin(latDiff / 2), 2) +
        cos(fromLatRadians) * cos(toLatRadians) * pow(sin(lngDiff / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance; // Distance in kilometers
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
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
          actions: turkishCitiesCoordinates.keys.map((cityChosenFrom) {
            return CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  city_from = cityChosenFrom;
                });
                Navigator.pop(context, cityChosenFrom);
              },
              child: Text(cityChosenFrom),
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
          actions: turkishCitiesCoordinates.keys.map((cityChosenTo) {
            return CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  city_to = cityChosenTo;
                });
                Navigator.pop(context, cityChosenTo);
              },
              child: Text(cityChosenTo),
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
      if (city_from == city_to) {
        setState(() {
          shakeButtons = true;
          distanceBetween = 0.0;
          city_to = '';
          _destination = null;
          _origin = null;
        });

        // Delay the restoration of the buttons
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            shakeButtons = false;
          });
        });

        return;
      }

      originLatLong = turkishCitiesCoordinates[city_from]!;
      destinationLatLong = turkishCitiesCoordinates[city_to]!;

      addOriginMarker(originLatLong);
      addDestinationMarker(destinationLatLong);

      double distance2 = calculateDistance(originLatLong, destinationLatLong);

      setState(() {
        distanceBetween = double.parse(distance2.toStringAsFixed(2));
      });

      _googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(originLatLong, 7),
      );
    } else {
      // Show a message or handle the case when both cities are not selected

      setState(() {
        shakeButtons = true;
      });

      // Delay the restoration of the buttons
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          shakeButtons = false;
        });
      });
    }
  }

  String _truncateCityName(String cityName) {
    const maxLength = 9; // Define the maximum length before truncation
    if (cityName.length > maxLength) {
      return '${cityName.substring(0, maxLength)}...'; // Truncate and add ellipsis
    } else {
      return cityName; // Return the original name if it's short
    }
  }

  void show_add_dialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Dikkat",
            style: GoogleFonts.luckiestGuy(fontSize: 30),
          ),
          content: Text("Bu rotayı eklemek istiyor musunuz?",
              style: GoogleFonts.ubuntuCondensed(fontSize: 20)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                print('hayır dedin');

                Navigator.of(context).pop();
              },
              child: GFButton(
                text: "Hayır",
                textStyle: TextStyle(
                  fontFamily: GoogleFonts.luckiestGuy().fontFamily,
                  color: Colors.black,
                ),
                color: Colors.red,
                onPressed: () {
                  print('hayır dedin2');
                  Navigator.of(context).pop(); // Dismiss dialog
                },
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Perform action for "Evet" button here
              },
              child: GFButton(
                text: "Evet",
                textStyle: TextStyle(
                  fontFamily: GoogleFonts.luckiestGuy().fontFamily,
                  color: Colors.black,
                ),
                color: Colors.green,
                onPressed: () {
                  storeRouteInFirestore();

                  Navigator.of(context).pop(); // Dismiss dialog
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void storeRouteInFirestore() async {
    rotaOlustur();

    // Access the latitude and longitude of the selected cities
    LatLng originLatLng = turkishCitiesCoordinates[city_from]!;
    LatLng destinationLatLng = turkishCitiesCoordinates[city_to]!;

    // Convert LatLng objects to GeoPoint
    GeoPoint originGeoPoint =
        GeoPoint(originLatLng.latitude, originLatLng.longitude);
    GeoPoint destinationGeoPoint =
        GeoPoint(destinationLatLng.latitude, destinationLatLng.longitude);

    // Get the user's email
    String? userEmail = await getUserEmail();
    // If userEmail is null, handle the case accordingly
    if (userEmail == null) {
      print('User email is null');
      return;
    }

    // Query Firestore to check if a document with the same origin and destination already exists
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('routes')
        .where('origin', isEqualTo: originGeoPoint)
        .where('destination', isEqualTo: destinationGeoPoint)
        .get();

    // If a document with the same origin and destination already exists, notify the user
    if (snapshot.docs.isNotEmpty) {
      print('Route already exists in Firestore');
      // You can show a snackbar, toast, or dialog to inform the user
      return;
    }

    // Store data in Firestore
    FirebaseFirestore.instance.collection('routes').add({
      'origin': originGeoPoint,
      'destination': destinationGeoPoint,
      'city_from': city_from,
      'city_to': city_to,
      'fromWhom': userEmail,
    }).then((value) {
      // Data stored successfully
      print('Route added to Firestore');
    }).catchError((error) {
      // Error handling
      print('Failed to add route: $error');
    });
  }

  Future<String?> getUserEmail() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      return user.email;
    } else {
      return null;
    }
  }
}
