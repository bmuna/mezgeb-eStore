import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mezgebestore/language/AppLanguage.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'file:///C:/Users/Munation/Documents/flutter_project/mezgeb_estore/lib/widgets/main_button.dart';
import 'package:mezgebestore/models/check_out.dart';
import 'package:mezgebestore/pages/navbar_controller.dart';
import 'package:mezgebestore/pages/splash_control.dart';
import 'package:mezgebestore/stores/cart_logic.dart';
import 'package:mezgebestore/stores/size_config.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Detail extends StatefulWidget {
  final CheckOutData product;
  Detail({this.product});
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  int _current = 0;
  double height;
  double width;
  String firstHalf;
  String secondHalf;
  bool flag = true;
  BottomNavigationBarController controller = BottomNavigationBarController();
  var selectedSize, selectedColor;
  bool liked = false;
  bool containerTap = false;

  _pressed() {
    setState(() {
      liked = !liked;
    });
  }

  bool isExist = false;
  final databaseReference = Firestore.instance;
  var a;
  String userId;
  var alertStyle = AlertStyle(
    animationType: AnimationType.fromLeft,
    backgroundColor: Color(0xff2A2C36),
    isCloseButton: false,
    isOverlayTapDismiss: true,
    descStyle: TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontSize: 2.3 * SizeConfig.heightMultiplier,
    ),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        3.1 * SizeConfig.heightMultiplier,
      ),
      side: BorderSide(
        color: Colors.white,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.bold,
      fontSize: 4.6 * SizeConfig.heightMultiplier,
    ),
  );

  void alertBox(cartBloc) {
    Alert(
        context: context,
        image: Image.asset(
          "images/sale.png",
          width: 20 * SizeConfig.heightMultiplier,
          height: 20 * SizeConfig.heightMultiplier,
        ),
        style: alertStyle,
        title: AppLocalizations.of(context).translate('alertBoxHeader'),
        desc: AppLocalizations.of(context).translate('alertBoxSubHeader'),
        buttons: [
          DialogButton(
            height: 6 * SizeConfig.heightMultiplier,
            width: 8 * SizeConfig.widthMultiplier,
            child: Text(
              AppLocalizations.of(context).translate('alertBoxCheckOutButton'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 2 * SizeConfig.heightMultiplier,
              ),
            ),
            onPressed: () {
              cartBloc.addItemToCart(widget.product);

//              getData();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SplashControl(),
                ),
              );
            },
            color: Color(0xffEF3651),
          ),
          DialogButton(
            height: 6 * SizeConfig.heightMultiplier,
            width: 8 * SizeConfig.widthMultiplier,
            child: Text(
              AppLocalizations.of(context)
                  .translate('alertBoxContinueShoppingButton'),
              style: TextStyle(
                color: Colors.black,
                fontSize: 2 * SizeConfig.heightMultiplier,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            color: Colors.white,
          ),
        ]).show();
  }

  String description;
  @override
  void initState() {
    super.initState();
//    getUser();
//    checkIfLikedOrNot();
    description = widget.product.description;
    if (description.length > 50) {
      firstHalf = description.substring(0, 50);
      secondHalf = description.substring(50, description.length);
    } else {
      firstHalf = description;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat toCurrency = NumberFormat("#,##0", "en_US");
    var appLanguage = Provider.of<AppLanguage>(context);

    final List<Widget> imageSliders = widget.product.imgUrl
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(
                  0.7 * SizeConfig.heightMultiplier,
                ),
                child: Stack(
                  children: <Widget>[
                    CachedNetworkImage(
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
                      imageUrl: item,
                      fit: BoxFit.fill,
                      height: height,
                      width: double.infinity,
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        height: 6 * SizeConfig.heightMultiplier,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 1.5 * SizeConfig.heightMultiplier,
                            horizontal: 5.5 * SizeConfig.widthMultiplier),
                      ),
                    ),
                  ],
                ),
              ),
            ))
        .toList();
