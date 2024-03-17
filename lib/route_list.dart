import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RoutesListView extends StatefulWidget {
  const RoutesListView({Key? key});

  @override
  State<RoutesListView> createState() => _RoutesListViewState();
}

class _RoutesListViewState extends State<RoutesListView> {
  int? _expandedIndex; // Index of the currently expanded item
  List<Set<Marker>> _markersList =
      []; // List to hold markers for each list item

  List<Set<Polyline>> _polylinesList =
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
        title: Center(child: Text('Anasayfa')), // Center-align the title text
        backgroundColor: Colors.deepPurpleAccent, // Set app bar color to purple
      ),
      body: Container(
        decoration: BoxDecoration(
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
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              final List<DocumentSnapshot> documents = snapshot.data!.docs;

              return ListView.builder(
                itemCount: documents.length * 2 -
                    1, // Double the item count to add dividers
                itemBuilder: (context, index) {
                  // if (index.isOdd) {
                  //   return Divider(); // Add a divider for odd indices
                  // }

                  final int itemIndex = index ~/ 2;
                  final DocumentSnapshot document = documents[itemIndex];
                  final cityFrom =
                      document.exists && document['city_from'] != null
                          ? document['city_from']
                          : '';
                  final cityTo = document['city_to'] ?? '';
                  final fromWhom = document['fromWhom'] ?? '';
                  final guvenilir = document['guvenilir'] ?? 0;
                  final keyifli = document['keyifli'] ?? 0.0;
                  final rahatUlasim = document['rahatUlasim'] ?? 0.0;
                  final origin = document['origin'] ?? GeoPoint(0, 0);
                  final distance =
                      document.exists && document['distance'] != null
                          ? document['distance']
                          : 0;
                  final destination = document['destination'] ?? GeoPoint(0, 0);

                  // Check if this item is expanded
                  bool isExpanded = _expandedIndex == itemIndex;

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

                  // Add a polyline between origin and destination
                  polylines.add(
                    Polyline(
                      polylineId: PolylineId('polyline$itemIndex'),
                      color: Colors.blue, // Polyline color
                      width: 3, // Polyline width
                      points: [
                        LatLng(origin.latitude, origin.longitude),
                        LatLng(destination.latitude, destination.longitude)
                      ],
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
                            _expandedIndex = isExpanded ? null : itemIndex;
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
                          // Initially expanded if this item is the expanded one
                          initiallyExpanded: isExpanded,
                          // Add more fields as needed
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Container(
                                  width: 300,
                                  height: 150,
                                  child: GoogleMap(
                                    myLocationButtonEnabled: true,
                                    zoomControlsEnabled: true,
                                    initialCameraPosition:
                                        _initialCameraPosition,
                                    markers: _markersList[itemIndex],
                                    polylines: _polylinesList[itemIndex],
                                  ),
                                ),
                              ),
                            ),
                            // Additional widgets revealed when expanded
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Güvenilir: $guvenilir'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Keyifli: $keyifli'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Rahat Ulaşım: $rahatUlasim'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Mesafe: $distance km'),
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
}
