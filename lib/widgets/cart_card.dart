import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mezgebestore/language/AppLanguage.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/models/check_out.dart';
import 'package:mezgebestore/pages/cart.dart';
import 'package:mezgebestore/pages/cart.dart';
import 'package:mezgebestore/pages/cart.dart';
import 'package:mezgebestore/stores/cart_logic.dart';
import 'package:mezgebestore/stores/size_config.dart';
import 'package:mezgebestore/theme.dart';
import 'package:mezgebestore/widgets/round_button.dart';
import 'package:provider/provider.dart';

class CartCard extends StatelessWidget {
  final CheckOutData product;
  final CartBloc cartBloc;

  const CartCard({
    Key key,
    @required this.product,
    @required this.cartBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NumberFormat toCurrency = NumberFormat("#,##0", "en_US");
    var appLanguage = Provider.of<AppLanguage>(context);
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 2 * SizeConfig.heightMultiplier,
          ),
          child: Container(
            height: 18 * SizeConfig.heightMultiplier,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 0.6 * SizeConfig.heightMultiplier,
                )
              ],
              borderRadius: BorderRadius.circular(
                1.5 * SizeConfig.heightMultiplier,
              ),
              color: Theme.of(context).backgroundColor,
            ),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    1.2 * SizeConfig.heightMultiplier,
                  ),
                  child: CachedNetworkImage(
                    height: double.infinity,
                    width: 15 * SizeConfig.heightMultiplier,
                    placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Container(
                        child: Icon(
                          Icons.error,
                          size: 4.6 * SizeConfig.heightMultiplier,
                        ),
                      ),
                    ),
                    imageUrl: product.imgUrl[0],
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  width: 2.7 * SizeConfig.widthMultiplier,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 0.1 * SizeConfig.heightMultiplier,
                    ),
                    child: Column(
//                    mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              product.brand,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .merge(
                                    TextStyle(
                                      fontSize: 2.1 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 0.5 * SizeConfig.widthMultiplier,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  cardColor: Colors.white,
                                ),
                                child: PopupMenuButton<String>(
                                  onSelected: (value) {
//                                setState(() {
//                                  handleClick(
//                                      dataList[i].id);
//                                });
                                    cartBloc.removeItemFromCart(product.id);
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return {
                                      'Delete',
                                    }.map((String choice) {
                                      return PopupMenuItem(
                                        value: choice,
                                        child: Text(
                                          choice,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
//                      SizedBox(
//                        height: 0.7 * SizeConfig.heightMultiplier,
//                      ),
                        Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)
                                  .translate('colorCartText'),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .merge(
                                    TextStyle(
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                    ),
                                  ),
                            ),
                            SizedBox(
                              width: 1.3 * SizeConfig.widthMultiplier,
                            ),
                            Text(
                              product.selectedColor,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .merge(TextStyle(
                                    fontSize: 2 * SizeConfig.textMultiplier,
                                  )),
                            ),
                            SizedBox(
                              width: 3.6 * SizeConfig.heightMultiplier,
                            ),
                            Text(
                                AppLocalizations.of(context)
                                    .translate('sizeCartText'),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .merge(TextStyle(
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                    ))),
                            SizedBox(
                              width: 1.3 * SizeConfig.widthMultiplier,
                            ),
                            Text(
                              product.selectedSize,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .merge(TextStyle(
                                    fontSize: 2 * SizeConfig.textMultiplier,
                                  )),
                            ),
                          ],
                        ),
//                      SizedBox(
//                        height: 0.7 * SizeConfig.heightMultiplier,
//                      ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                RoundIconButton(
                                  icon: FontAwesomeIcons.minus,
                                  onPressed: () =>
                                      cartBloc.decrementItemFromCart(product),
                                ),
                                SizedBox(
                                  width: 2.7 * SizeConfig.widthMultiplier,
                                ),
                                Text(
                                  '${product.quantity}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(TextStyle(
                                        fontSize:
                                            2.1 * SizeConfig.heightMultiplier,
                                      )),
                                ),
                                SizedBox(
                                  width: 2.7 * SizeConfig.widthMultiplier,
                                ),
                                RoundIconButton(
                                  icon: FontAwesomeIcons.plus,
                                  onPressed: () =>
                                      cartBloc.addItemToCart(product),
                                ),
                              ],
                            ),
                            Container(
                              child: Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: 2.7 * SizeConfig.widthMultiplier,
                                  ),
                                  child: appLanguage.appLocale == Locale('en')
                                      ? AutoSizeText(
                                          "${toCurrency.format(product.newPrice)} ETB",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .merge(
                                                TextStyle(
                                                  fontSize: 2.1 *
                                                      SizeConfig.textMultiplier,
                                                ),
                                              ),
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                          minFontSize:
                                              1.9 * SizeConfig.textMultiplier,
                                          stepGranularity:
                                              1.9 * SizeConfig.textMultiplier,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : AutoSizeText(
                                          "${toCurrency.format(product.newPrice)} ብር",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .merge(
                                                TextStyle(
                                                  fontSize: 2.1 *
                                                      SizeConfig.textMultiplier,
                                                ),
                                              ),
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                          minFontSize:
                                              1.9 * SizeConfig.textMultiplier,
                                          stepGranularity:
                                              1.9 * SizeConfig.textMultiplier,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
//                                        Text('total:${dataList[].price}')
              ],
            ),
          ),
        ),
        SizedBox(
          height: 1.5 * SizeConfig.heightMultiplier,
        )
      ],
    );
