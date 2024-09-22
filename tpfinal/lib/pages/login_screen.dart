import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal/main.dart';
import 'package:tpfinal/widgets/auth_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AppState? appState;
  
  @override
  void initState() {
    super.initState();
    appState = Provider.of<AppState>(context, listen: false);
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
                const AuthFormWidget(),
              ],
            ),
          ),
        ));
  }
}
