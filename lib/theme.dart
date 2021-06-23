import 'package:flutter/material.dart';

final storetheme = ThemeData(
  primarySwatch: Colors.indigo,
  backgroundColor: Colors.black,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: "Poppins",
  primaryTextTheme: TextTheme(
    headline6: storeText,
    bodyText1: storeTextBold,
  ),
);

final TextStyle productHeadline = TextStyle(
  color: Colors.indigo,
  fontSize: 15,
  fontWeight: FontWeight.normal,
);

final TextStyle storeText = TextStyle(
  fontWeight: FontWeight.normal,
  color: Colors.white,
);
final TextStyle storeTextLight = TextStyle(
  fontWeight: FontWeight.w300,
  color: Colors.white,
);
final TextStyle storeTextBold = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

final TextStyle tileText = TextStyle(
  color: Colors.white,
);
