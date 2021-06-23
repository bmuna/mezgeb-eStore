import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  fontFamily: 'Inter',
  textTheme: TextTheme(
    bodyText2: homePageBigTextLight,
    bodyText1: homePageTagLight,
    subtitle1: brandTextLight,
    subtitle2: snackBarTextLight,

//    subtitle2: oldPriceTextLight,
  ),
  indicatorColor: Colors.white,
  primaryColor: Color(0xFF1E1F28),
  accentColor: Colors.white,
  scaffoldBackgroundColor: Color(0xff1D1E27),
  bottomAppBarColor: Color(0xff1D1E27),
  iconTheme: IconThemeData(color: Colors.white),
  primaryTextTheme: TextTheme(),
  buttonColor: Color(0xff4c4f5e),
  backgroundColor: Color(0xff2A2C35),
  cardColor: Color(
    0xff4c4f5e,
  ),
);

final lightTheme = ThemeData(
  fontFamily: 'Inter',
  textTheme: TextTheme(
    bodyText2: homePageBigTextDark,
    bodyText1: homePageTagDark,
    subtitle1: brandTextDark,
    subtitle2: snackBarTextDark,

//    subtitle2: oldPriceTextDark,
  ),
  indicatorColor: Colors.black,
  primaryColor: Color(0xffF9F9F9),
  accentColor: Colors.black,
  bottomAppBarColor: Color(0xffF9F9F9),
  scaffoldBackgroundColor: Color(0xffF8F8F8),
  iconTheme: IconThemeData(color: Colors.black),
  buttonColor: Color(0xffF8F8F8),
  backgroundColor: Color(0xffF8F8F8),
  cardColor: Color(
    0xff9B9B9B,
  ),
//  primaryTextTheme: TextTheme(
//    headline1: homePageBigText2,
//  ),
);

final TextStyle homePageBigTextLight = TextStyle(
  color: Colors.white,
);
final TextStyle homePageBigTextDark = TextStyle(
  color: Colors.black,
);

final TextStyle homePageTagLight = TextStyle(
  color: Colors.white,
);
final TextStyle homePageTagDark = TextStyle(
  color: Colors.black,
);
final TextStyle brandTextLight = TextStyle(
  color: Color(
    0xff9B9B9B,
  ),
);
final TextStyle brandTextDark = TextStyle(
  color: Color(
    0xff555555,
  ),
);
final TextStyle snackBarTextLight = TextStyle(
  color: Colors.black,
);
final TextStyle snackBarTextDark = TextStyle(
  color: Colors.white,
);
