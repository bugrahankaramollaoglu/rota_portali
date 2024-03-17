import 'package:flutter/material.dart';
import 'gonderi.dart';

class GonderiListesi extends StatelessWidget {
  final List<Gonderi> gonderiler;

  const GonderiListesi({super.key, required this.gonderiler});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: gonderiler.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  gonderiler[index].baslik,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(), // Başlık ile açıklama arasına çizgi ekle
                    Text(
                      gonderiler[index].aciklama,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0), // Açıklama ile fotoğraf arasına boşluk ekle
                    if (gonderiler[index].foto != null)
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 4,
                        child: Image.file(
                          gonderiler[index].foto!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 8.0), // Fotoğraf ile kilometre arasına boşluk ekle
                    Text(
                      'Kilometre: ${gonderiler[index].kilometre}',
                      style: const TextStyle(fontSize: 16.0),
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
