import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mezgebestore/language/AppLanguage.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/pages/payment.dart';
import 'file:///C:/Users/Munation/Documents/flutter_project/mezgeb_estore/lib/widgets/main_button.dart';
import 'package:mezgebestore/stores/cart_logic.dart';
import 'package:mezgebestore/stores/size_config.dart';
import 'package:mezgebestore/widgets/cart_card.dart';
import 'package:provider/provider.dart';

class Cart extends StatelessWidget {
  final NumberFormat toCurrency = NumberFormat("#,##0", "en_US");
  Cart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Consumer<CartBloc>(
      builder: (buildconext, cartbloc, widget) => Builder(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              bottomOpacity: 1,
              elevation: 3.0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: Text(
                AppLocalizations.of(context).translate('cart'),
                style: Theme.of(context).textTheme.bodyText1.merge(
                      TextStyle(
                        fontSize: 2.8 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
            ),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: cartbloc.productsInCart.length == 0
                        ? Center(
                            child: Column(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(150),
                                  child: Image.asset('images/empty.jpg',
                                      width: 22 * SizeConfig.heightMultiplier,
                                      height: 22 * SizeConfig.heightMultiplier,
                                      fit: BoxFit.cover),
                                ),
                                SizedBox(
                                  height: 3.1 * SizeConfig.heightMultiplier,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('cartTextHeader'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(
                                        TextStyle(
                                          fontSize:
                                              2.9 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                ),
                                SizedBox(
                                  height: 3.1 * SizeConfig.heightMultiplier,
                                ),
                                appLanguage.appLocale == Locale('en')
                                    ? Column(
                                        children: <Widget>[
                                          Text("Looks like you haven't made ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .merge(TextStyle(
                                                    fontSize: 2.1 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                  ))),
                                          Text("your menu yet.",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .merge(TextStyle(
                                                    fontSize: 2.1 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                  )))
                                        ],
                                      )
                                    : Text("ገና ዝርዝር አላወጡም",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .merge(TextStyle(
                                              fontSize: 2.1 *
                                                  SizeConfig.heightMultiplier,
                                            )))
                              ],
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 2 * SizeConfig.heightMultiplier,
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: cartbloc.productsInCart.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CartCard(
                                    product: cartbloc.productsInCart[index],
                                    cartBloc: cartbloc,
                                  );
                                },
                              ),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 1.5 * SizeConfig.heightMultiplier,
                  ),
                  cartbloc.productsInCart.isNotEmpty
                      ? Container(
                          margin: EdgeInsets.only(
                            bottom: 8 * SizeConfig.heightMultiplier,
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(
                                  0.7 * SizeConfig.heightMultiplier,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        3.1 * SizeConfig.heightMultiplier,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)
                                            .translate('totalAmountText'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .merge(
                                              TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 2.1 *
                                                    SizeConfig.textMultiplier,
                                              ),
                                            ),
                                      ),
                                      appLanguage.appLocale == Locale('en')
                                          ? Text(
                                              cartbloc.productsInCart.length >=
                                                      2
                                                  ? "${cartbloc.productsInCart.length} items"
                                                  : "${cartbloc.productsInCart.length} item",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .merge(TextStyle(
                                                    fontSize: 2.1 *
                                                        SizeConfig
                                                            .textMultiplier,
                                                  )))
                                          : Text(
                                              cartbloc.productsInCart.length >=
                                                      2
                                                  ? "${cartbloc.productsInCart.length} ዕቃዎች"
                                                  : "${cartbloc.productsInCart.length} ዕቃ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .merge(
                                                    TextStyle(
                                                        fontSize: 2.1 *
                                                            SizeConfig
                                                                .textMultiplier),
                                                  ),
                                            ),
                                      appLanguage.appLocale == Locale('en')
                                          ? Container(
                                              child: AutoSizeText(
                                                "${toCurrency.format(cartbloc.calculateTotalPrice())} ETB",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .merge(
                                                      TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 2.9 *
                                                            SizeConfig
                                                                .textMultiplier,
                                                      ),
                                                    ),
                                                textAlign: TextAlign.right,
                                                maxLines: 1,
                                                minFontSize: 2.6 *
                                                    SizeConfig.textMultiplier,
                                                stepGranularity: 2.6 *
                                                    SizeConfig.textMultiplier,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          : Container(
                                              child: AutoSizeText(
                                                "${toCurrency.format(cartbloc.calculateTotalPrice())} ብር",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .merge(
                                                      TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 2.9 *
                                                            SizeConfig
                                                                .textMultiplier,
                                                      ),
                                                    ),
                                                textAlign: TextAlign.right,
                                                maxLines: 1,
                                                minFontSize: 2.6 *
                                                    SizeConfig.textMultiplier,
                                                stepGranularity: 2.6 *
                                                    SizeConfig.textMultiplier,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.8 * SizeConfig.widthMultiplier,
                                ),
                                child: MainButton(
                                  text: AppLocalizations.of(context)
                                      .translate('alertBoxCheckOutButton'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaymentPage(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container()
                ]),
          );
        },
      ),
    );
  }
}
