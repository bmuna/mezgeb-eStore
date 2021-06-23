import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/pages/navbar_controller.dart';
import 'package:mezgebestore/pages/shipping.dart';
import 'package:mezgebestore/stores/size_config.dart';
import 'package:mezgebestore/widgets/main_button.dart';
import 'package:mezgebestore/widgets/mobile_banking.dart';
import 'package:mezgebestore/widgets/mobile_banking_cart.dart';

class PaymentPage extends StatefulWidget {
  static const String id = 'payment_screen';
  List order;
  PaymentPage({this.order});
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<PaymentPage> {
//  int _index = 0;
  bool one = false;
  Color color;
  String selected = "first";

  @override
  void initState() {
    super.initState();

    color = Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();
    return ConnectivityWidgetWrapper(
      height: 4.6 * SizeConfig.heightMultiplier,
      color: Color(0xffEF3651),
      message: "Please check your internet connection!!",
      messageStyle: TextStyle(
        fontFamily: "Inter",
        color: Colors.white,
        fontSize: 2 * SizeConfig.textMultiplier,
        decoration: TextDecoration.none,
      ),
      child: Scaffold(
        key: key,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          bottomOpacity: 1,
          elevation: 3.0,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context).translate('choosePaymentTitle'),
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
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (_) => BottomNavigationBarController(
                            selectedIndex: 2,
                          )),
                  (Route<dynamic> route) => false);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(
                      1.5 * SizeConfig.heightMultiplier,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
//                  Text('Select payment option'),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    Card(
                                      color: selected == 'first'
                                          ? Colors.red
                                          : Colors.white,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Image.asset(
                                        'images/cash.png',
                                        height:
                                            28 * SizeConfig.heightMultiplier,
                                      ),
                                    ),
                                    Container(
                                      width: double.maxFinite,
                                      color: Colors.black.withOpacity(0.7),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          1.5 * SizeConfig.heightMultiplier,
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate("cashOnDelivery"),
                                          style: TextStyle(
                                            fontSize: 2.6 *
                                                SizeConfig.heightMultiplier,
                                            fontWeight: FontWeight.bold,
                                          ),
//                                        maxLines: 1,
//                                        minFontSize:
//                                            2 * SizeConfig.textMultiplier,
//                                        stepGranularity:
//                                            2 * SizeConfig.textMultiplier,
//                                        overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    selected = 'first';
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 1.3 * SizeConfig.widthMultiplier),
                            Expanded(
                              child: Container(
                                child: GestureDetector(
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: <Widget>[
                                      Card(
                                        color: selected == 'second'
                                            ? Colors.red
                                            : Colors.white,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: Image.asset(
                                          'images/mobile.png',
                                          height:
                                              28 * SizeConfig.heightMultiplier,
                                        ),
                                      ),
                                      Container(
                                        width: double.maxFinite,
                                        color: Colors.black.withOpacity(0.7),
                                        child: Padding(
                                          padding: EdgeInsets.all(1.5 *
                                              SizeConfig.heightMultiplier),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate("mobileBanking"),
                                            style: TextStyle(
                                              fontSize: 2.6 *
                                                  SizeConfig.heightMultiplier,
                                              fontWeight: FontWeight.bold,
                                            ),
//                                          maxLines: 1,
//                                          minFontSize:
//                                              2 * SizeConfig.textMultiplier,
//                                          stepGranularity:
//                                              2 * SizeConfig.textMultiplier,
//                                          overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selected = 'second';
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3.1 * SizeConfig.heightMultiplier,
                        ),
                        selected == 'first'
                            ? Column(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate("cashOnDelivery"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .merge(
                                          TextStyle(
                                            fontSize: 2.6 *
                                                SizeConfig.heightMultiplier,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  ),
                                  SizedBox(
                                    height: 3.1 * SizeConfig.heightMultiplier,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate("cashOnDeliveryMessage"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .merge(
                                          TextStyle(
                                            fontSize: 2.1 *
                                                SizeConfig.heightMultiplier,
                                          ),
                                        ),
                                  ),
                                ],
                              )
                            : Column(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate("mobileBanking"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .merge(
                                          TextStyle(
                                            fontSize: 2.6 *
                                                SizeConfig.heightMultiplier,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  ),
                                  SizedBox(
                                    height: 3.1 * SizeConfig.heightMultiplier,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate("mobileBankingMessage"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .merge(
                                          TextStyle(
                                            fontSize: 2.1 *
                                                SizeConfig.heightMultiplier,
                                          ),
                                        ),
                                  ),
                                  SizedBox(
                                    height: 3.1 * SizeConfig.heightMultiplier,
                                  ),
                                  MobileBankingCart()
//                                MobileBanking()
                                ],
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              selected == 'second'
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.7 * SizeConfig.widthMultiplier,
                        vertical: 3.1 * SizeConfig.heightMultiplier,
                      ),
                      child: MainButton(
                        text: AppLocalizations.of(context)
                            .translate("placeYourOrder"),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => Shipping(order: widget.order),
                              ),
                              (Route<dynamic> route) => false);
                        },
                      ),
                    )
                  : Container()
            ],
          ),
        ),
        bottomNavigationBar: selected == 'first'
            ? Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.7 * SizeConfig.widthMultiplier,
                  ),
                  child: MainButton(
                    text: AppLocalizations.of(context)
                        .translate("placeYourOrder"),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => Shipping(order: widget.order),
                          ),
                          (Route<dynamic> route) => false);
                    },
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
