// ignore_for_file: prefer_const_constructors

import 'package:backpack_pal/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = authResult.user;
        return user;
      }
    } catch (error) {
      print(error);
      return null;
    }
    return null;
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text.trim(),
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _googleButton() {
    return Center(
      child: TextButton(
        onPressed: () async {
          final User? user = await _signInWithGoogle();
          if (user != null) {
            // Navigate to another screen after successful sign-in
          } else {
            // Handle sign-in failure
          }
        },
        child: Image.asset('assets/google.png', width: 50, height: 50),
      ),
    );
  }

  Widget _entryFieldEmail(
    String title,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 25),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.75),
              spreadRadius: 0.3,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: title,
            labelStyle: TextStyle(color: Color.fromARGB(255, 90, 85, 85)),
            // You can customize other properties like prefixIcon, suffixIcon, etc.
            // Example:
            // prefixIcon: Icon(Icons.email),
            suffixIcon: Icon(Icons.email_rounded,
                color: Color.fromARGB(255, 90, 85, 85)),
            // errorText: _validate ? 'Value Can\'t Be Empty' : null,
          ),
        ),
      ),
    );
  }

  Widget _entryFieldPassword(
    String title,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 25),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.75),
              spreadRadius: 0.3,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          obscureText: true, // Set obscureText to true
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: title,
            labelStyle: TextStyle(color: Color.fromARGB(255, 90, 85, 85)),
            // You can customize other properties like prefixIcon, suffixIcon, etc.
            // Example:
            // prefixIcon: Icon(Icons.email),logo
            suffixIcon:
                Icon(Icons.lock, color: Color.fromARGB(255, 90, 85, 85)),
            // errorText: _validate ? 'Value Can\'t Be Empty' : null,
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
      child: ElevatedButton(
        onPressed: signInWithEmailAndPassword,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurpleAccent, // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Button border radius
          ),
          elevation: 4, // Button elevation
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            fontSize: 18, // Text size
            fontWeight: FontWeight.bold, // Text weight
          ),
        ),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextButton(
        onPressed: createUserWithEmailAndPassword,
        child: const Text(
          'No account yet?\nRegister',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _appImage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 0, 35, 0), // Remove top padding
      child: Image.asset('assets/logo.png'),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 200, // Adjust the width as needed
        child: Divider(
          thickness: 2, // Set the thickness of the divider if needed
          color: Colors.black, // Set the color of the divider if needed
        ),
      ),
    );
  }

  Widget _appName() {
    return Container(
      child: Text(
        'rota.',
        style: GoogleFonts.arvo(fontSize: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepPurpleAccent,
                Colors.white,
              ],
            ),
          ),
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _appImage(),
              _appName(),
              const SizedBox(height: 20),
              _entryFieldEmail('email', _controllerEmail),
              _entryFieldPassword('password', _controllerPassword),
              _submitButton(),
              _loginOrRegisterButton(),
              _divider(),
              _googleButton(),
            ],
          ),
        ),
      ),
    );
  }
}