//    return Container(
//      height: 128,
//      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//      decoration: BoxDecoration(
//        borderRadius: BorderRadius.circular(5),
//        color: Color(0xff2A2C36),
//        boxShadow: [
//          BoxShadow(
//            color: Colors.indigo.shade100,
//            blurRadius: 15,
//            spreadRadius: 1,
//          )
//        ],
//      ),
//      child: Row(
//        crossAxisAlignment: CrossAxisAlignment.center,
//        mainAxisAlignment: MainAxisAlignment.end,
//        children: <Widget>[
//          Padding(
//            padding: const EdgeInsets.only(right: 20.0),
//            child: CachedNetworkImage(
//              width: 128,
//              height: 128,
//              imageUrl: product.imgUrl[0],
//              placeholder: (context, url) => Container(
//                width: 128,
//                height: 128,
//                alignment: Alignment.center,
//                child: CircularProgressIndicator(),
//              ),
//              errorWidget: (context, url, error) => Container(
//                width: 128,
//                height: 128,
//                child: Icon(Icons.error),
//              ),
//              fit: BoxFit.cover,
//            ),
//          ),
//          Expanded(
//            child: Column(
//              mainAxisSize: MainAxisSize.min,
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Text(
//                  product.brand,
//                  textAlign: TextAlign.left,
//                  maxLines: 1,
//                  overflow: TextOverflow.ellipsis,
//                  style: productHeadline,
//                ),
//                Text(
//                  "Price : ${product.newPrice} Birr",
//                  textAlign: TextAlign.center,
//                ),
//                Text(
//                  "Quantity : ${product.quantity}",
//                  textAlign: TextAlign.center,
//                ),
//                Row(
//                  children: <Widget>[
//                    IconButton(
//                      icon: Icon(Icons.add),
//                      onPressed: () => cartBloc.addItemToCart(product),
//                    ),
//                    IconButton(
//                      icon: Icon(Icons.remove),
//                      onPressed: () => cartBloc.decrementItemFromCart(product),
//                    ),
//                    IconButton(
//                      icon: Icon(Icons.close),
//                      onPressed: () => cartBloc.removeItemFromCart(product.id),
//                    )
//                  ],
//                )
//              ],
//            ),
//          )
//        ],
//      ),
//    );
  }
}
