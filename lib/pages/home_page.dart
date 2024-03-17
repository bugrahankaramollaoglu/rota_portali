import 'package:backpack_pal/auth.dart';
import 'package:backpack_pal/pages/sub_pages/home_screen.dart';
import 'package:backpack_pal/pages/sub_pages/settings_screen.dart';
import 'package:backpack_pal/pages/sub_pages/stats_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

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
      _selectedIndex = index;
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
        items: <Widget>[
          Icon(Icons.route_rounded, size: 30),
          Icon(Icons.home, size: 30),
          Icon(Icons.settings_rounded, size: 30),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              setState(() {
                _selectedIndex = 0;
              });
            case 1:
              setState(() {
                _selectedIndex = 1;
              });
            case 2:
              setState(() {
                _selectedIndex = 2;
              });

              break;
            // Diğer butonlara göre işlemler buraya eklenebilir
          }
        },
      ), /* Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width *
                0.8, // Adjust the width as needed
            child: const Divider(
              height: 2,
              thickness: 2,
              color: Colors.black, // Adjust color as needed
            ),
          ),
          BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.route_rounded, size: 30),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded, size: 30),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_rounded, size: 30),
                label: '',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            // showSelectedLabels: false, // Hide labels for selected items
            showUnselectedLabels: false, // Hide labels for unselected items
          ),
        ],
      ), */
    );
  }
}
