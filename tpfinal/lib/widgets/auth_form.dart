import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthFormWidget extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
  ) _submitForm;
  const AuthFormWidget(this._submitForm, {Key? key}) : super(key: key);

  @override
  State<AuthFormWidget> createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  final _key = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = "";
  String _userName = "";
  String _userPassword = "";

  void _submit() {
    final isValid = _key.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid ?? false) {
      _key.currentState?.save();

      if (kDebugMode) {
        print(_userEmail);
        print(_userName);
      print(_userPassword);
      }
      
    }
    widget._submitForm(
      _userEmail.trim(),
      _userPassword.trim(),
      _userName.trim(),
      _isLogin,
    );
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
          key: _key,
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
                  if (val!.isEmpty || val.length < 8) {
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
