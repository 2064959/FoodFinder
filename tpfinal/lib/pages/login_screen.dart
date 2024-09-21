import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tpfinal/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  void _submitAuthForm(
  String email,
  String password,
  String username,
  bool isLogin,
) async {
  UserCredential? authResult;

  try {
    // Show loading indicator or perform any pre-submit logic
    if (isLogin) {
      // Sign in
      _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } else {
      // Register a new user
      _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
  } on FirebaseAuthException catch (e) {
    var message = "An error occurred.";

    // Customize the error message based on specific exceptions
    if (e.code == 'email-already-in-use') {
      message = 'This email is already in use.';
    } else if (e.code == 'weak-password') {
      message = 'The password is too weak.';
    } else if (e.code == 'invalid-email') {
      message = 'The email address is invalid.';
    } else if (e.message != null) {
      message = e.message!;
    }

    // Check if the widget is mounted before using context
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  } catch (err) {
    if (kDebugMode) {
      print("Unhandled error: $err");
    }
  }
  
  if (!isLogin) {
    try {
      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
        'username': username,
        'email': email,
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error saving user data: $e");
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/bloc-notes.png',
                        width: MediaQuery.of(context).size.width,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 135),
                        alignment: Alignment.center,
                        child: RotationTransition(
                          turns: const AlwaysStoppedAnimation(-11 / 360),
                          child: Text("YourGroceries",
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width / 8,
                                fontFamily: 'OoohBaby',
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.22),
                        alignment: Alignment.center,
                        child: RotationTransition(
                          turns: const AlwaysStoppedAnimation(-11 / 360),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.55,
                            child: Text("•  Bread",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 11,
                                  fontFamily: 'OoohBaby',
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.28),
                        alignment: Alignment.center,
                        child: RotationTransition(
                          turns: const AlwaysStoppedAnimation(-11 / 360),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.65,
                            child: Text("•  Apple juice 2x",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 11,
                                  fontFamily: 'OoohBaby',
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.34),
                        alignment: Alignment.center,
                        child: RotationTransition(
                          turns: const AlwaysStoppedAnimation(-11 / 360),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.75,
                            child: Text("•  Orange juice",
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 11,
                                  fontFamily: 'OoohBaby',
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AuthFormWidget(
                  _submitAuthForm,
                ),
              ],
            ),
          ),
        ));
  }
}