//    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return ConnectivityWidgetWrapper(
      height: 4.6 * SizeConfig.heightMultiplier,
      color: Color(0xffEF3651),
      message: "Please check your internet connection!!",
      messageStyle: TextStyle(
        color: Colors.white,
        fontSize: 2 * SizeConfig.textMultiplier,
        fontFamily: "Inter",
        decoration: TextDecoration.none,
      ),
      child: Scaffold(
//      key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          bottomOpacity: 1,
          elevation: 3.0,
          centerTitle: true,
          title: Text(
            widget.product.category,
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
              Navigator.pop(context);
            },
          ),
        ),
//      body: ConnectivityWidgetWrapper(
//        color: Color(0xffEF3651),
//        height: 30,
//        message: "Please check your internet connection!!",
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 40 * SizeConfig.heightMultiplier,
                width: double.infinity,
                child: Stack(children: [
                  Builder(builder: (context) {
                    height = MediaQuery.of(context).size.height;
                    width = MediaQuery.of(context).size.width;

                    return CarouselSlider(
                      options: CarouselOptions(
                          enableInfiniteScroll: false,
                          height: height,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          }),
                      items: imageSliders,
                    );
                  }),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 1.5 * SizeConfig.heightMultiplier,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.product.imgUrl.map((item) {
                          int index = widget.product.imgUrl.indexOf(item);
                          return Container(
                            width: 2.2 * SizeConfig.widthMultiplier,
                            height: 1.2 * SizeConfig.heightMultiplier,
                            margin: EdgeInsets.symmetric(
                                vertical: 1.5 * SizeConfig.heightMultiplier,
                                horizontal: 0.5 * SizeConfig.widthMultiplier),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == index
                                    ? Colors.white
                                    : Color(0xffEF3651)),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ]),
              ),
