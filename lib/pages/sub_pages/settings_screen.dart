import 'package:backpack_pal/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings_Screen extends StatefulWidget {
  const Settings_Screen({Key? key}) : super(key: key);

  @override
  _Settings_ScreenState createState() => _Settings_ScreenState();
}

class _Settings_ScreenState extends State<Settings_Screen> {
  ThemeMode _themeMode = ThemeMode.light;
  bool _notificationMode = true;

  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Text('Page 1'),
    Text('Page 2'),
    Text('Page 3'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayarlar'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text(
                'Temayı Değiştir',
                style: TextStyle(fontSize: 18),
              ),
              trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  setState(() {
                    _themeMode = value ? ThemeMode.dark : ThemeMode.light;
                  });
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text(
                'Bildirimler',
                style: TextStyle(fontSize: 18),
              ),
              trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  setState(() {
                    // _notificationMode = value ? null : null;
                  });
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: const Text(
                'İstatistikleri Sıfırla',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                // Add navigation logic here
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app_outlined),
              title: const Text(
                'Çıkış Yap',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                // Add sign out logic here
                showLogoutAlert();
                print('Cıksıss');
              },
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }

  void showLogoutAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "DİKKAT",
            style: GoogleFonts.luckiestGuy(),
          ),
          content: Text(
            "Çıkış yapmak istediğinizden emin misiniz?",
            style: GoogleFonts.roboto(fontSize: 20),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: null,
              child: GFButton(
                text: "Hayır",
                textStyle: TextStyle(
                  fontFamily: GoogleFonts.luckiestGuy().fontFamily,
                  color: Colors.black,
                ),
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            TextButton(
              onPressed: null,
              child: GFButton(
                text: "Evet",
                textStyle: TextStyle(
                  fontFamily: GoogleFonts.luckiestGuy().fontFamily,
                  color: Colors.black,
                ),
                color: Colors.green,
                onPressed: () {
                  logOut();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void logOut() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut(); // Sign out the current user
    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
