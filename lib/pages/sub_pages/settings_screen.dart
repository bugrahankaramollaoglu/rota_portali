import 'package:backpack_pal/pages/login_page.dart';
import 'package:backpack_pal/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings_Screen extends StatefulWidget {
  const Settings_Screen({super.key});

  // final Function(bool) onThemeChanged;

  @override
  State<Settings_Screen> createState() => _Settings_ScreenState();
}

class _Settings_ScreenState extends State<Settings_Screen> {
  bool themeFlag = false;
  bool notificationFlag = false;

  @override
  void initState() {
    super.initState();
    // Load theme preference when the screen initializes
    setState(() {
      // themeFlag = loadShared('theme-key') as bool;
      // notificationFlag = loadShared('notification-key') as bool;
    });
  }

  // Future<void> loadThemePreference() async {
  //   // Retrieve theme preference from shared preferences
  //   bool themePreference = await loadShared('theme-key');
  //   setState(() {
  //     themeFlag = themePreference;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(30, 50, 50, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Aligns children to the start and end of the row
            children: [
              Text(
                'Settings',
                style: GoogleFonts.luckiestGuy(
                  fontSize: 28,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.person, // Choose the icon from Icons class
                  size: 45, // Set the size of the icon
                  color: Colors.black, // Optionally set the color of the icon
                ),
                onPressed: () {
                  // Add your onPressed callback here
                  print('Icon pressed');
                },
              ),
            ],
          ),
        ),

        /*  IconButton(
                icon: Icon(
                  Icons
                      .person_outline_rounded, // Choose the icon from Icons class
                  size: 45, // Set the size of the icon
                  color: Colors.black, // Optionally set the color of the icon
                ),
                onPressed: () {
                  // Add your onPressed callback here
                  print('Icon pressed');
                },
              ), */
        _divider(),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                'CHOOSE A THEME',
                style: GoogleFonts.roboto(fontSize: 20),
              ),
            ),
            const SizedBox(width: 30),
            _themeSwitch(),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                'SET NOTIFICATIONS',
                style: GoogleFonts.roboto(fontSize: 20),
              ),
            ),
            const SizedBox(width: 10),
            _notificationSwitch(),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                'RESET STATISTICS',
                style: GoogleFonts.roboto(fontSize: 20),
              ),
            ),
            const SizedBox(width: 30),
            GestureDetector(
              onTap: () {
                print("Button tapped");
              },
              child: Image.asset(
                'assets/reset_button.png',
                width: 60,
                height: 60,
              ),
            ),
          ],
        ),
        const SizedBox(height: 280),
        _logoutButton(),
      ],
    );
  }

  Widget _logoutButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 25, 18, 0),
      child: ElevatedButton(
        onPressed: showLogoutConfirmationDialog,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
        ),
        child: Text(
          'Log Out',
          style: GoogleFonts.luckiestGuy(
            fontSize: 20,
            textStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void show_add_dialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Dikkat",
            style: GoogleFonts.luckiestGuy(fontSize: 30),
          ),
          content: Text("Bu rotayı eklemek istiyor musunuz?",
              style: GoogleFonts.ubuntuCondensed(fontSize: 20)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                print('hayır dedin');

                Navigator.of(context).pop();
              },
              child: GFButton(
                text: "Hayır",
                textStyle: TextStyle(
                  fontFamily: GoogleFonts.luckiestGuy().fontFamily,
                  color: Colors.black,
                ),
                color: Colors.red,
                onPressed: () {
                  print('hayır dedin2');
                  Navigator.of(context).pop(); // Dismiss dialog
                },
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Perform action for "Evet" button here
              },
              child: GFButton(
                text: "Evet",
                textStyle: TextStyle(
                  fontFamily: GoogleFonts.luckiestGuy().fontFamily,
                  color: Colors.black,
                ),
                color: Colors.green,
                onPressed: () {
                  // storeRouteInFirestore();

                  Navigator.of(context).pop(); // Dismiss dialog
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "WARNING",
            style: GoogleFonts.luckiestGuy(fontSize: 30),
          ),
          content: Text("Çıkış yapmak istediğinizden emin misiniz?",
              style: GoogleFonts.ubuntuCondensed(fontSize: 20)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Perform action for "Evet" button here
              },
              child: GFButton(
                text: "Hayır",
                textStyle: TextStyle(
                  fontFamily: GoogleFonts.luckiestGuy().fontFamily,
                  color: Colors.black,
                ),
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss dialog
                },
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: GFButton(
                text: "Evet",
                textStyle: TextStyle(
                  fontFamily: GoogleFonts.luckiestGuy().fontFamily,
                  color: Colors.black,
                ),
                color: Colors.green,
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss dialog
                  logout();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const LoginPage()), // Replace LoginPage with your actual login page
    );
  }

  Widget _themeSwitch() => Transform.scale(
        scale: 1.5,
        child: Switch(
          trackColor: MaterialStateProperty.all(Colors.black38),
          activeColor: Colors.grey.withOpacity(0.4),
          inactiveThumbColor: Colors.black.withOpacity(0.5),
          activeThumbImage: const AssetImage('assets/sun.png'),
          inactiveThumbImage: const AssetImage('assets/night.png'),
          value: themeFlag,
          onChanged: (value) async {
            setState(() {
              themeFlag = value;
            });

            // Save theme preference to shared preferences
            await saveShared('theme-key', value);
            // widget.onThemeChanged(value); // Notify the callback function
          },
        ),
      );

  Widget _notificationSwitch() => Transform.scale(
        scale: 1.5,
        child: Switch(
          trackColor: MaterialStateProperty.all(Colors.black38),
          activeColor: Colors.grey.withOpacity(1),
          inactiveThumbColor: Colors.grey.withOpacity(1.0),
          activeThumbImage: const AssetImage('assets/no_notification.png'),
          inactiveThumbImage: const AssetImage('assets/notification.png'),
          value: notificationFlag,
          onChanged: (value) => setState(() => notificationFlag = value),
        ),
      );

  Widget _divider() {
    return const SizedBox(
      width: 250,
      child: Divider(
        thickness: 1,
        color: Colors.black,
      ),
    );
  }
}
