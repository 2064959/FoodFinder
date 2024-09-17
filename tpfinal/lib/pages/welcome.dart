import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/helpers/enums.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart' as stylish;

import 'package:tpfinal/pages/home.dart';
import 'package:tpfinal/pages/items.dart';
import 'package:tpfinal/pages/your_goceries.dart';
import 'package:tpfinal/widgets/home/sign_out.dart';
import 'package:tpfinal/widgets/pop_up/pop_up.dart';
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
        centerTitle: true,
        title:  const AppTitle(),
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
            _pageController.jumpToPage(index);
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        onPressed: () {
          setState(() {
            _vueCourrante = 1;
            _pageController.jumpToPage(1);
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
      children: [
        
        Image(
          image: const AssetImage("assets/images/easyGrocery_vert.png"),
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

