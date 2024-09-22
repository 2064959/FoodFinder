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
import 'package:tpfinal/themes/green_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tpfinal/firebase_options.dart';
import 'package:tpfinal/util/back_up_database.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as openfoodfacts;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);


  // OpenFoodFacts API configuration
  OpenFoodAPIConfiguration.userAgent = UserAgent(name: 'easyGrocery');
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
      ],
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: pinkTheme(),
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
      return const LoadingScreen();
    }

    return Scaffold(
      body: StreamBuilder<firebase_auth.User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }

          if (snapshot.hasError) {
            return const ErrorScreen();
          }

          if (snapshot.hasData) {
            return const Welcome();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
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
  

  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool get isInitialized => _isInitialized;

  AppState() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _fetchPopularProducts(15);
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _handleError('Initialization Error', e);
    }
  }

  Future<void> _handleLogin(firebase_auth.User firebaseUser) async {
    // TODO: Handle user login
  }


  Future<void> _handleLogout() async {
    // TODO: Handle user logout
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
    } catch (e) {
      _handleError('Sign Out Error', e);
    }
  }

  Future<void> _fetchPopularProducts(int nbItem) async {
    final configuration = ProductSearchQueryConfiguration(
      parametersList: <Parameter>[
        const SortBy(option: SortOption.POPULARITY),
        PageSize(size: nbItem),
      ],
      version: ProductQueryVersion.v3,
    );
    
    try {
      SearchResult result = await OpenFoodAPIClient.searchProducts(
        const openfoodfacts.User(userId: '', password: ''),
        configuration,
      );

      if (result.products != null && result.products!.isNotEmpty) {
        await _dbHelper.insertProducts(result.products!);
      }
      notifyListeners();
    } catch (e) {
      _handleError('Error fetching popular products', e);
    }
  }

  void _handleError(String message, dynamic error) {
    if (kDebugMode) {
      print('$message: $error');
    }
    // You can add more error handling logic here, like sending errors to a server or showing a UI dialog
  }
}