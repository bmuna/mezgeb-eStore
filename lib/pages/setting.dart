import 'package:day_night_switch/day_night_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mezgebestore/language/AppLanguage.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/pages/navbar_controller.dart';
import 'package:mezgebestore/stores/cart_logic.dart';
import 'package:mezgebestore/stores/login_store.dart';
import 'package:mezgebestore/stores/size_config.dart';
import 'package:mezgebestore/stores/theme_notifier.dart';
import 'package:mezgebestore/theme_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  final String uid;
  Settings({this.uid});
  static const String id = 'setting';

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String userId;
  bool isSwitched = false;
  var _darkTheme = true;
  String text = "English";

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }

  void getUser() async {
    try {
      userId = (await FirebaseAuth.instance.currentUser()).uid;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

//  Consumer<CartBloc>(
//  builder: (buildconext, cartbloc, widget) => Builder(
//  builder: (BuildContext context) {
//
//  }
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Consumer<LoginStore>(builder: (_, loginStore, __) {
      return Consumer<CartBloc>(
          builder: (buildconext, cartbloc, content) =>
              Builder(builder: (BuildContext context) {
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    bottomOpacity: 1,
                    elevation: 3.0,
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    title: Text(
                      AppLocalizations.of(context).translate('settings'),
                      style: Theme.of(context).textTheme.bodyText1.merge(
                            TextStyle(
                              fontSize: 2.8 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      iconSize: 2.6 * SizeConfig.heightMultiplier,
                      color: Theme.of(context).indicatorColor,
                      onPressed: () {
//            Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigationBarController(
                              selectedIndex: 3,
                            ),
                          ),
                        );
//
                      },
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 1.2 * SizeConfig.heightMultiplier),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            leading: Text(
                                AppLocalizations.of(context)
                                    .translate('general'),
                                style:
                                    Theme.of(context).textTheme.subtitle1.merge(
                                          TextStyle(
                                            fontSize:
                                                2.3 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0.3 * SizeConfig.heightMultiplier),
                            child: ListTile(
                              leading: Icon(
                                Icons.share,
                                color: Colors.grey,
                                size: 3.4 * SizeConfig.heightMultiplier,
                              ),
                              title: Text(
                                  AppLocalizations.of(context)
                                      .translate('shareApp'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(
                                        TextStyle(
                                          fontSize:
                                              2.1 * SizeConfig.textMultiplier,
                                        ),
                                      )),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0.3 * SizeConfig.heightMultiplier),
                            child: ListTile(
                              leading: Icon(
                                Icons.lock,
                                color: Colors.grey,
                                size: 3.4 * SizeConfig.heightMultiplier,
                              ),
                              title: Text(
                                AppLocalizations.of(context)
                                    .translate('privatePolicy'),
                                style:
                                    Theme.of(context).textTheme.bodyText1.merge(
                                          TextStyle(
                                            fontSize:
                                                2.1 * SizeConfig.textMultiplier,
                                          ),
                                        ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0.3 * SizeConfig.heightMultiplier),
                            child: ListTile(
                              leading: Icon(
                                Icons.copyright,
                                color: Colors.grey,
                                size: 3.4 * SizeConfig.heightMultiplier,
                              ),
                              title: Text(
                                  AppLocalizations.of(context)
                                      .translate('copyrightPolicy'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(
                                        TextStyle(
                                          fontSize:
                                              2.1 * SizeConfig.textMultiplier,
                                        ),
                                      )),
                            ),
                          ),
                          widget.uid != null
                              ? Ink(
//                Ink(
                                  child: ListTile(
                                    onTap: () {
                                      showAlertDialog(
                                          context, loginStore, cartbloc);
                                    },
                                    leading: Icon(
                                      FontAwesomeIcons.signOutAlt,
                                      color: Colors.grey,
                                      size: 3.4 * SizeConfig.heightMultiplier,
                                    ),
                                    title: Text(
                                      AppLocalizations.of(context)
                                          .translate('logout'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .merge(
                                            TextStyle(
                                              fontSize: 2.1 *
                                                  SizeConfig.textMultiplier,
                                            ),
                                          ),
                                    ),
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 0.5 * SizeConfig.heightMultiplier,
                              bottom: 0.5 * SizeConfig.heightMultiplier,
                            ),
                            child: ListTile(
                              leading: Text(
                                  AppLocalizations.of(context)
                                      .translate('preference'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .merge(
                                        TextStyle(
                                          fontSize:
                                              2.3 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0.3 * SizeConfig.heightMultiplier),
                            child: ListTile(
                              leading: Icon(
                                FontAwesomeIcons.moon,
                                color: Colors.grey,
                                size: 3.4 * SizeConfig.heightMultiplier,
                              ),
                              title: Text(
                                AppLocalizations.of(context).translate('theme'),
                                style:
                                    Theme.of(context).textTheme.bodyText1.merge(
                                          TextStyle(
                                            fontSize:
                                                2.1 * SizeConfig.textMultiplier,
                                          ),
                                        ),
                              ),
                              trailing: Transform.scale(
                                scale: 0.05 * SizeConfig.heightMultiplier,
                                child: DayNightSwitch(
                                  value: _darkTheme,
                                  onChanged: (val) {
                                    setState(() {
                                      _darkTheme = val;
                                    });
                                    onThemeChanged(val, themeNotifier);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0.3 * SizeConfig.heightMultiplier),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  _settingModalBottomSheet(context);
                                });
                              },
                              leading: Icon(
                                Icons.language,
                                color: Colors.grey,
                                size: 3.4 * SizeConfig.heightMultiplier,
                              ),
                              title: Text(
                                AppLocalizations.of(context)
                                    .translate('language'),
                                style:
                                    Theme.of(context).textTheme.bodyText1.merge(
                                          TextStyle(
                                            fontSize:
                                                2.1 * SizeConfig.textMultiplier,
                                          ),
                                        ),
                              ),
                              trailing: Text(
                                text,
                                style: TextStyle(
                                    color: Color(0xffEF3651),
                                    fontSize:
                                        2.1 * SizeConfig.heightMultiplier),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 0.5 * SizeConfig.heightMultiplier,
                              bottom: 0.5 * SizeConfig.heightMultiplier,
                            ),
                            child: ListTile(
                              leading: Text(
                                  AppLocalizations.of(context)
                                      .translate('feedback'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .merge(
                                        TextStyle(
                                          fontSize:
                                              2.3 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0.3 * SizeConfig.heightMultiplier),
                            child: ListTile(
                              leading: Icon(
                                FontAwesomeIcons.star,
                                color: Colors.grey,
                                size: 3.4 * SizeConfig.heightMultiplier,
                              ),
                              title: Text(
                                  AppLocalizations.of(context)
                                      .translate('rateUs'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(
                                        TextStyle(
                                          fontSize:
                                              2.1 * SizeConfig.textMultiplier,
                                        ),
                                      )),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0.3 * SizeConfig.heightMultiplier),
                            child: ListTile(
                              leading: Icon(
                                FontAwesomeIcons.heart,
                                color: Colors.grey,
                                size: 3.4 * SizeConfig.heightMultiplier,
                              ),
                              title: Text(
                                  AppLocalizations.of(context)
                                      .translate('followUs'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(
                                        TextStyle(
                                          fontSize:
                                              2.1 * SizeConfig.textMultiplier,
                                        ),
                                      )),
                            ),
                          ),
                          SizedBox(
                            height: 3.1 * SizeConfig.textMultiplier,
                          ),
                          Center(
                            child: Text(
                              AppLocalizations.of(context).translate('version'),
                              style:
                                  Theme.of(context).textTheme.bodyText1.merge(
                                        TextStyle(
                                            fontSize:
                                                2.1 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.bold),
                                      ),
                            ),
                          ),
                          SizedBox(
                            height: 2 * SizeConfig.textMultiplier,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }));
    });
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        var appLanguage = Provider.of<AppLanguage>(context);
        return Container(
          color: Theme.of(context).indicatorColor,
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 0.4 * SizeConfig.heightMultiplier,
                ),
                child: ListTile(
                  title: Text(
                    'English',
                    style: Theme.of(context).textTheme.subtitle2.merge(
                          TextStyle(
                            fontSize: 2.1 * SizeConfig.textMultiplier,
                          ),
                        ),
                  ),
                  onTap: () {
                    appLanguage.changeLanguage(
                      Locale("en"),
                    );
                    setState(() {
                      text = "English";
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 0.4 * SizeConfig.heightMultiplier,
                ),
                child: ListTile(
                  title: Text(
                    'Amharic',
                    style: Theme.of(context).textTheme.subtitle2.merge(
                          TextStyle(
                            fontSize: 2.1 * SizeConfig.textMultiplier,
                          ),
                        ),
                  ),
                  onTap: () => {
                    appLanguage.changeLanguage(
                      Locale(
                        "am",
                      ),
                    ),
                    setState(() {
                      text = "Amharic";
                    }),
                    Navigator.of(context).pop(),
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  showAlertDialog(BuildContext context, loginStore, cartBloc) {
    Widget cancelButton = FlatButton(
      child: Text(
        AppLocalizations.of(context).translate('cancel'),
        style: TextStyle(fontSize: 1.5 * SizeConfig.textMultiplier),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigationBarController(
              selectedIndex: 3,
            ),
          ),
        );
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        AppLocalizations.of(context).translate('continue'),
        style: TextStyle(fontSize: 1.5 * SizeConfig.textMultiplier),
      ),
      onPressed: () {
        loginStore.signOut(context);
        cartBloc.productsInCart.length = 0;
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        AppLocalizations.of(context).translate('logoutFromMezgeb'),
        style: TextStyle(fontSize: 1.8 * SizeConfig.textMultiplier),
      ),
      actions: [continueButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
