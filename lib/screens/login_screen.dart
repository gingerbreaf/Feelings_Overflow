import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:feelings_overflow/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:feelings_overflow/design/round_buttons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:feelings_overflow/constants.dart';
import 'package:feelings_overflow/screens/Home.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  late UserCredential user;
  bool showSpinner = false;
  String errorText = '';

  late AnimationController controller;



  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: DecoratedBox(
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/loginpage.jpg"),
                  fit: BoxFit.cover,
                )
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'logo',
                        child: Container(
                          height: 200,
                          child: const FittedBox(
                            child: Image(
                                image: AssetImage('assets/images/AppIcon.png'),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                          child: AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                    'First Step to the Diary',
                                    textStyle: GoogleFonts.pacifico(
                                      fontSize: 50.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                ),
                                TypewriterAnimatedText(
                                    'Login Page',
                                    textStyle: GoogleFonts.pacifico(
                                      fontSize: 70.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                ),
                              ],
                          ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                    child: Text(
                      errorText,
                    ),
                  ),
                  TextField(
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      //Do something with the user input.
                      email = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.center,
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                        //Do something with the user input.
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your password',
                        filled: true,
                        fillColor: Colors.white,
                      )

                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  RoundedButton(
                    title: 'Log In',
                    color: Colors.lightBlueAccent,
                    onPress: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        user = await _auth.signInWithEmailAndPassword(
                            email: email,
                            password: password);
                        if (user != null ) {
                          Navigator.pushNamed(context, Home.id);
                        }
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    },
                  ),
                  Flexible(
                    child: RoundedButton(
                      title: 'Register',
                      color: Colors.lightBlueAccent,
                      onPress: () async {
                        setState(() {
                          Navigator.pushNamed(context, RegistrationScreen.id);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


