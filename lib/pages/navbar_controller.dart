import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mezgebestore/pages/cart.dart';
import 'package:mezgebestore/pages/home.dart';
import 'package:mezgebestore/pages/profile.dart';
import 'package:mezgebestore/pages/shop.dart';

class BottomNavigationBarController extends StatefulWidget {
  int selectedIndex = 0;
  BottomNavigationBarController({this.selectedIndex});

  static const String id = 'nav_screen';

  final List<Widget> pages = [
    Home(
      key: PageStorageKey('Page1'),
    ),
    Shop(
      key: PageStorageKey('Page2'),
    ),
    Cart(
      key: PageStorageKey('Page3'),
    ),
//    Favorite(
////      key: PageStorageKey('Page4'),
////    ),
    Profile(
      key: PageStorageKey('Page5'),
    )
  ];
  final PageStorageBucket bucket = PageStorageBucket();
//  int selectedIndex;

  @override
  BottomNavigationBarControllerState createState() =>
      BottomNavigationBarControllerState();
}

class BottomNavigationBarControllerState
    extends State<BottomNavigationBarController> {
  bottomNavigationBar(int selectedIndex) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
      ),
      child: SizedBox(
        height: 80.0,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Color(0xFF1E1F28),
            primaryColor: Color(0xffEF3651),
            textTheme: Theme.of(context).textTheme.copyWith(
                  caption: new TextStyle(
                    color: Colors.grey,
                  ),
                ),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (int index) {
              setState(() => widget.selectedIndex = index);
            },
            currentIndex: selectedIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.home,
                  size: 20,
                ),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.store,
                  size: 20,
                ),
                title: Text('Shop'),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.shoppingCart,
                  size: 20,
                ),
                title: Text('Cart'),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.heart,
                  size: 20,
                ),
                title: Text('Favorites'),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.user,
                  size: 20,
                ),
                title: Text('Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: bottomNavigationBar(widget.selectedIndex),
      body: PageStorage(
        child: widget.pages[widget.selectedIndex],
        bucket: widget.bucket,
      ),
    );
  }
}
