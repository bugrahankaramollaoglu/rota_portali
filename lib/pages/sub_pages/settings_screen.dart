import 'package:rota_portali/pages/login_page.dart';
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
  String? userEmail = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.person_2_outlined),
              title: const Text(
                'Profil',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                showUserDialog();
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

  Future<String?> getUserEmail() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    if (user != null) {
      String email = user.email!;
      return email;
    } else {
      return null;
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
    await auth.signOut();

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
        height: 1,
        color: Colors.black,
      ),
    );
  }

  Future<void> removeRoutes(String email) async {
    CollectionReference routes =
        FirebaseFirestore.instance.collection('routes');

    QuerySnapshot querySnapshot =
        await routes.where('fromWhom', isEqualTo: email).get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<int> getDocumentCount(String email) async {
    CollectionReference routes =
        FirebaseFirestore.instance.collection('routes');

    QuerySnapshot querySnapshot =
        await routes.where('fromWhom', isEqualTo: email).get();

    return querySnapshot.size;
  }

  void showUserDialog() async {
    String? email = await getUserEmail();
    if (email != null) {
      setState(() {
        userEmail = email;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/avatars.png',
                    width: 270,
                    height: 250,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        userEmail!,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: GFButton(
                  text: "Tamam",
                  textStyle: TextStyle(
                    fontFamily: GoogleFonts.luckiestGuy().fontFamily,
                    color: Colors.black,
                  ),
                  color: Colors.blue,
                  onPressed: () async {
                    userEmail = await getUserEmail();
                    if (userEmail != null) {
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
  }
}
