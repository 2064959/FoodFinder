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
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    appState = Provider.of<AppState>(context, listen: false);
  }

  void _showError(String message) {
    scaffoldMessengerKey.currentState?.clearSnackBars();
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid ?? false) {
      _formKey.currentState?.save();
      _submitAuthForm(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _isLogin
      );
    }
  }

  void _submitAuthForm(String email, String password, String username, bool isLogin) async {
    setState(() => _isLoading = true);
    
    try {
      UserCredential? authResult;
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        await FirebaseFirestore.instance.collection('users').doc(authResult.user!.uid).set({
          'username': username,
          'email': email,
        });
        
        if (appState != null) {
          await appState!.signup(authResult);
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = "An error occurred.";
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else if (e.code == 'email-already-in-use') {
        message = 'This email is already registered.';
      } else if (e.message != null) {
        message = e.message!;
      }
      _showError(message);
    } catch (err) {
      _showError("An unexpected error occurred: $err");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
                    hintText: "example@email.com",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                validator: (val) {
                  if (val == null || val.isEmpty || !val.contains('@') || !val.contains('.')) {
                    return 'Please enter a valid email address.';
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
                    if (val == null || val.isEmpty || val.length < 4) {
                      return 'Username must be at least 4 characters.';
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
                  if (val == null || val.isEmpty || val.length < 6) {
                    return 'Password must be at least 6 characters.';
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
                onPressed: _isLoading ? null : _submit,
                child: _isLoading 
                  ? const SizedBox(
                      height: 20, 
                      width: 20, 
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                    )
                  : Text(_isLogin ? "Sign in" : "Sign up",
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
