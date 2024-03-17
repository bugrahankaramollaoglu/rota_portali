import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoutesListView extends StatefulWidget {
  const RoutesListView({Key? key});

  @override
  State<RoutesListView> createState() => _RoutesListViewState();
}

class _RoutesListViewState extends State<RoutesListView> {
  int? _expandedIndex; // Index of the currently expanded item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore ListView Example'),
      ),
      body: FutureBuilder<QuerySnapshot>(
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
                final cityFrom = document['city_from'] ?? '';
                final cityTo = document['city_to'] ?? '';
                final fromWhom = document['fromWhom'] ?? '';
                final guvenilir = document['guvenilir'] ?? 0;
                final keyifli = document['keyifli'] ?? 0.0;
                final rahatUlasim = document['rahatUlasim'] ?? 0.0;
                final origin = document['origin'] ?? GeoPoint(0, 0);
                final distance = document['distance'] ?? 0;
                final destination = document['destination'] ?? GeoPoint(0, 0);

                // Check if this item is expanded
                bool isExpanded = _expandedIndex == index;

                // You can use these fields to build your UI
                return GestureDetector(
                  onTap: () {
                    // Handle item click here
                    setState(() {
                      // Update the expanded index to this item's index
                      _expandedIndex = isExpanded ? null : index;
                    });
                    print('Item clicked: $cityFrom - $cityTo');
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orange,
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
                        // Add more fields as needed
                        children: <Widget>[
                          // Additional widgets revealed when expanded
                          Text('Guvenilir: $guvenilir'),
                          Text('Keyifli: $keyifli'),
                          Text('Rahat Ulaşım: $rahatUlasim'),
                          Text('Mesafe: $distance km'),
                        ],
                        // Initially expanded if this item is the expanded one
                        initiallyExpanded: isExpanded,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
