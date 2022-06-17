import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mezgebestore/language/AppLanguage.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/pages/cart.dart';
import 'package:mezgebestore/pages/home.dart';
import 'package:mezgebestore/pages/profile.dart';
import 'package:mezgebestore/pages/shop3.dart';
import 'package:mezgebestore/stores/cart_logic.dart';
import 'package:mezgebestore/stores/size_config.dart';
import 'package:mezgebestore/stores/theme_notifier.dart';
import 'package:mezgebestore/theme_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigationBarController extends StatefulWidget {
  var _darkTheme = true;
  static const String id = 'nav_screen';
  int selectedIndex = 0;
  BottomNavigationBarController({this.selectedIndex});
  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }

  final List<Widget> pages = [
    Home(
      key: PageStorageKey('Page1'),
    ),
    Shop3(
      key: PageStorageKey('Page2'),
    ),
    Cart(
      key: PageStorageKey('Page3'),
    ),
//    Shop2(
//      key: PageStorageKey('Page4'),
//    ),
    Profile(
      key: PageStorageKey('Page4'),
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
  bottomNavigationBar(int selectedIndex, language, cartBloc) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(
            4.6 * SizeConfig.heightMultiplier,
          ),
          topLeft: Radius.circular(
            4.6 * SizeConfig.heightMultiplier,
          ),
        ),
        boxShadow: [
          widget._darkTheme
              ? BoxShadow(spreadRadius: 0, blurRadius: 0, offset: Offset(0, 0))
              : BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(
            4.6 * SizeConfig.heightMultiplier,
          ),
          topLeft: Radius.circular(
            4.6 * SizeConfig.heightMultiplier,
          ),
        ),
        child: SizedBox(
          height: 8 * SizeConfig.heightMultiplier,
          child: Theme(
            data: Theme.of(context).copyWith(
//            canvasColor: Color(0xFF1E1F28),
              primaryColor: Color(0xffEF3651),
              textTheme: Theme.of(context).textTheme.copyWith(
                    caption: new TextStyle(
                      color: Colors.grey,
                    ),
                  ),
            ),
            child: BottomNavigationBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              type: BottomNavigationBarType.fixed,
              onTap: (int index) {
                setState(() => widget.selectedIndex = index);
              },
              currentIndex: selectedIndex,
              selectedFontSize: 2 * SizeConfig.textMultiplier,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.home,
                    size: 2.5 * SizeConfig.heightMultiplier,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.store,
                    size: 2.5 * SizeConfig.heightMultiplier,
                  ),
                  label: AppLocalizations.of(context).translate('shop'),
                ),
                BottomNavigationBarItem(
                    label: AppLocalizations.of(context).translate('cart'),
                    icon: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.shoppingCart,
                          size: 2.5 * SizeConfig.heightMultiplier,
                        ),
                        cartBloc.productsInCart.length != 0
                            ? Positioned(
                                top: -12,
                                left: -12,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffEF3651),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(
                                      1 * SizeConfig.heightMultiplier),
                                  child: Text(
                                    cartBloc.productsInCart.length.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            1.5 * SizeConfig.heightMultiplier),
                                  ),
                                ),
                              )
                            : Text(""),
                      ],
                    )),
                BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.user,
                    size: 2.5 * SizeConfig.heightMultiplier,
                  ),
                  label: AppLocalizations.of(context).translate('profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    widget._darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Consumer<CartBloc>(
      builder: (buildconext, cartbloc, content) => Builder(
        builder: (BuildContext context) {
//          return OfflineBuilder(
//              debounceDuration: Duration.zero,
//              connectivityBuilder: (
//                BuildContext context,
//                ConnectivityResult connectivity,
//                Widget child,
//              ) {
//                if (connectivity == ConnectivityResult.none) {
//                  return Scaffold(
//                    appBar: AppBar(
//                      title: const Text('Home'),
//                    ),
//                    body: Center(
//                        child: Text('Please check your internet connection!')),
//                  );
//                }
//                return child;
//              },
//              child: Scaffold(
//                extendBody: true,
//                bottomNavigationBar: bottomNavigationBar(
//                    widget.selectedIndex, appLanguage, cartbloc),
//                body: Padding(
//                  padding: EdgeInsets.only(bottom: 65.0),
//                  child: ConnectivityWidgetWrapper(
//                    height: 30,
//                    color: Color(0xffEF3651),
//                    message: "Please check your internet connection!!",
//                    child: PageStorage(
//                      child: widget.pages[widget.selectedIndex],
//                      bucket: widget.bucket,
//                    ),
//                  ),
//                ),
//              ));
          return ConnectivityWidgetWrapper(
            height: 4 * SizeConfig.heightMultiplier,
            color: Color(0xffEF3651),
            message: "Please check your internet connection!!",
            messageStyle: TextStyle(
              fontFamily: "Inter",
              color: Colors.white,
              fontSize: 2 * SizeConfig.textMultiplier,
              decoration: TextDecoration.none,
            ),
            //            messageStyle: TextStyle(
//              fontSize: 2 * SizeConfig.textMultiplier,
//            ),
            child: Scaffold(
              extendBody: true,
              bottomNavigationBar: bottomNavigationBar(
                  widget.selectedIndex, appLanguage, cartbloc),
              body: PageStorage(
                child: widget.pages[widget.selectedIndex],
                bucket: widget.bucket,
              ),
            ),
          );
        },
      ),
    );
  }
}
//Align(
//alignment: Alignment.bottomCenter,
//child: ConnectionStatusBar(
//color: Color(0xffEF3651),
//endOffset: const Offset(0.0, 0.0),
//beginOffset: const Offset(0.0, -1.0),
//animationDuration: const Duration(milliseconds: 200),
//title: Column(
//children: <Widget>[
////                            Icon(Icons.add),
//Container(
//height: 1,
//child: LinearProgressIndicator(
//backgroundColor: Color(0xffEF3651),
//),
//),
//Text(
//'Please check your internet connection',
//style: TextStyle(
//color: Colors.white,
//fontSize: 14,
//),
//),
//],
//),
//),
//),
