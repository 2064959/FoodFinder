import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal/database_helper.dart';
import 'package:tpfinal/model/user.dart';
import 'package:tpfinal/pages/add_items.dart';
import 'package:tpfinal/pages/add_to_grocery.dart';
import 'package:tpfinal/pages/login_screen.dart';
import 'package:tpfinal/pages/welcome.dart';
import 'package:tpfinal/repositories/product_repository.dart' as repositories;
import 'package:tpfinal/themes/green_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tpfinal/firebase_options.dart';
import 'package:tpfinal/util/back_up_database.dart';
import 'package:tpfinal/providers/product_provider.dart';




final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up global error handling
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Platform Error: $error');
    return true;
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 80),
              const SizedBox(height: 24),
              const Text(
                'Oops! Something went wrong',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              const Text(
                'An unexpected error occurred in the application. Please restart or try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  // Attempt recovery or just notify
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    const SnackBar(content: Text('Attempting to recover... Please wait.')),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00AD48),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  };

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);


  // OpenFoodFacts API configuration
  OpenFoodAPIConfiguration.userAgent = UserAgent(name: 'FoodFinder');
  OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
    OpenFoodFactsLanguage.ENGLISH,
    OpenFoodFactsLanguage.FRENCH,
  ];
  OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.CANADA;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyGroceries()),
        ChangeNotifierProvider(create: (context) => MyItemss()),
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
      ],
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'FoodFinder',
            scaffoldMessengerKey: scaffoldMessengerKey,
            theme: foodFinderTheme(),
            home: const MyHomePage() ,
            routes: {
              AddItems.routeName: (context) => const AddItems(),
              AddToGrocery.routeName: (context) => const AddToGrocery(),
            },
          );
        },
      ),
    );
  }
}


class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    if (!appState.isInitialized) {
      return const SplashScreen();
    }

    if (appState.connectedUserUid.isNotEmpty) {
      return const Welcome();
    } else {
      return const LoginScreen();
    }
  }
}

// Reusable widgets for better code readability and DRY principle

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 50),
            SizedBox(height: 10),
            Text('Something went wrong!', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  bool _isInitialized = false;
  String _connectedUserUid = '';
  StreamSubscription<firebase_auth.User?>? _authSubscription;
  

  final DatabaseHelper _dbHelper = DatabaseHelper();

  AppState() {
    _authSubscription = firebase_auth.FirebaseAuth.instance.authStateChanges().listen((user) {
      _initialize(user);
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  bool get isInitialized => _isInitialized;
  String get connectedUserUid => _connectedUserUid;

  set connectedUserUid(String uid) {
    _connectedUserUid = uid;
    notifyListeners();
  }

  Future<void> _initialize(firebase_auth.User? firebaseUser) async {
    try {
      if (firebaseUser != null) {
        await _handleLogin(firebaseUser);
      } else {
        await _handleLogout();
      }
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _handleError('Initialization Error', e);
    }
  }

  Future<void> _handleLogin(firebase_auth.User firebaseUser) async {
    // TODO: Handle user login
    connectedUserUid = firebaseUser.uid;
    bool exist = await _dbHelper.isUserExist(firebaseUser.uid);
    if (!exist) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();
        String userName = (userDoc.data() as Map<String, dynamic>)['username'] ?? 'No username';

        UserModel userModel = UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email!,
          username: userName,
        );

        await _dbHelper.insertUser(userModel);
      } catch (e) {
        _handleError('User login error: ', e);
      }
    }

  }


  Future<void> _handleLogout() async {
    // TODO: Handle user logout
    connectedUserUid = '';
  }

  Future<void> signup(UserCredential value) async
  {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(value.user!.uid).get();
      String userName = (userDoc.data() as Map<String, dynamic>)['username'] ?? 'No username';

      UserModel userModel = UserModel(
        uid: value.user!.uid,
        email: value.user!.email!,
        username: userName,
      );

      await _dbHelper.insertUser(userModel);
    } catch (e) {
      _handleError('Sign up error: ', e);
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      _isInitialized = false;
      notifyListeners();
    } catch (e) {
      _handleError('Sign Out Error', e);
    }
  }



  void _handleError(String message, dynamic error) {
    if (kDebugMode) {
      print('$message: $error');
    }
    
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('$message: ${error.toString()}'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

}