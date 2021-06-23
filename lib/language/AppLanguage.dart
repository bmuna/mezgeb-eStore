import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier {
  Locale appLocale = Locale('en');

  Locale get appLocal => appLocale ?? Locale("en");
  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      appLocale = Locale('en');
      return Null;
    }
    appLocale = Locale(prefs.getString('language_code'));
    return Null;
  }

//  bool whether(Locale type){
//   if(type == Locale("en")){
//
//   }
//
//  }
  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (appLocale == type) {
      return;
    }
    if (type == Locale("am")) {
      appLocale = Locale("am");
      await prefs.setString('language_code', 'am');
      await prefs.setString('countryCode', '');
    } else {
      appLocale = Locale("en");
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'US');
    }
    notifyListeners();
  }
}
