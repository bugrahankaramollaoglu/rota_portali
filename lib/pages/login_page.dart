import 'package:rota_portali/auth.dart';
import 'package:rota_portali/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

      // If login is successful, navigate to HomePage and remove the login page from the stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      _showToast('Kayıt başarılı!.');
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
      _showToast('Kayıt işlemi yapılamadı..');
    }
  }

  Widget _googleButton() {
    return Center(
      child: TextButton(
        onPressed: () async {
          _showToast('google');
          final User? user = await _signInWithGoogle();
          if (user != null) {
            _showToast('Kayıt başarılı!');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else {
            _showToast('Google ile kayıt sağlanamadı.');
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.75),
              spreadRadius: 0.3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: title,
            labelStyle: const TextStyle(color: Color.fromARGB(255, 90, 85, 85)),
            suffixIcon: const Icon(Icons.email_rounded,
                color: Color.fromARGB(255, 90, 85, 85)),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.75),
              spreadRadius: 0.3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: title,
            labelStyle: const TextStyle(color: Color.fromARGB(255, 90, 85, 85)),
            suffixIcon:
                const Icon(Icons.lock, color: Color.fromARGB(255, 90, 85, 85)),
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
          backgroundColor: Colors.deepPurpleAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
        ),
        child: const Text(
          'Giriş',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
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
          'Hesabınız yok mu?\nKaydolun',
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
      padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
      child: Image.asset('assets/app_logo.png'),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox(
        width: 200,
        child: Divider(
          thickness: 2,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _appName() {
    return Container(
      child: const Text(
        'Rota Portalı.',
        style: TextStyle(
          fontSize: 40,
          fontFamily: 'Madimi',
        ),
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
              _entryFieldEmail('e-posta', _controllerEmail),
              _entryFieldPassword('şifre', _controllerPassword),
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
