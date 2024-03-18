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
  int? _expandedIndex;
  final List<Set<Marker>> _markersList = [];
  final List<Set<Polyline>> _polylinesList = [];
  final TextEditingController _searchController = TextEditingController();

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(
      39.2933,
      35.2374,
    ),
    zoom: 4.5,
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anasayfa'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.deepPurpleAccent,
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Ara...',
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Colors.purple),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.deepPurpleAccent, Colors.white],
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
                    final List<DocumentSnapshot> documents =
                        snapshot.data!.docs;

                    final filteredDocuments = documents.where((document) {
                      final cityFrom = document['city_from'] ?? '';
                      final cityTo = document['city_to'] ?? '';
                      final searchText = _searchController.text.toLowerCase();

                      return cityFrom.toLowerCase().contains(searchText) ||
                          cityTo.toLowerCase().contains(searchText);
                    }).toList();

                    return ListView.builder(
                      itemCount: filteredDocuments.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot document =
                            filteredDocuments[index];
                        final cityFrom = document['city_from'] ?? '';
                        final cityTo = document['city_to'] ?? '';
                        final fromWhom = document['fromWhom'] ?? '';
                        final guvenilir = document['guvenilir'] ?? 0;
                        final keyifli = document['keyifli'] ?? 0.0;
                        final rahatUlasim = document['rahatUlasim'] ?? 0.0;
                        final origin =
                            document['origin'] ?? const GeoPoint(0, 0);
                        final destination =
                            document['destination'] ?? const GeoPoint(0, 0);
                        final distance = document['distance'] ?? 0;
                        final explanation = document['explanation'] ?? '';

                        bool isExpanded = _expandedIndex == index;

                        Set<Marker> markers = {};

                        if (cityFrom.isNotEmpty) {
                          markers.add(
                            Marker(
                              markerId: MarkerId(cityFrom),
                              position:
                                  LatLng(origin.latitude, origin.longitude),
                              infoWindow: InfoWindow(title: cityFrom),
                            ),
                          );
                        }
                        if (cityTo.isNotEmpty) {
                          markers.add(
                            Marker(
                              markerId: MarkerId(cityTo),
                              position: LatLng(
                                  destination.latitude, destination.longitude),
                              infoWindow: InfoWindow(title: cityTo),
                            ),
                          );
                        }

                        _markersList.add(markers);

                        Set<Polyline> polylines = {};

                        polylines.add(
                          Polyline(
                            polylineId: PolylineId('polyline$index'),
                            color: Colors.blue,
                            width: 3,
                            points: _getWavyPoints(
                                origin.latitude,
                                origin.longitude,
                                destination.latitude,
                                destination.longitude),
                          ),
                        );

                        _polylinesList.add(polylines);

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                          child: Card(
                            elevation: 5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
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
                                  _buildDescriptionWidget(
                                      'Güvenilirlik: ', guvenilir),
                                  _buildDescriptionWidget('Keyifli: ', keyifli),
                                  _buildDescriptionWidget(
                                      'Rahat Ulaşım: ', rahatUlasim),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        const Text(
                                          'Açıklama: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            explanation,
                                            textAlign: TextAlign.left,
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
          ),
        ],
      ),
    );
  }

  List<LatLng> _getWavyPoints(
      double startLat, double startLng, double endLat, double endLng) {
    List<LatLng> points = [];
    final double totalDistance =
        sqrt(pow(endLat - startLat, 2) + pow(endLng - startLng, 2));
    final double segmentLength = totalDistance / 50;

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

  Widget _buildStarRating(double rating) {
    int numberOfFullStars = rating.floor();
    int numberOfHalfStars = (rating * 2 % 2).toInt();
    int numberOfEmptyStars = 5 - numberOfFullStars - numberOfHalfStars;

    List<Widget> stars = [];

    for (int i = 0; i < numberOfFullStars; i++) {
      stars.add(
        const Icon(Icons.star, color: Colors.amber, size: 24),
      );
    }

    if (numberOfHalfStars == 1) {
      stars.add(
        const Icon(Icons.star_half, color: Colors.amber, size: 24),
      );
    }

    for (int i = 0; i < numberOfEmptyStars; i++) {
      stars.add(
        const Icon(Icons.star_border, color: Colors.amber, size: 24),
      );
    }

    return Row(children: stars);
  }
}
