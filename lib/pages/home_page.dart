import 'package:rota_portali/auth.dart';
import 'package:rota_portali/pages/sub_pages/home_screen.dart';
import 'package:rota_portali/pages/sub_pages/settings_screen.dart';
import 'package:rota_portali/pages/sub_pages/stats_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex =
      1; // Başlangıçta ana sayfa butonunu göstermek için _selectedIndex 1 olarak ayarlandı

  static final List<Widget> _widgetOptions = <Widget>[
    const Stats_Screen(),
    const Home_Screen(),
    const Settings_Screen(),
  ];

  Future<void> signOut() async {
    await Auth().signOut();
  }

  // Widget _userUid() {
  //   return Text(user?.email ?? 'User email');
  // }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sıgn Out'),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex =
          index; // Seçilen elemanın endeksini _selectedIndex değişkenine atar
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.deepPurple, // Arka plan rengi
        color: Colors.white, // Icon renkleri
        buttonBackgroundColor: Colors.deepPurple[100], // Buton rengi
        height: 60, // Bottom bar yüksekliği
        items: const <Widget>[
          Icon(Icons.route_rounded, size: 30),
          Icon(Icons.home, size: 30),
          Icon(Icons.settings_rounded, size: 30),
        ],
        index: 1, // Başlangıçta seçili olan elemanın endeksini belirtir
        onTap:
            _onItemTapped, // onTap olayını _onItemTapped fonksiyonuyla bağlar
      ),
    );
  }
}
