import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart' as stylish;
import 'package:tpfinal/pages/home.dart';
import 'package:tpfinal/pages/items.dart';
import 'package:tpfinal/pages/qr_scanner_page.dart';
import 'package:tpfinal/pages/your_goceries.dart';
import 'package:tpfinal/util/create_route.dart';
import 'package:tpfinal/widgets/side_menu.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final _pageController = PageController(initialPage: 0);

  var _vueCourrante = 0;
  @override
  Widget build(BuildContext context) {

    final List<Widget> bottomBarPages = <Widget>[
      const Home(),
      const YourGoceries(),
      const Items(),
    ];


    
    return Scaffold(
      
      backgroundColor: Theme.of(context).primaryColor,
      drawer: Drawer(
        backgroundColor: Theme.of(context).primaryColor,
        child: const SideMenu(),
      ),

      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
                },
            );
          },
        ),
        centerTitle: false,
        title:  const AppTitle(),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            onPressed: () {
              Navigator.of(context).push(createRoute(const QRScannerPage()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: List.generate(bottomBarPages.length, (index) => bottomBarPages[index]),
          onPageChanged: (index) {
            setState(() {
              _vueCourrante = index;
            });
          },
        ),
      ),
      extendBody: true,
      bottomNavigationBar: stylish.StylishBottomBar(
        elevation: 0,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,

        option: stylish.AnimatedBarOptions(
          iconSize: 22,
          barAnimation: stylish.BarAnimation.fade,
          iconStyle: stylish.IconStyle.animated,
          opacity: 0.3,

        ),
        items: [
          stylish.BottomBarItem(
            icon: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            selectedIcon: const Icon(Icons.home),
            
          ),
          stylish.BottomBarItem(
            icon: Icon(Icons.six_k_plus_sharp, color: Theme.of(context).bottomNavigationBarTheme.backgroundColor),
            title: const Text('Your Groceries'),
            selectedIcon: const Icon(Icons.safety_divider),
            
          ),
          stylish.BottomBarItem(
            icon: const Icon(Icons.add_shopping_cart_outlined),
            title: const Text('Items'),
            selectedIcon: const Icon(Icons.add_shopping_cart),
          ),
          
        ],
        hasNotch: true,
        currentIndex: _vueCourrante,
        onTap: (index) {
          setState(() {
            _vueCourrante = index;
            _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        onPressed: () {
          setState(() {
            _vueCourrante = 1;
            _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.ease);
          });
        },
        child: (_vueCourrante == 1) ?
          const Icon(
            Icons.shopping_basket,
            color: Colors.white,
          )
          :
          const Icon(
          Icons.shopping_basket_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}

class AppTitle extends StatelessWidget {
  const AppTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        Image(
          image: const AssetImage("assets/images/easyGrocery_logo.png"),
          height: MediaQuery.of(context).size.height * 0.045 ,
        ),
        
        Container(
          padding: const EdgeInsets.only(left: 5),
          child: const Column(
            children: [
              Row(
                children: [
                  Text(
                    "e",
                    style: TextStyle(
                      color: Color(0xFF00AD48),
                      fontSize: 19,
                    ),
                  
                  ),
                  Text(
                    "asyGrocery",
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
              Text(
                "We make your life easier",
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      
      ],
    );
  }
}



class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(),
      body: Center(
        child: FutureBuilder<String>(
          future: scanQR(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Error scanning QR code');
            } else {
              return Text(snapshot.data ?? 'No result');
            }
          },
        ),
      ),
    );

    
  }

  Future<String> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (kDebugMode) {
        print(barcodeScanRes);
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    return barcodeScanRes;
  }
}