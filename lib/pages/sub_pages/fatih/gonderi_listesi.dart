import 'package:flutter/material.dart';
import 'gonderi.dart';

class GonderiListesi extends StatelessWidget {
  final List<Gonderi> gonderiler;

  GonderiListesi({required this.gonderiler});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: gonderiler.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  gonderiler[index].baslik,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(), // Başlık ile açıklama arasına çizgi ekle
                    Text(
                      gonderiler[index].aciklama,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0), // Açıklama ile fotoğraf arasına boşluk ekle
                    if (gonderiler[index].foto != null)
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 4,
                        child: Image.file(
                          gonderiler[index].foto!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    SizedBox(height: 8.0), // Fotoğraf ile kilometre arasına boşluk ekle
                    Text(
                      'Kilometre: ${gonderiler[index].kilometre}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}
