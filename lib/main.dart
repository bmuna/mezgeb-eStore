import 'package:flutter/material.dart';
import 'package:mezgebestore/pages/cart.dart';
import 'package:mezgebestore/pages/home.dart';
import 'package:mezgebestore/pages/navbar_controller.dart';
import 'package:mezgebestore/pages/otp_page.dart';
import 'package:mezgebestore/pages/shop.dart';
import 'package:mezgebestore/pages/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:mezgebestore/pages/splash_control.dart';
import 'package:mezgebestore/stores/login_store.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoginStore>(
          create: (_) => LoginStore(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Inter',
            textTheme: TextTheme(
              bodyText2: TextStyle(
                color: Color(0xffF7F7F7),
              ),
            ),
            scaffoldBackgroundColor: Color(0xFF1E1F28),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          initialRoute: BottomNavigationBarController.id,
          routes: {
            Home.id: (context) => Home(),
            Splash.id: (context) => Splash(),
            SplashControl.id: (context) => SplashControl(),
            OtpPage.id: (context) => OtpPage(),
            BottomNavigationBarController.id: (context) =>
                BottomNavigationBarController(selectedIndex: 0),
            Cart.id: (context) => Cart(),
            Shop.id: (context) => Shop(),
          }),
    );
  }
}
