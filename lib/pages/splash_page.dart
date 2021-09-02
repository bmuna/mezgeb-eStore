import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mezgebestore/pages/navbar_controller.dart';
import 'package:mezgebestore/pages/splash_control.dart';
import 'package:mezgebestore/stores/size_config.dart';

class Splash extends StatefulWidget {
  static const String id = 'splash_screen';
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => BottomNavigationBarController(
              selectedIndex: 0,
            ),
          ),
          (Route<dynamic> route) => false);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xffEF3651)
            ),
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(4.6 * SizeConfig.heightMultiplier),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 9.3 * SizeConfig.heightMultiplier),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Image.asset(
                            'images/mlogo.png',
                            width: 55.6 * SizeConfig.widthMultiplier,
                            height: 31.25 * SizeConfig.heightMultiplier,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Mezgeb eStore',
                            style: TextStyle(
                                fontSize: 2.3 * SizeConfig.textMultiplier),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 15.6 * SizeConfig.heightMultiplier,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: SpinKitThreeBounce(
                      color: Colors.white,
                      size: 5.5 * SizeConfig.imageSizeMultiplier,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
