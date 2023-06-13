import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:feelings_overflow/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:feelings_overflow/design/round_buttons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:feelings_overflow/constants.dart';
import 'package:feelings_overflow/screens/DashBoard.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
          backgroundColor: Colors.white,
          elevation: 0,
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/loginpage.jpg"),
                        fit: BoxFit.cover,
                      )
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
                    child: Column(
                      //mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          //mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Hero(
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
                            ),
                            Flexible(
                              child: FittedBox(
                                child: AnimatedTextKit(
                                  animatedTexts: [
                                    TypewriterAnimatedText(
                                      'First Step to the Diary',
                                      textStyle: GoogleFonts.pacifico(
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TypewriterAnimatedText(
                                      'Login Page',
                                      textStyle: GoogleFonts.pacifico(
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
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
                            print(email);
                          },
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter your email',
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextField(
                            textInputAction: TextInputAction.next,
                            textAlign: TextAlign.center,
                            obscureText: true,
                            onChanged: (value) {
                              password = value;
                              print(password);
                              //Do something with the user input.
                            },
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Enter your password',
                              filled: true,
                              fillColor: Colors.white,
                            )

                        ),
                        const SizedBox(
                          height: 5.0,
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
                                Alert(
                                  context: context,
                                  type: AlertType.success,
                                  title: "Successful Login",
                                  desc: "Enjoy",
                                  buttons: [
                                    DialogButton(
                                      child: const Text(
                                        "Continue",
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pushNamed(context, DashBoard.id),
                                    ),
                                  ],
                                ).show();
                              }
                            } catch (e) {
                              print(e);
                              Alert(
                                context: context,
                                type: AlertType.error,
                                title: "Unsuccessful sign-in",
                                desc: "Invalid email or password",
                                buttons: [
                                  DialogButton(
                                    child: const Text(
                                      "Try again",
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ).show();
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          },
                        ),

                        RoundedButton(
                          title: 'Register',
                          color: Colors.lightBlueAccent,
                          onPress: () async {
                            setState(() {
                              Navigator.pushNamed(context, RegistrationScreen.id);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}