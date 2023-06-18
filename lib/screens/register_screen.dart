import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feelings_overflow/design/round_buttons.dart';
import 'package:feelings_overflow/screens/login_screen.dart';
import 'DashBoard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:feelings_overflow/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:status_alert/status_alert.dart';
import 'package:feelings_overflow/design/login_register_text_fields.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email = '';
  late String password = '';
  late String confirmPassword = '';
  late String username = '';
  bool showSpinner = false;

  bool passwordConfirmed() {
    return password == confirmPassword;
  }

  bool notAllFieldsFilled() {
    return (password == '') || (username == '' || email == '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Stack(children: [
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 70,
                  ),
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: MediaQuery.of(context).size.height / 5,
                      //height: 200,
                      child: const FittedBox(
                        child: Image(
                          image: AssetImage('assets/images/AppIcon.png'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: Text(
                      'Hello There',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 52,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Register below with your details!',
                      style: TextStyle(fontSize: 16, color: Colors.black45),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  LoginRegisterTextField(
                    hintText: 'Email',
                    obscure: false,
                    onChanged: (value) {
                      //Do something with the user input.
                      email = value;
                      print(email);
                    },
                    email: true,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  LoginRegisterTextField(
                    hintText: 'Password',
                    obscure: true,
                    onChanged: (value) {
                      //Do something with the user input.
                      password = value;
                      print(password);
                    },
                    email: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  LoginRegisterTextField(
                    hintText: 'Confirm Password',
                    obscure: true,
                    onChanged: (value) {
                      //Do something with the user input.
                      confirmPassword = value;
                      print(confirmPassword);
                    },
                    email: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  LoginRegisterTextField(
                    hintText: 'Username',
                    obscure: false,
                    onChanged: (value) {
                      username = value;
                    },
                    email: false,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (!passwordConfirmed()) {
                          StatusAlert.show(
                            context,
                            duration: const Duration(seconds: 1),
                            title: 'Passwords does not match',
                            configuration:
                                const IconConfiguration(icon: Icons.close),
                            maxWidth: 260,
                          );
                          return;
                        }
                        if (notAllFieldsFilled()) {
                          StatusAlert.show(
                            context,
                            duration: const Duration(seconds: 1),
                            title: 'Please fill in your particulars',
                            configuration:
                                const IconConfiguration(icon: Icons.close),
                            maxWidth: 260,
                          );
                          return;
                        }
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          if (newUser != null) {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(_auth.currentUser!.uid)
                                .set({'username': username});
                            StatusAlert.show(
                              context,
                              duration: Duration(seconds: 1),
                              title: 'You are registered!',
                              configuration:
                                  IconConfiguration(icon: Icons.done),
                              maxWidth: 260,
                            );
                            late UserCredential user;
                            user = await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            if (user != null) {
                              Navigator.pushNamed(context, DashBoard.id);
                            }
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'network-request-failed') {
                            StatusAlert.show(
                              context,
                              duration: const Duration(seconds: 1),
                              title: 'No Internet Connection',
                              configuration:
                                  const IconConfiguration(icon: Icons.warning),
                              maxWidth: 260,
                            );
                          } else if (e.code == 'email-already-in-use') {
                            StatusAlert.show(
                              context,
                              duration: const Duration(seconds: 1),
                              title: 'Email already in use',
                              configuration:
                                  const IconConfiguration(icon: Icons.close),
                              maxWidth: 260,
                            );
                          } else if (e.code == 'invalid-email') {
                            StatusAlert.show(
                              context,
                              duration: const Duration(seconds: 1),
                              title: 'Invalid email',
                              configuration:
                                  const IconConfiguration(icon: Icons.close),
                              maxWidth: 260,
                            );
                          } else if (e.code == 'weak-password') {
                            StatusAlert.show(
                              context,
                              duration: const Duration(seconds: 3),
                              title: 'Weak Password',
                              subtitle: 'Passwords needs at least 6 characters',
                              configuration:
                                  const IconConfiguration(icon: Icons.close),
                              maxWidth: 500,
                              dismissOnBackgroundTap: true,
                            );
                          } else {
                            StatusAlert.show(
                              context,
                              duration: const Duration(seconds: 1),
                              title: 'Unknown Error',
                              configuration:
                                  const IconConfiguration(icon: Icons.close),
                              maxWidth: 300,
                            );
                          }
                          // Catching exceptions causes by using the firebase method
                          print(e);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already a member?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        child: const Text(
                          'Login here',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
