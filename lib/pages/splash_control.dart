import 'package:flutter/material.dart';
import 'package:mezgebestore/pages/navbar_controller.dart';
import 'package:provider/provider.dart';
import 'package:mezgebestore/pages/login_page.dart';
import 'package:mezgebestore/stores/login_store.dart';

class SplashControl extends StatefulWidget {
  final String brand, price, type, description, newPrice;
  final List size, color, imgUrl;
  final int quantity;
  static const String id = 'splash_control_screen';

  const SplashControl(
      {Key key,
      this.brand,
      this.color,
      this.description,
      this.imgUrl,
      this.newPrice,
      this.price,
      this.size,
      this.type,
      this.quantity})
      : super(key: key);
  @override
  _SplashControlState createState() => _SplashControlState();
}

class _SplashControlState extends State<SplashControl> {
  @override
  void initState() {
    super.initState();
//    print("${LoginStore().firebaseUser.uid}");

    Provider.of<LoginStore>(context, listen: false)
        .isAlreadyAuthenticated()
        .then((result) {
      if (result) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigationBarController(
              selectedIndex: 2,
            ),
          ),
        );
//        print('address: ${CreateAddress().userId}');
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const LoginPage(),
            ),
            (Route<dynamic> route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
