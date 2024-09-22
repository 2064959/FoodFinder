import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal/main.dart';

class AuthFormWidget extends StatefulWidget {
  const AuthFormWidget({super.key});

  @override
  State<AuthFormWidget> createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  AppState? appState;
  final _formKey = GlobalKey<FormState>();
  final _passwordField = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool _isLogin = true;
  String _userEmail = "";
  String _userName = "";
  String _userPassword = "";
  
  @override
  void initState() {
    super.initState();
    appState = Provider.of<AppState>(context, listen: false);
  }


  void _submit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid ?? false) {
      _formKey.currentState?.save();

      if (kDebugMode) {
        print(_userEmail);
        print(_userName);
      print(_userPassword);
      }
      
    }
    _submitAuthForm(
      _userEmail.trim(),
      _userPassword.trim(),
      _userName.trim(),
      _isLogin
    );
  }

  void _submitAuthForm(String email, String password, String username, bool isLogin) async {
    // ignore: unused_local_variable
    UserCredential? authResult;
      // Show loading indicator or perform any pre-submit logic
      if (isLogin) {
        try {
          // Sign in
          authResult = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        } on FirebaseAuthException catch (e) {
          var message = "An error occurred.";

          // Customize sign in the error message based on specific exceptions
          if (e.code == 'user-not-found') {
            message = 'No user found for that email.';
          } else if (e.code == 'wrong-password') {
            message = 'Wrong password provided for that user.';
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
      } else {
        try {
        // Register a new user
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ).then((value) {
          FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set({
            'username': username,
            'email': email,
          });
          appState?.signup(value);
          return value;
        });
        } on FirebaseAuthException catch (e) {
          var message = "An error occurred.";

          // Customize sign up the error message based on specific exceptions
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
      }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 8),
                child: Text(
                  "Email",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.035),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
              child: TextFormField(
                key: const ValueKey("email"),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                validator: (val) {
                  if (val!.isEmpty || val.length < 8) {
                    return 'Au moins 7 caracteres.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _userEmail = value!;
                },
              ),
            ),
            if (!_isLogin) ...[
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 8),
                  child: Text(
                    "Username",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
                child: TextFormField(
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                  key: const ValueKey("username"),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Au moins 7 caracteres.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userName = value!;
                  },
                ),
              ),
            ],
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
                child: Text(
                  "Password",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.035),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
              child: TextFormField(
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                key: const ValueKey("password"),
                obscureText: true,
                validator: (val) {
                  if ((val!.isEmpty || val.length < 8) && !_isLogin) {
                    return 'Au moins 7 caracteres.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _userPassword = value!;
                },
                
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (() {
                  _submit();
                  _formKey.currentState!.reset();
                }),
                child: Text(_isLogin ? "Sign in" : "Sign up",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035)),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(
                _isLogin ? "Create new account" : "I have an account",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035),
              ),
            ),
          ]),
        ),
      )),
    ));
  }
}
