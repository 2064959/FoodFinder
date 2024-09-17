import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal/pages/add_items.dart';
import 'package:tpfinal/pages/add_to_grocery.dart';
import 'package:tpfinal/pages/login_screen.dart';
import 'package:tpfinal/pages/welcome.dart';
import 'package:tpfinal/themes/green_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tpfinal/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tpfinal/util/back_up_database.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  OpenFoodAPIConfiguration.userAgent = UserAgent(name: 'easyGrocery');

  OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
    OpenFoodFactsLanguage. ENGLISH,
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
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: pinkTheme(),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
        routes: {
          AddItems.routeName: (context) => const AddItems(),
          AddToGrocery.routeName: (context) => const AddToGrocery(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Nous attendons l'initialisation
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        // Houston!!?
        if (snapshot.hasError) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: pinkTheme(),
            home: const MyHomePage(title: 'Flutter Demo Home Page'),
            routes: {
              AddItems.routeName: (context) => const AddItems(),
              AddToGrocery.routeName: (context) => const AddToGrocery(),
            },
          );
        }

        // L'application peut démarrer
        return MaterialApp(
          title: 'Flutter Demo',
          theme: pinkTheme(),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const Welcome();
              }

              return const LoginScreen();
            },
          ),
          routes: {
            AddItems.routeName: (context) => const AddItems(),
            AddToGrocery.routeName: (context) => const AddToGrocery(),
          },
        );
      },
    );
  }
}