//            Container(
//              height: 300,
//              child: PhotoViewGallery.builder(
//                itemCount: widget.product.imgUrl.length,
//                builder: (context, index) {
//                  return PhotoViewGalleryPageOptions(
////                    imageProvider: NetworkImage(widget.product.imgUrl[index]),
//                    imageProvider: NetworkImage(widget.product.imgUrl[index]),
//
//                    minScale: PhotoViewComputedScale.contained * 0.8,
//                    maxScale: PhotoViewComputedScale.covered * 2,
//                  );
//                },
//                scrollPhysics: BouncingScrollPhysics(),
//                backgroundDecoration: BoxDecoration(
//                  color: Theme.of(context).canvasColor,
//                ),
//              ),
//            ),
              SizedBox(
                height: 3 * SizeConfig.heightMultiplier,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 3 * SizeConfig.widthMultiplier),
                child: Row(
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                        stream:
                            Firestore.instance.collection("shop").snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return const Text("Loading.....");
                          else {
                            List<DropdownMenuItem> sizeItems = [];
                            List<DropdownMenuItem> colorItems = [];
                            for (int i = 0;
                                i < widget.product.size.length;
                                i++) {
                              sizeItems.add(
                                DropdownMenuItem(
                                  child: Text(
//                                snapshot.data.documents[i]['size'][i],
                                      widget.product.size[i],
                                      style: TextStyle(
                                        color: Color(0xffEF3651),
                                        fontSize:
                                            2 * SizeConfig.heightMultiplier,
                                      )),
                                  value:
//                              "${snapshot.data.documents[i]['size'][i]}",
                                      "${widget.product.size[i]}",
                                ),
                              );
                            }
                            for (int i = 0;
                                i < widget.product.color.length;
                                i++) {
                              colorItems.add(
                                DropdownMenuItem(
                                  child: Text(widget.product.color[i],
                                      style: TextStyle(
                                        color: Color(0xffEF3651),
                                        fontSize:
                                            2 * SizeConfig.heightMultiplier,
                                      )),
                                  value: "${widget.product.color[i]}",
                                ),
                              );
                            }
                            return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3 * SizeConfig.widthMultiplier),
                                child: Container(
                                    width: 87 * SizeConfig.widthMultiplier,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                          height:
                                              6 * SizeConfig.heightMultiplier,
                                          width:
                                              36 * SizeConfig.widthMultiplier,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.7 *
                                                  SizeConfig.widthMultiplier),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                3 *
                                                    SizeConfig
                                                        .heightMultiplier),
                                            border: Border.all(
                                                color: Colors.grey,
                                                style: BorderStyle.solid,
                                                width: 0.2 *
                                                    SizeConfig.widthMultiplier),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,
                                              iconEnabledColor:
                                                  Theme.of(context)
                                                      .indicatorColor,
                                              iconSize: 3 *
                                                  SizeConfig.heightMultiplier,
                                              items: sizeItems,
                                              onChanged: (sizeValue) {
                                                setState(() {
                                                  selectedSize = sizeValue;
                                                  widget.product.selectedSize =
                                                      selectedSize;
                                                  print(
                                                      "selected Size: ${widget.product.selectedSize}");
                                                });
                                              },
                                              value: selectedSize,
                                              hint: new Text(
                                                AppLocalizations.of(context)
                                                    .translate('size'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .merge(TextStyle(
                                                      fontSize: 2 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height:
                                              6 * SizeConfig.heightMultiplier,
                                          width:
                                              36 * SizeConfig.widthMultiplier,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.7 *
                                                  SizeConfig.widthMultiplier),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                3 *
                                                    SizeConfig
                                                        .heightMultiplier),
                                            border: Border.all(
                                                color: Colors.grey,
                                                style: BorderStyle.solid,
                                                width: 0.2 *
                                                    SizeConfig.widthMultiplier),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,
                                              iconEnabledColor:
                                                  Theme.of(context)
                                                      .indicatorColor,
                                              iconSize: 3 *
                                                  SizeConfig.heightMultiplier,
                                              items: colorItems,
                                              onChanged: (colorValue) {
                                                setState(() {
                                                  selectedColor = colorValue;
                                                  widget.product.selectedColor =
                                                      selectedColor;
                                                  print(
                                                      "selected Size: ${widget.product.selectedColor}");
                                                });
                                              },
                                              value: selectedColor,
                                              hint: new Text(
                                                AppLocalizations.of(context)
                                                    .translate('color'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .merge(TextStyle(
                                                      fontSize: 2 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )));
                          }
                        }),
