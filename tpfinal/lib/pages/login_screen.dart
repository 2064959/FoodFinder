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
    // ignore: unused_local_variable
    UserCredential authResult;

    try {
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ).then((value) {
          FirebaseFirestore.instance
            .collection('users')
            .doc(value.user!.uid)
            .set({
              'username': username,
              'email': email,
            });
          return value;
        });
      }
    } on FirebaseException catch (e) {
      var message = "Un erreur s'est produite.";

      if (e.message != null) {
        message = e.message!;
      }

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (err) {
      if (kDebugMode) {
        print("Erreur non géré $err");
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
