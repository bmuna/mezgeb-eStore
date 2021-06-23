import 'dart:async';

import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mezgebestore/pages/add_shipping_address.dart';
import 'package:mezgebestore/pages/cata.dart';
import 'package:mezgebestore/pages/editAddress.dart';
import 'package:mezgebestore/pages/home.dart';
import 'package:mezgebestore/pages/login_page.dart';
import 'package:mezgebestore/pages/my_order_page.dart';
import 'package:mezgebestore/pages/newGridViewPage.dart';
import 'package:mezgebestore/pages/profile.dart';
import 'package:mezgebestore/pages/navbar_controller.dart';
import 'package:mezgebestore/pages/otp_page.dart';
import 'package:mezgebestore/pages/setting.dart';
import 'package:mezgebestore/pages/shipping.dart';
import 'package:mezgebestore/pages/shop.dart';
import 'package:mezgebestore/pages/shop2.dart';
import 'package:mezgebestore/pages/shop3.dart';
import 'package:mezgebestore/pages/splash_page.dart';
import 'package:mezgebestore/pages/payment.dart';

import 'package:mezgebestore/stores/cart_logic.dart';
import 'package:mezgebestore/stores/size_config.dart';
import 'package:mezgebestore/stores/theme_notifier.dart';
import 'package:mezgebestore/theme_bloc.dart';
import 'package:provider/provider.dart';
import 'package:mezgebestore/pages/splash_control.dart';
import 'package:mezgebestore/stores/login_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'language/AppLanguage.dart';
import 'language/app_localization.dart';

const bool debugEnableDeviceSimulator = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
    SharedPreferences.getInstance().then((prefs) {
      var darkModeOn = prefs.getBool('darkMode') ?? true;
      runApp(
        ChangeNotifierProvider<ThemeNotifier>(
          create: (context) =>
              ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
          child: MyApp(
            appLanguage: appLanguage,
          ),
        ),
      );
    });
  });
}

class MyApp extends StatelessWidget {
  final AppLanguage appLanguage;
  MyApp({this.appLanguage});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return ChangeNotifierProvider<CartBloc>.value(
        value: CartBloc(),
        child: MultiProvider(
          providers: [
            Provider<LoginStore>(
              create: (_) => LoginStore(),
            ),
          ],
          child: ChangeNotifierProvider<AppLanguage>(
              create: (context) => appLanguage,
              child: Consumer<AppLanguage>(builder: (context, model, child) {
                return LayoutBuilder(builder: (context, constraints) {
                  return OrientationBuilder(builder: (context, orientation) {
                    SizeConfig().init(constraints, orientation);

                    return ConnectivityAppWrapper(
                        app: MaterialApp(
                      locale: model.appLocal,
                      supportedLocales: [
                        Locale('en', 'US'),
                        Locale('am', ''),
                      ],
                      localizationsDelegates: [
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                      ],
                      debugShowCheckedModeBanner: false,
                      theme: themeNotifier.getTheme(),
                      initialRoute: BottomNavigationBarController.id,
                      routes: {
                        Shop.id: (context) => Shop(),
                        NewPage.id: (context) => NewPage(),
                        EditAddress.id: (context) => EditAddress(),
                        AddShippingAddress.id: (context) =>
                            AddShippingAddress(),
                        Settings.id: (context) => Settings(),
                        Shop2.id: (context) => Shop2(),
                        Shop3.id: (context) => Shop3(),
                        Cata.id: (context) => Cata(),
                        LoginPage.id: (context) => LoginPage(),
                        PaymentPage.id: (context) => PaymentPage(),
                        Shipping.id: (context) => Shipping(),
                        MyOrder.id: (context) => MyOrder(),
                        Profile.id: (context) => Profile(),
                        Home.id: (context) => Home(),
                        Splash.id: (context) => Splash(),
                        SplashControl.id: (context) => SplashControl(),
                        OtpPage.id: (context) => OtpPage(),
                        BottomNavigationBarController.id: (context) =>
                            BottomNavigationBarController(selectedIndex: 0),
                      },
                    ));
                  });
                });
              })),
        ));
  }
}