//                  ClipRRect(
//                    borderRadius:
//                        BorderRadius.circular(6 * SizeConfig.widthMultiplier),
//                    child: Container(
//                      height: 7 * SizeConfig.heightMultiplier,
//                      width: 7 * SizeConfig.heightMultiplier,
//                      color: Color(0xff2A2C36),
//                      child: IconButton(
//                        onPressed: () {
//                          _pressed();
////                        createFavorite();
//                        },
//                        icon: Icon(
//                          liked ? Icons.favorite : Icons.favorite_border,
//                          color: liked ? Colors.red : Colors.grey,
//                          size: 4 * SizeConfig.heightMultiplier,
//                        ),
//                      ),
//                    ),
//                  ),
                  ],
                ),
              ),
              SizedBox(
                height: 3 * SizeConfig.heightMultiplier,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 5.5 * SizeConfig.widthMultiplier),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          widget.product.brand,
                          style: Theme.of(context).textTheme.bodyText1.merge(
                                TextStyle(
                                  fontSize: 2.8 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        ),
                        Row(
                          children: <Widget>[
                            isExist
                                ? Row(
                                    children: <Widget>[
                                      appLanguage.appLocale == Locale('en')
                                          ? Text(
                                              "${toCurrency.format(widget.product.oldPrice)} ETB",
                                              style: TextStyle(
                                                fontSize: 2 *
                                                    SizeConfig.heightMultiplier,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.grey[300],
                                              ),
                                            )
                                          : Text(
                                              "${toCurrency.format(widget.product.oldPrice)} ብር",
                                              style: TextStyle(
                                                fontSize: 2 *
                                                    SizeConfig.heightMultiplier,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.grey[300],
                                              ),
                                            )
//
                                    ],
                                  )
                                : Row(
                                    children: <Widget>[
                                      appLanguage.appLocale == Locale('en')
                                          ? Text(
                                              "${toCurrency.format(widget.product.newPrice)} ETB",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .merge(
                                                    TextStyle(
                                                        fontSize: 2.8 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                            )
                                          : Text(
                                              "${toCurrency.format(widget.product.newPrice)} ብር",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .merge(
                                                    TextStyle(
                                                        fontSize: 2.8 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                            )
                                    ],
                                  ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      widget.product.category,
                      style: Theme.of(context).textTheme.subtitle1.merge(
                            TextStyle(
                              fontSize: 2 * SizeConfig.heightMultiplier,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                    ),
                    SizedBox(
                      height: 1.5 * SizeConfig.heightMultiplier,
                    ),
                    Container(
                      padding: new EdgeInsets.symmetric(
                          vertical: 1.5 * SizeConfig.heightMultiplier),
                      child: secondHalf.isEmpty
                          ? new Text(firstHalf)
                          : new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  flag
                                      ? (firstHalf + "...")
                                      : (firstHalf + secondHalf),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .merge(TextStyle(
                                          fontSize: 2.3 *
                                              SizeConfig.heightMultiplier)),
                                ),
                                SizedBox(
                                  height: 2 * SizeConfig.heightMultiplier,
                                ),
                                new InkWell(
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      new Text(
                                        flag
                                            ? AppLocalizations.of(context)
                                                .translate('showMore')
                                            : AppLocalizations.of(context)
                                                .translate('showLess'),
                                        style: TextStyle(
                                            color: Color(0xffEF3651),
                                            fontSize: 2.1 *
                                                SizeConfig.heightMultiplier),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      flag = !flag;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 3 * SizeConfig.heightMultiplier,
                                ),
                                AddToCartButton(
                                  widget: widget,
                                  triggerAlertBox: alertBox,
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({Key key, @required this.widget, this.triggerAlertBox})
      : super(key: key);

  final Detail widget;
  final Function triggerAlertBox;

  @override
  Widget build(BuildContext context) {
    final CartBloc cartBloc = Provider.of<CartBloc>(context);
    return MainButton(
      text: AppLocalizations.of(context).translate('addToCartButton'),
      onPressed: () {
        widget.product.selectedColor == null
            ? Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).accentColor,
                  content: Container(
                    height: 4 * SizeConfig.heightMultiplier,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: SizedBox(
//                            width: 300,
//                            height: 4 * SizeConfig.heightMultiplier,
                            child: AutoSizeText(
                              AppLocalizations.of(context)
                                  .translate('colorSnackBarText'),
                              style:
                                  Theme.of(context).textTheme.subtitle2.merge(
                                        TextStyle(
                                          fontSize:
                                              2.3 * SizeConfig.heightMultiplier,
                                        ),
                                      ),
                              maxLines: 2,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.close,
                          color: Color(0xffEF3651),
                          size: 3 * SizeConfig.heightMultiplier,
                        )
                      ],
                    ),
                  ),
                ),
              )
            : widget.product.selectedSize == null
                ? Scaffold.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).accentColor,
                      content: Container(
                        height: 4 * SizeConfig.heightMultiplier,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: SizedBox(
//                                height: 4 * SizeConfig.heightMultiplier,
//                                width: 300,
                                child: AutoSizeText(
                                  AppLocalizations.of(context)
                                      .translate('sizeSnackBarText'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .merge(
                                        TextStyle(
                                          fontSize:
                                              2.3 * SizeConfig.heightMultiplier,
                                        ),
                                      ),
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.close,
                              color: Color(0xffEF3651),
                              size: 3 * SizeConfig.heightMultiplier,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : triggerAlertBox(cartBloc);
      },
    );
  }
}
