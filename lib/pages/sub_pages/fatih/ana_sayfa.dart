import 'package:flutter/material.dart';
import 'gonderi.dart';
import 'gonderi_listesi.dart';
import 'gonderi_ekleme_sayfasi.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  List<Gonderi> gonderiler = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        title: const Center(
          child: Text('Anasayfa'),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.deepPurple[300],
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Ara...',
                            hintStyle: const TextStyle(color: Colors.white),
                            prefixIcon: const Icon(Icons.search, color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      onPressed: () {
                        // Buraya filtreleme işlemleri için yapılacak işlemleri ekleyebilirsiniz
                      },
                    ),
                  ],
                ),
                const Divider(color: Colors.white), // Çizgi ekle
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.white,
                  ],
                ),
              ),
              child: gonderiler.isEmpty
                  ? const Center(
                child: Text('Maalesef Görüntüleyebileceğiniz Rota Yok'),
              )
                  : GonderiListesi(gonderiler: gonderiler),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.deepPurple, // Arka plan rengi
        color: Colors.white, // Icon renkleri
        buttonBackgroundColor: Colors.deepPurple[100], // Buton rengi
        height: 60, // Bottom bar yüksekliği
        items: const <Widget>[
          Icon(Icons.add, size: 30),
          Icon(Icons.home, size: 30),
          Icon(Icons.account_circle, size: 30),
        ],
        onTap: (index) {
          switch (index) {
            case 0: // Ekle butonuna basıldığında
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GonderiEklemeSayfasi(
                    onGonderiEkle: (yeniGonderi) {
                      setState(() {
                        gonderiler.add(yeniGonderi);
                      });
                    },
                  ),
                ),
              );
              break;
          // Diğer butonlara göre işlemler buraya eklenebilir
          }
        },
      ),
    );
  }
}
