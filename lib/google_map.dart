import 'dart:math';
import 'package:rota_portali/cities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rota_portali/directions_model.dart';
import 'package:logger/logger.dart';

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  Logger logger = Logger();
  final TextEditingController _aciklamaController = TextEditingController();
  bool shakeButtons = false;

  String city_from = '';
  String city_to = '';
  String cityChosenFrom = '';
  String cityChosenTo = '';

  double guvenilir = 0.0;
  double rahatUlasim = 0.0;
  double keyifli = 0.0;

  double distanceBetween = 0.0;

  LatLng originLatLong = const LatLng(41.0086, 28.9802);
  LatLng destinationLatLong = const LatLng(41.0086, 28.9302);

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(
      39.2933,
      35.2374,
    ),
    zoom: 4.5,
  );

  late GoogleMapController _googleMapController;
  MapType _currentMapType = MapType.normal;
  final List<String> _mapTypeOptions = [
    'Normal',
    'Terrain',
    'Satellite',
    'Hybrid'
  ];

  Marker? _origin;
  Marker? _destination;
  Directions? _info;

  final Set<Polyline> _polylines = {};

  final String _mapStyle = '';

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text('   Google Harita'),
          actions: [
            DropdownButton(
              icon: const Icon(Icons.layers),
              value: _currentMapType.toString(),
              items: [
                DropdownMenuItem(
                  value: MapType.normal.toString(),
                  child: const Text('Normal '),
                ),
                DropdownMenuItem(
                  value: MapType.terrain.toString(),
                  child: const Text('Terrain '),
                ),
                DropdownMenuItem(
                  value: MapType.satellite.toString(),
                  child: const Text('Satellite '),
                ),
                DropdownMenuItem(
                  value: MapType.hybrid.toString(),
                  child: const Text('Hybrid '),
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
            const SizedBox(width: 40),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
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
                          mapType: _currentMapType,
                          onMapCreated: (controller) =>
                              _googleMapController = controller,
                          markers: {
                            if (_origin != null) _origin!,
                            if (_destination != null) _destination!
                          },
                          polylines: Set<Polyline>.of(_polylines),
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
                                    _info!.bounds,
                                    100.0,
                                  ),
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
                          Text('NEREDEN'),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/route.png',
                      width: 80,
                      height: 50,
                    ),
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
                          Text('NEREYE'),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      constraints: const BoxConstraints(minWidth: 120),
                      child: GFButton(
                        onPressed: chooseFrom,
                        text: _truncateCityName(city_from),
                        color: shakeButtons && city_from.isEmpty
                            ? Colors.red
                            : Colors.black,
                        type: GFButtonType.outline2x,
                        size: GFSize.LARGE,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                    Container(
                      constraints: const BoxConstraints(minWidth: 120),
                      child: GFButton(
                        onPressed: chooseTo,
                        text: _truncateCityName(city_to),
                        color: shakeButtons && city_to.isEmpty
                            ? Colors.red
                            : Colors.black,
                        type: GFButtonType.outline2x,
                        size: GFSize.LARGE,
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
                        fontFamily: GoogleFonts.allerta().fontFamily,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                Column(
                  children: [
                    const Text(
                      // "Rota yorumunuz\n(Önerilen mekanlar, yol tavsiyeleri, görülmesi gerekenler...)",
                      "Rota yorumunuz\n",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    TextFormField(
                      controller:
                          _aciklamaController, // Burada kontrolcüyü atayın
                      decoration: const InputDecoration(
                        labelText: 'Yazınız',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GFButton(
                            onPressed: rotaOlustur,
                            text: "ROTA HESAPLA",
                            textStyle: TextStyle(
                              fontFamily: GoogleFonts.luckiestGuy().fontFamily,
                              color: Colors.black,
                            ),
                            icon: const Icon(Icons.nordic_walking_outlined),
                            color: Colors.green,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GFButton(
                            onPressed: show_add_dialog,
                            text: "ROTA OLUŞTUR",
                            textStyle: TextStyle(
                              fontFamily: GoogleFonts.luckiestGuy().fontFamily,
                              color: Colors.black,
                            ),
                            icon: const Icon(Icons.add),
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double calculateDistance(LatLng from, LatLng to) {
    const double earthRadius = 6371.0;

    double fromLatRadians = _degreesToRadians(from.latitude);
    double fromLngRadians = _degreesToRadians(from.longitude);
    double toLatRadians = _degreesToRadians(to.latitude);
    double toLngRadians = _degreesToRadians(to.longitude);

    double latDiff = toLatRadians - fromLatRadians;
    double lngDiff = toLngRadians - fromLngRadians;

    double a = pow(sin(latDiff / 2), 2) +
        cos(fromLatRadians) * cos(toLatRadians) * pow(sin(lngDiff / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  void addOriginMarker(LatLng position) {
    setState(() {
      _origin = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Nereden'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: position,
      );

      _info = null;
    });

    _addPolyline();
  }

  void addDestinationMarker(LatLng position) {
    setState(() {
      _destination = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Nereye'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: position,
      );
      _info = null;
    });

    _addPolyline();
  }

  void _addPolyline() {
    if (_origin != null && _destination != null) {
      final List<LatLng> polylineCoordinates = [
        _origin!.position,
        _destination!.position,
      ];

      final Polyline polyline = Polyline(
        polylineId: const PolylineId('polyline'),
        color: Colors.red,
        width: 3,
        points: polylineCoordinates,
      );

      setState(() {
        _polylines.add(polyline);
      });
    }
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
      setState(() {
        shakeButtons = true;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          shakeButtons = false;
        });
      });
    }
  }

  String _truncateCityName(String cityName) {
    const maxLength = 9;
    if (cityName.length > maxLength) {
      return '${cityName.substring(0, maxLength)}...';
    } else {
      return cityName;
    }
  }

  void show_add_dialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "ROTA EKLE",
              style: GoogleFonts.luckiestGuy(fontSize: 30),
            ),
          ),
          content: Text(
            "Bu rotayı eklemek istiyor musunuz?",
            style: GoogleFonts.ubuntuCondensed(fontSize: 18),
          ),
          actions: <Widget>[
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Güvenlik',
                      style: GoogleFonts.roboto(
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      // itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star_rounded,
                        color: Colors.deepPurpleAccent,
                      ),
                      onRatingUpdate: (_guvenilir) {
                        print('güvenilir rate: $guvenilir');
                        guvenilir = _guvenilir;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Keyifli',
                      style: GoogleFonts.roboto(
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      // itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star_rounded,
                        color: Colors.deepPurpleAccent,
                      ),
                      onRatingUpdate: (_keyifli) {
                        print('keyifli rate: $keyifli');
                        keyifli = _keyifli;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Rahat Ulaşım',
                      style: GoogleFonts.roboto(
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      // itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star_rounded,
                        color: Colors.deepPurpleAccent,
                      ),
                      onRatingUpdate: (_rahatUlasim) {
                        print('rahatUlasim rate: $rahatUlasim');
                        rahatUlasim = _rahatUlasim;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: null,
                      child: GFButton(
                        text: "Hayır",
                        textStyle: TextStyle(
                          fontFamily: GoogleFonts.luckiestGuy().fontFamily,
                          color: Colors.black,
                        ),
                        color: Colors.red,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
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
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        );
      },
    );
  }

  void storeRouteInFirestore() async {
    rotaOlustur();
    String aciklama = _aciklamaController.text;
    LatLng originLatLng = turkishCitiesCoordinates[city_from]!;
    LatLng destinationLatLng = turkishCitiesCoordinates[city_to]!;

    GeoPoint originGeoPoint =
        GeoPoint(originLatLng.latitude, originLatLng.longitude);
    GeoPoint destinationGeoPoint =
        GeoPoint(destinationLatLng.latitude, destinationLatLng.longitude);

    String? userEmail = await getUserEmail();

    if (userEmail == null ||
        guvenilir == 0 ||
        rahatUlasim == 0 ||
        keyifli == 0 ||
        distanceBetween == 0.0) {
      _showToast('Bilgileri Doldurunuz.');
      return;
    }

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('routes')
        .where('origin', isEqualTo: originGeoPoint)
        .where('destination', isEqualTo: destinationGeoPoint)
        .get();

    if (snapshot.docs.isNotEmpty) {
      print('Route already exists in Firestore');
      _showToast('Rota zaten mevcut :(');
      return;
    }

    FirebaseFirestore.instance.collection('routes').add({
      'origin': originGeoPoint,
      'destination': destinationGeoPoint,
      'city_from': city_from,
      'city_to': city_to,
      'fromWhom': userEmail,
      'guvenilir': guvenilir,
      'rahatUlasim': rahatUlasim,
      'keyifli': keyifli,
      'distance': distanceBetween,
      'explanation': aciklama, // Açıklama verisini Firestore'a ekleyin
    }).then((value) {
      _showToast('Rota eklendi!');
    }).catchError((error) {
      _showToast('Rota eklenemedi...');
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

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.deepPurpleAccent.withOpacity(0.7),
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }
}
