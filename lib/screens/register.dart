import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:surgakicare/main.dart';
import 'package:surgakicare/screens/home.dart';
import 'package:surgakicare/screens/home_page.dart';
import 'package:surgakicare/screens/login.dart';
import 'package:surgakicare/tools/date_formatter.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();

    if (!snapshot.exists) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'nama': userCredential.user!.displayName!,
        'email': userCredential.user!.email!,
        'terdaftar': getCurrentDate(),
        'wishlists': [],
        'carts': [],
        'isAdmin': false,
      });
    }

    Get.off(() => StartScreen());
  }

  void _showErrorSnackbar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void doRegister(BuildContext context) async {
    if (namaController.text.trim().isEmpty) {
      _showErrorSnackbar(context, "Nama tidak boleh kosong");
      return;
    }
    if (emailController.text.trim().isEmpty) {
      _showErrorSnackbar(context, "Email tidak boleh kosong");
      return;
    }
    if (passwordController.text.trim().isEmpty) {
      _showErrorSnackbar(context, "Password tidak boleh kosong");
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      _showErrorSnackbar(
          context, "Password dan Password Konfirmasi tidak sama");
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String userId = userCredential.user?.uid ?? "";

      try {
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'nama': namaController.text.trim(),
          'email': emailController.text.trim(),
          'terdaftar': getCurrentDate(),
          'wishlists': [],
          'carts': [],
          'isAdmin': false,
        });

        print("Data successfully written to Firestore!");
      } catch (e) {
        print("Error writing to Firestore: $e");
      }

      Get.off(() => HomeScreen());
    } catch (e) {
      _showErrorSnackbar(context, "Registration Failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Surgaki Care',
          style: GoogleFonts.alegreyaSansSc(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 40,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color.fromARGB(255, 35, 46, 142),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 24,
              ),
              Text(
                'Daftar Akun',
                textAlign: TextAlign.start,
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: namaController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nama Lengkap',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Konfirmasi Password',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          doRegister(context);
                        },
                        child: Text(
                          'Daftar',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 52, 152, 219),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sudah punya akun? ",
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.off(() => LoginPage());
                    },
                    child: Text(
                      'Login',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Color.fromARGB(255, 52, 152, 219),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    style: TextButton.styleFrom(
                        // primary: Colors.blue,
                        ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(child: Divider()),
                    Text(
                      '   atau daftar menggunakan   ',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          signInWithGoogle();
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Image.network(
                                'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',
                                width: 25,
                                height: 25,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Google',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
