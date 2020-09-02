import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mezgebestore/pages/splash_control.dart';

class Splash extends StatefulWidget {
  static const String id = 'splash_screen';
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.pushNamed(
          context,
          SplashControl.id,
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff38D39F),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffEF3651),
              Color(0xff9D2F66),
            ],
          ),
        ),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'images/mlogo.png',
                        width: 200,
                        height: 200,
                      ),
                      Text('Mezgeb eStore'),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
                SpinKitThreeBounce(
                  color: Colors.white,
                  size: 20.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
