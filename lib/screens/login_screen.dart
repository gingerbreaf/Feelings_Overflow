import 'package:feelings_overflow/design/login_register_text_fields.dart';
import 'package:feelings_overflow/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:feelings_overflow/screens/DashBoard.dart';
import 'package:status_alert/status_alert.dart';
import 'package:feelings_overflow/functionality/firebase_methods.dart';

/// This is the UI for the Login Screen
class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String email = '';
  late String password = '';
  late UserCredential user;

  /// Whether to show a loading icon on the screen
  bool showSpinner = false;

  /// Displays user error message
  String errorText = '';

  /// Returns true if any field is still empty
  bool notAllFieldsFilled() {
    return (password == '') || (email == '');
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
                      'Welcome Back',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 52,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Continue jotting it down!',
                      style: TextStyle(fontSize: 16, color: Colors.black45),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: Text(
                      errorText,
                    ),
                  ),
                  LoginRegisterTextField(
                    hintText: 'Email',
                    obscure: false,
                    onChanged: (value) {
                      //Do something with the user input.
                      email = value;
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
                    },
                    email: false,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: () async {
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
                          user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (user != null) {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, DashBoard.id);
                          }
                        } on FirebaseAuthException catch (e) {
                          FirebaseMethods.errorHandlingLogin(e, context);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Not a member?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, RegistrationScreen.id);
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
