import 'package:backpack_pal/pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings_Screen extends StatefulWidget {
  const Settings_Screen({super.key});

  @override
  _Settings_ScreenState createState() => _Settings_ScreenState();
}

class _Settings_ScreenState extends State<Settings_Screen> {
  ThemeMode _themeMode = ThemeMode.light;
  final bool _notificationMode = true;

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
        title: const Text('Ayarlar'),
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
            Center(child: _divider()),
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
            Center(child: _divider()),
            ListTile(
              leading: const Icon(Icons.person_2_outlined),
              title: const Text(
                'Profil',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                // Add navigation logic here
              },
            ),
            Center(child: _divider()),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: const Text(
                'İstatistikleri Sıfırla',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                showResetStatsAlert();
              },
            ),
            Center(child: _divider()),
            ListTile(
              leading: const Icon(Icons.exit_to_app_outlined),
              title: const Text(
                'Çıkış Yap',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                // Add sign out logic here
                showLogoutAlert();
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

// Function to get the email of the current user
  Future<String?> getUserEmail() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    if (user != null) {
      String email = user.email!;
      return email;
    } else {
      return null; // No user signed in
    }
  }

  void showResetStatsAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "DİKKAT",
            style: GoogleFonts.luckiestGuy(),
          ),
          content: Text(
            "Bu kullanıcının tüm rotalarını silmek istediğinizden emin misiniz?",
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
                onPressed: () async {
                  String? userEmail = await getUserEmail();
                  if (userEmail != null) {
                    removeRoutes(userEmail);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void logOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut(); // Sign out the current user
    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 270,
        height: 1, // Thickness of the divider
        color: Colors.black, // Color of the divider
      ),
    );
  }

  Future<void> removeRoutes(String email) async {
    // Get a reference to the Firestore collection
    CollectionReference routes =
        FirebaseFirestore.instance.collection('routes');

    // Query documents where "fromWhom" field matches the provided email
    QuerySnapshot querySnapshot =
        await routes.where('fromWhom', isEqualTo: email).get();

    // Iterate through the documents and delete them
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }
}
