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

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(
      41.0086,
      28.9802,
    ),
    zoom: 8,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore ListView Example'),
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
                  final origin = document['origin'] ?? GeoPoint(0, 0);
                  final distance =
                      document.exists && document['distance'] != null
                          ? document['distance']
                          : 0;
                  final destination = document['destination'] ?? GeoPoint(0, 0);

                  // Check if this item is expanded
                  bool isExpanded = _expandedIndex == index;

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
                                  child: const GoogleMap(
                                    myLocationButtonEnabled: true,
                                    zoomControlsEnabled: true,
                                    initialCameraPosition:
                                        _initialCameraPosition,
                                    // mapType: _currentMapType,
                                    // onMapCreated: (controller) =>
                                    //     _googleMapController = controller,
                                    // markers: {
                                    //   if (_origin != null) _origin!,
                                    //   if (_destination != null) _destination!
                                    // },
                                    // polylines: Set<Polyline>.of(_polylines),
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
