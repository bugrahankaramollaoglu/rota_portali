import 'package:backpack_pal/auth.dart';
import 'package:backpack_pal/pages/sub_pages/home_screen.dart';
import 'package:backpack_pal/pages/sub_pages/settings_screen.dart';
import 'package:backpack_pal/pages/sub_pages/stats_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    Stats_Screen(),
    Home_Screen(),
    Settings_Screen(),
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
      // extendBody: true,
      body: GradientBackground(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.white,
          ],
        ),
      ),
      child: child,
    );
  }
}



