import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RoutesListView extends StatefulWidget {
  const RoutesListView({super.key});

  @override
  State<RoutesListView> createState() => _RoutesListViewState();
}

class _RoutesListViewState extends State<RoutesListView> {
  int? _expandedIndex; // Index of the currently expanded item
  final List<Set<Marker>> _markersList =
      []; // List to hold markers for each list item
  final List<Set<Polyline>> _polylinesList =
      []; // List to hold polylines for each list item
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(
      39.2933,
      35.2374,
    ),
    zoom: 4.5,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Anasayfa')), // Center-align the title text
        backgroundColor: Colors.deepPurpleAccent, // Set app bar color to purple
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurpleAccent,
              Colors.white
            ], // Gradient from purple to white
          ),
        ),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('routes').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final List<DocumentSnapshot> documents = snapshot.data!.docs;

              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot document = documents[index];
                  final cityFrom =
                      document.exists && document['city_from'] != null
                          ? document['city_from']
                          : '';
                  final cityTo = document['city_to'] ?? '';
                  final fromWhom = document['fromWhom'] ?? '';
                  final guvenilir = document['guvenilir'] ?? 0;
                  final keyifli = document['keyifli'] ?? 0.0;
                  final rahatUlasim = document['rahatUlasim'] ?? 0.0;
                  final origin = document['origin'] ?? const GeoPoint(0, 0);
                  final destination = document['destination'] ?? const GeoPoint(0, 0);
                  final distance =
                      document.exists && document['distance'] != null
                          ? document['distance']
                          : 0;
                  final explanation =
                      document.exists && document['explanation'] != null
                          ? document['explanation']
                          : '';

                  // Check if this item is expanded
                  bool isExpanded = _expandedIndex == index;

                  // Create a new set of markers for this list item
                  Set<Marker> markers = {};

                  // Add marker for cityFrom and cityTo if they are not empty
                  if (cityFrom.isNotEmpty) {
                    markers.add(
                      Marker(
                        markerId: MarkerId(cityFrom),
                        position: LatLng(origin.latitude, origin.longitude),
                        infoWindow: InfoWindow(title: cityFrom),
                      ),
                    );
                  }
                  if (cityTo.isNotEmpty) {
                    markers.add(
                      Marker(
                        markerId: MarkerId(cityTo),
                        position:
                            LatLng(destination.latitude, destination.longitude),
                        infoWindow: InfoWindow(title: cityTo),
                      ),
                    );
                  }

                  // Add the set of markers to the list of marker sets
                  _markersList.add(markers);

                  // Create a new set of polylines for this list item
                  Set<Polyline> polylines = {};

                  // Add a polyline with wavy effect between origin and destination
                  polylines.add(
                    Polyline(
                      polylineId: PolylineId('polyline$index'),
                      color: Colors.blue,
                      width: 3,
                      points: _getWavyPoints(origin.latitude, origin.longitude,
                          destination.latitude, destination.longitude),
                    ),
                  );

                  // Add the set of polylines to the list of polyline sets
                  _polylinesList.add(polylines);

                  // You can use these fields to build your UI
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: Card(
                      elevation: 5,
                      child: GestureDetector(
                        onTap: () {
                          // Handle item click here
                          setState(() {
                            // Update the expanded index to this item's index
                            _expandedIndex = isExpanded ? null : index;
                          });
                          print('Item clicked: $cityFrom - $cityTo');
                        },
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurpleAccent,
                            child: Text(
                              '${fromWhom[0].toUpperCase()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          title: Text(
                            '$cityFrom - $cityTo',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text('Yükleyen: $fromWhom'),
                          initiallyExpanded: isExpanded,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: SizedBox(
                                  width: 300,
                                  height: 150,
                                  child: GoogleMap(
                                    myLocationButtonEnabled: true,
                                    zoomControlsEnabled: true,
                                    initialCameraPosition:
                                        _initialCameraPosition,
                                    markers: _markersList[index],
                                    polylines: _polylinesList[index],
                                  ),
                                ),
                              ),
                            ),
                            // Additional widgets revealed when expanded
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 8, 0, 0),
                              child: _buildDescriptionWidget(
                                  'Güvenilirlik: ', guvenilir),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child:
                                  _buildDescriptionWidget('Keyifli: ', keyifli),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: _buildDescriptionWidget(
                                  'Rahat Ulaşım: ', rahatUlasim),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 8, 18, 15),
                              child: Row(
                                children: <Widget>[
                                  const Text(
                                    'Açıklama: ',
                                    textAlign: TextAlign.justify,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: RichText(
                                      textAlign: TextAlign.justify,
                                      text: TextSpan(
                                        text: explanation,
                                        style: const TextStyle(
                                          fontSize:
                                              15.0, // Adjust font size as needed
                                              fontStyle: FontStyle.italic,
                                          color: Colors
                                              .black, // Adjust color as needed
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  List<LatLng> _getWavyPoints(
      double startLat, double startLng, double endLat, double endLng) {
    List<LatLng> points = [];
    final double totalDistance =
        sqrt(pow(endLat - startLat, 2) + pow(endLng - startLng, 2));
    final double segmentLength = totalDistance /
        50; // Divide total distance into 50 segments for more waves

    for (double t = 0; t <= 1; t += 0.01) {
      final double offsetX = sin(t * pi * 10) * segmentLength * 0.1;
      final double offsetY = cos(t * pi * 10) * segmentLength * 0.1;
      final double lat = startLat + (endLat - startLat) * t + offsetX;
      final double lng = startLng + (endLng - startLng) * t + offsetY;
      points.add(LatLng(lat, lng));
    }

    return points;
  }

  Widget _buildDescriptionWidget(String title, dynamic content) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: content is double
                ? _buildStarRating(content)
                : Text('$content'),
          ),
        ],
      ),
    );
  }
}

Widget _buildStarRating(double rating) {
  int numberOfFullStars = rating.floor();
  int numberOfHalfStars = (rating * 2 % 2).toInt();
  int numberOfEmptyStars = 5 - numberOfFullStars - numberOfHalfStars;

  List<Widget> stars = [];

  // Add full stars
  for (int i = 0; i < numberOfFullStars; i++) {
    stars.add(
      const Icon(Icons.star, color: Colors.amber, size: 24),
    );
  }

  // Add half stars
  if (numberOfHalfStars == 1) {
    stars.add(
      const Icon(Icons.star_half, color: Colors.amber, size: 24),
    );
  }

  // Add empty stars
  for (int i = 0; i < numberOfEmptyStars; i++) {
    stars.add(
      const Icon(Icons.star_border, color: Colors.amber, size: 24),
    );
  }

  return Row(children: stars);
}
