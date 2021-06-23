import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mezgebestore/language/AppLanguage.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/models/check_out.dart';
import 'package:mezgebestore/pages/detail.dart';
import 'package:mezgebestore/pages/navbar_controller.dart';
import 'package:mezgebestore/pages/newGridViewPage.dart';
import 'package:mezgebestore/pages/saleGridViewPAge.dart';
import 'package:mezgebestore/stores/business_name.dart';
import 'package:mezgebestore/stores/size_config.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static const String id = 'Home_screen';

  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String text = "Fashion";
  final databaseReference = Firestore.instance;
//  String businessName = "mezgebTest";
  BusinessName businessName = BusinessName();

  Future<DocumentSnapshot> getSaleTagNameEn() async {
    return await Firestore.instance
        .collection("business")
        .document(businessName.name)
        .collection("homePageSale")
        .document("sale")
        .collection('en')
        .document("sale")
        .get();
  }

  Future<DocumentSnapshot> getSaleTagNameAm() async {
    return await Firestore.instance
        .collection("business")
        .document(businessName.name)
        .collection("homePageSale")
        .document("sale")
        .collection('am')
        .document("sale")
        .get();
  }

  void getNewDataEn() async {
    await for (var messages in databaseReference
        .collection("business")
        .document(businessName.name)
        .collection("shop")
        .document("language")
        .collection("en")
        .where("tag", isEqualTo: 'new')
        .limit(3)
        .snapshots()) {
      for (var message in messages.documents) {
        CheckOutData hold = CheckOutData(
          id: message.data['id'],
          imgUrl: message.data['image'],
          newPrice: message.data['newPrice'],
          brand: message.data['brand'],
          description: message.data['description'],
          size: message.data['size'],
          color: message.data['color'],
          oldPrice: message.data['oldPrice'],
          category: message.data['category'],
        );
        dataNewListEn.add(hold);
      }
      setState(() {});
    }
  }

  void getNewDataAm() async {
    await for (var messages in databaseReference
        .collection("business")
        .document(businessName.name)
        .collection("shop")
        .document("language")
        .collection("am")
        .where("tag", isEqualTo: 'new')
        .limit(3)
        .snapshots()) {
      for (var message in messages.documents) {
        CheckOutData hold = CheckOutData(
          id: message.data['id'],
          imgUrl: message.data['image'],
          newPrice: message.data['newPrice'],
          brand: message.data['brand'],
          description: message.data['description'],
          size: message.data['size'],
          color: message.data['color'],
          oldPrice: message.data['oldPrice'],
          category: message.data['category'],
        );
        dataNewListAm.add(hold);
      }
      setState(() {});
    }
  }

  void getSaleDataEn() async {
    await for (var messages in databaseReference
        .collection("business")
        .document(businessName.name)
        .collection("shop")
        .document("language")
        .collection("en")
        .where("tag", isEqualTo: 'sale')
        .limit(3)
        .snapshots()) {
      for (var message in messages.documents) {
        CheckOutData hold = CheckOutData(
          category: message.data["category"],
          id: message.data['id'],
          imgUrl: message.data['image'],
          newPrice: message.data['newPrice'],
          brand: message.data['brand'],
          description: message.data['description'],
          size: message.data['size'],
          color: message.data['color'],
          oldPrice: message.data['oldPrice'],
        );
        dataSaleListEn.add(hold);
      }
      setState(() {});
    }
  }

  void getSaleDataAm() async {
    await for (var messages in databaseReference
        .collection("business")
        .document(businessName.name)
        .collection("shop")
        .document("language")
        .collection("am")
        .where("tag", isEqualTo: 'sale')
        .limit(3)
        .snapshots()) {
      for (var message in messages.documents) {
        CheckOutData hold = CheckOutData(
          category: message.data["category"],
          id: message.data['id'],
          imgUrl: message.data['image'],
          newPrice: message.data['newPrice'],
          brand: message.data['brand'],
          description: message.data['description'],
          size: message.data['size'],
          color: message.data['color'],
          oldPrice: message.data['oldPrice'],
        );
        dataSaleListAm.add(hold);
      }
      setState(() {});
    }
  }

  List<CheckOutData> dataNewListEn = [];
  List<CheckOutData> dataSaleListEn = [];
  List<CheckOutData> dataNewListAm = [];
  List<CheckOutData> dataSaleListAm = [];

  navigateToDetail(CheckOutData post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Detail(
          product: post,
        ),
      ),
    );
  }

  Future<DocumentSnapshot> getBannerEn() async {
    return await Firestore.instance
        .collection("business")
        .document(businessName.name)
        .collection("homePageBanner")
        .document("banner")
        .collection('en')
        .document('banner')
        .get();
  }

  Future<DocumentSnapshot> getBannerAm() async {
    return await Firestore.instance
        .collection("business")
        .document(businessName.name)
        .collection("homePageBanner")
        .document("banner")
        .collection('am')
        .document('banner')
        .get();
  }

  @override
  void initState() {
    super.initState();
    getNewDataEn();
    getNewDataAm();
    getSaleDataEn();
    getSaleDataAm();
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    final NumberFormat toCurrency = NumberFormat("#,##0", "en_US");
    return Scaffold(
//      extendBody: true,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            appLanguage.appLocale == Locale('en')
                ? Stack(children: <Widget>[
                    FutureBuilder(
                      future: getBannerEn(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        var userDocument = snapshot.data;
                        return Container(
                          height: 133 * SizeConfig.imageSizeMultiplier,
                          child: Stack(
                            children: <Widget>[
                              CachedNetworkImage(
                                height: 133 * SizeConfig.imageSizeMultiplier,
                                placeholder: (context, url) => Container(
                                  height: 133 * SizeConfig.imageSizeMultiplier,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => Center(
                                  child: Container(
                                    height:
                                        133 * SizeConfig.imageSizeMultiplier,
                                    child: Icon(
                                      Icons.error,
                                      size: 4.6 * SizeConfig.heightMultiplier,
                                    ),
                                  ),
                                ),
                                imageUrl: userDocument['image'],
                                fit: BoxFit.cover,
                              ),
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 82 * SizeConfig.imageSizeMultiplier,
                                      right: 3 * SizeConfig.heightMultiplier,
                                      left: 3 * SizeConfig.heightMultiplier,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          userDocument['header1'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .merge(
                                                TextStyle(
                                                  fontSize: 5 *
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                        ),
                                        Text(
                                          userDocument['header2'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .merge(
                                                TextStyle(
                                                  fontSize: 5 *
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                        ),
                                        SizedBox(
                                          height:
                                              2 * SizeConfig.heightMultiplier,
                                        ),
                                        ButtonTheme(
                                          minWidth:
                                              40 * SizeConfig.widthMultiplier,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4 *
                                                      SizeConfig
                                                          .heightMultiplier),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BottomNavigationBarController(
                                                    selectedIndex: 1,
                                                  ),
                                                ),
                                              );
                                            },
                                            color: Color(0xffEF3651),
                                            textColor: Colors.white,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 1 *
                                                      SizeConfig
                                                          .heightMultiplier),
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .translate('checkButton'),
                                                style: TextStyle(
                                                  fontSize: 2 *
                                                      SizeConfig.textMultiplier,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ])
                : Stack(children: <Widget>[
                    FutureBuilder(
                      future: getBannerAm(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        var userDocument = snapshot.data;
                        return Container(
                          height: 133 * SizeConfig.imageSizeMultiplier,
                          child: Stack(
                            children: <Widget>[
                              CachedNetworkImage(
                                height: 133 * SizeConfig.imageSizeMultiplier,
                                placeholder: (context, url) => Container(
                                  height: 133 * SizeConfig.imageSizeMultiplier,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => Center(
                                  child: Container(
                                    height:
                                        133 * SizeConfig.imageSizeMultiplier,
                                    child: Icon(
                                      Icons.error,
                                      size: 4.6 * SizeConfig.heightMultiplier,
                                    ),
                                  ),
                                ),
                                imageUrl: userDocument['image'],
                                fit: BoxFit.cover,
                              ),
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 82 * SizeConfig.imageSizeMultiplier,
                                      right: 3 * SizeConfig.heightMultiplier,
                                      left: 3 * SizeConfig.heightMultiplier,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          userDocument['header1'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .merge(
                                                TextStyle(
                                                  fontSize: 5 *
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                        ),
                                        Text(
                                          userDocument['header2'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .merge(
                                                TextStyle(
                                                  fontSize: 5 *
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                        ),
                                        SizedBox(
                                          height:
                                              2 * SizeConfig.heightMultiplier,
                                        ),
                                        ButtonTheme(
                                          minWidth:
                                              40 * SizeConfig.widthMultiplier,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4 *
                                                      SizeConfig
                                                          .heightMultiplier),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BottomNavigationBarController(
                                                    selectedIndex: 1,
                                                  ),
                                                ),
                                              );
                                            },
                                            color: Color(0xffEF3651),
                                            textColor: Colors.white,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 1 *
                                                      SizeConfig
                                                          .heightMultiplier),
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .translate('checkButton'),
                                                style: TextStyle(
                                                  fontSize: 2 *
                                                      SizeConfig.textMultiplier,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ]),
            SizedBox(
              height: 12 * SizeConfig.heightMultiplier,
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 3 * SizeConfig.heightMultiplier,
                left: 3 * SizeConfig.heightMultiplier,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('new'),
                    style: Theme.of(context).textTheme.bodyText1.merge(
                          TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 3 * SizeConfig.textMultiplier,
                          ),
                        ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavigationBarController(
                            selectedIndex: 1,
                          ),
                        ),
                      );
                    },
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewPage()),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context).translate('viewAll'),
                        style: Theme.of(context).textTheme.bodyText1.merge(
                              TextStyle(
                                fontSize: 2 * SizeConfig.textMultiplier,
                              ),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            appLanguage.appLocale == Locale('en')
                ? Container(
                    height: 48 * SizeConfig.heightMultiplier,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: dataNewListEn.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 44 * SizeConfig.heightMultiplier,
                          child: GestureDetector(
                            onTap: () {
                              navigateToDetail(dataNewListEn[index]);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 1 * SizeConfig.heightMultiplier,
                              ),
                              child: Container(
                                margin: EdgeInsets.all(
                                  2 * SizeConfig.heightMultiplier,
                                ),
                                width: 53 * SizeConfig.widthMultiplier,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(0.0, 2.0),
                                            blurRadius:
                                                1 * SizeConfig.heightMultiplier,
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Stack(
                                            children: <Widget>[
                                              CachedNetworkImage(
                                                height: 28 *
                                                    SizeConfig.heightMultiplier,
                                                width: 58 *
                                                    SizeConfig.widthMultiplier,
                                                placeholder: (context, url) =>
                                                    Container(
                                                  height: 28 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  width: 58 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  alignment: Alignment.center,
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Center(
                                                  child: Container(
                                                    height: 28 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    width: 58 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    child: Icon(
                                                      Icons.error,
                                                      size: 4.6 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                    ),
                                                  ),
                                                ),
                                                imageUrl: dataNewListEn[index]
                                                    .imgUrl[0],
                                                fit: BoxFit.fill,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 58 * SizeConfig.widthMultiplier,
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          1.5 * SizeConfig.heightMultiplier,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              dataNewListEn[index].brand,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .merge(
                                                    TextStyle(
                                                      fontSize: 2 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                    ),
                                                  ),
                                            ),
//                                                SizedBox(
//                                                  height: 0.5 *
//                                                      SizeConfig
//                                                          .heightMultiplier,
//                                                ),
                                            Text(
                                              dataNewListEn[index].category,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .merge(
                                                    TextStyle(
                                                      fontSize: 2.1 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                            ),
//                                                SizedBox(
//                                                  height: 0.5 *
//                                                      SizeConfig
//                                                          .heightMultiplier,
//                                                ),
                                            Text(
                                              "${toCurrency.format(dataNewListEn[index].newPrice)} ETB",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .merge(
                                                    TextStyle(
                                                      fontSize: 2.3 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    height: 48 * SizeConfig.heightMultiplier,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: dataNewListAm.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 44 * SizeConfig.heightMultiplier,
                          child: GestureDetector(
                            onTap: () {
                              navigateToDetail(dataNewListAm[index]);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 1 * SizeConfig.heightMultiplier,
                              ),
                              child: Container(
                                margin: EdgeInsets.all(
                                  2 * SizeConfig.heightMultiplier,
                                ),
                                width: 53 * SizeConfig.widthMultiplier,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(0.0, 2.0),
                                            blurRadius:
                                                1 * SizeConfig.heightMultiplier,
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Stack(
                                            children: <Widget>[
                                              CachedNetworkImage(
                                                height: 28 *
                                                    SizeConfig.heightMultiplier,
                                                width: 58 *
                                                    SizeConfig.widthMultiplier,
                                                placeholder: (context, url) =>
                                                    Container(
                                                  height: 28 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  width: 58 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  alignment: Alignment.center,
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Center(
                                                  child: Container(
                                                    height: 28 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    width: 58 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    child: Icon(
                                                      Icons.error,
                                                      size: 4.6 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                    ),
                                                  ),
                                                ),
                                                imageUrl: dataNewListAm[index]
                                                    .imgUrl[0],
                                                fit: BoxFit.fill,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 58 * SizeConfig.widthMultiplier,
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          1.5 * SizeConfig.heightMultiplier,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              dataNewListAm[index].brand,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .merge(
                                                    TextStyle(
                                                      fontSize: 2 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                    ),
                                                  ),
                                            ),
//                                                SizedBox(
//                                                  height: 0.5 *
//                                                      SizeConfig
//                                                          .heightMultiplier,
//                                                ),
                                            Text(
                                              dataNewListAm[index].category,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .merge(
                                                    TextStyle(
                                                      fontSize: 2.1 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                            ),
//                                                SizedBox(
//                                                  height: 0.5 *
//                                                      SizeConfig
//                                                          .heightMultiplier,
//                                                ),
                                            Text(
                                              "${toCurrency.format(dataNewListAm[index].newPrice)} ETB",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .merge(
                                                    TextStyle(
                                                      fontSize: 2.3 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            Padding(
              padding: EdgeInsets.only(
                right: 3 * SizeConfig.heightMultiplier,
                left: 3 * SizeConfig.heightMultiplier,
              ),
              child: appLanguage.appLocale == Locale('en')
                  ? FutureBuilder(
                      future: getSaleTagNameEn(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData || !snapshot.data.exists) {
                          return Container();
                        }
                        var userDocument = snapshot.data;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              userDocument['name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .merge(
                                    TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 3 * SizeConfig.textMultiplier,
                                    ),
                                  ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BottomNavigationBarController(
                                      selectedIndex: 1,
                                    ),
                                  ),
                                );
                              },
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SalePage()),
                                  );
                                },
                                child: Text(
                                  userDocument['buttonName'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(
                                        TextStyle(
                                          fontSize:
                                              2 * SizeConfig.textMultiplier,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ],
                        );
                      })
                  : FutureBuilder(
                      future: getSaleTagNameAm(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData || !snapshot.data.exists) {
                          return Container();
                        }
                        var userDocument = snapshot.data;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              userDocument['name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .merge(
                                    TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 3 * SizeConfig.textMultiplier,
                                    ),
                                  ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BottomNavigationBarController(
                                      selectedIndex: 1,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                userDocument['buttonName'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .merge(
                                      TextStyle(
                                        fontSize: 2 * SizeConfig.textMultiplier,
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        );
                      }),
            ),
            SizedBox(
              height: 10,
            ),
            appLanguage.appLocale == Locale('en')
                ? Padding(
                    padding: EdgeInsets.only(
                      bottom: 8 * SizeConfig.heightMultiplier,
                    ),
                    child: Container(
                      height: 48 * SizeConfig.heightMultiplier,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: dataSaleListEn.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 44 * SizeConfig.heightMultiplier,
                            child: GestureDetector(
                              onTap: () {
                                navigateToDetail(dataSaleListEn[index]);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 1 * SizeConfig.heightMultiplier,
                                ),
                                child: Container(
                                  margin: EdgeInsets.all(
                                    2 * SizeConfig.heightMultiplier,
                                  ),
                                  width: 53 * SizeConfig.widthMultiplier,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(0.0, 2.0),
                                              blurRadius: 1 *
                                                  SizeConfig.heightMultiplier,
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Stack(
                                              children: <Widget>[
                                                CachedNetworkImage(
                                                  height: 28 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  width: 58 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    height: 28 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    width: 58 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    alignment: Alignment.center,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Center(
                                                    child: Container(
                                                      height: 28 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      width: 58 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                      child: Icon(
                                                        Icons.error,
                                                        size: 4.6 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                      ),
                                                    ),
                                                  ),
                                                  imageUrl:
                                                      dataSaleListEn[index]
                                                          .imgUrl[0],
                                                  fit: BoxFit.fill,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 58 * SizeConfig.widthMultiplier,
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                            1.5 * SizeConfig.heightMultiplier,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                dataSaleListEn[index].brand,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    .merge(
                                                      TextStyle(
                                                        fontSize: 2 *
                                                            SizeConfig
                                                                .textMultiplier,
                                                      ),
                                                    ),
                                              ),
//                                                  SizedBox(
//                                                    height: 0.5 *
//                                                        SizeConfig
//                                                            .heightMultiplier,
//                                                  ),
                                              Text(
                                                dataSaleListEn[index].category,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .merge(
                                                      TextStyle(
                                                        fontSize: 2.1 *
                                                            SizeConfig
                                                                .textMultiplier,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                              ),
//                                                  SizedBox(
//                                                    height: 0.5 *
//                                                        SizeConfig
//                                                            .heightMultiplier,
//                                                  ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Flexible(
                                                    child: Container(
                                                      child: Text(
                                                        "${toCurrency.format(dataSaleListEn[index].oldPrice)} ETB",
                                                        overflow: TextOverflow
                                                            .ellipsis,
//                                                        overflow:
//                                                            TextOverflow.fade,
//                                                        maxLines: 1,
//                                                        softWrap: false,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle1
                                                            .merge(
                                                              TextStyle(
                                                                fontSize: 2.1 *
                                                                    SizeConfig
                                                                        .textMultiplier,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ),
//                                                      SizedBox(
//                                                        width: 10.0,
//                                                      ),
                                                  Text(
                                                    "${toCurrency.format(dataSaleListEn[index].newPrice)} ETB",
                                                    style: TextStyle(
                                                      fontSize: 2.3 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(
                                                        0xffEF3651,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(
                      bottom: 8 * SizeConfig.heightMultiplier,
                    ),
                    child: Container(
                      height: 48 * SizeConfig.heightMultiplier,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: dataSaleListAm.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 46 * SizeConfig.heightMultiplier,
                            child: GestureDetector(
                              onTap: () {
                                navigateToDetail(dataSaleListAm[index]);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 1 * SizeConfig.heightMultiplier,
                                ),
                                child: Container(
                                  margin: EdgeInsets.all(
                                    2 * SizeConfig.heightMultiplier,
                                  ),
                                  width: 55 * SizeConfig.widthMultiplier,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(0.0, 2.0),
                                              blurRadius: 1 *
                                                  SizeConfig.heightMultiplier,
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Stack(
                                              children: <Widget>[
                                                CachedNetworkImage(
                                                  height: 28 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  width: 58 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    height: 28 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    width: 58 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    alignment: Alignment.center,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Center(
                                                    child: Container(
                                                      height: 28 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      width: 58 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                      child: Icon(
                                                        Icons.error,
                                                        size: 4.6 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                      ),
                                                    ),
                                                  ),
                                                  imageUrl:
                                                      dataSaleListAm[index]
                                                          .imgUrl[0],
                                                  fit: BoxFit.fill,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 58 * SizeConfig.widthMultiplier,
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                            1.5 * SizeConfig.heightMultiplier,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                dataSaleListAm[index].brand,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1
                                                    .merge(
                                                      TextStyle(
                                                        fontSize: 2 *
                                                            SizeConfig
                                                                .textMultiplier,
                                                      ),
                                                    ),
                                              ),
//                                                  SizedBox(
//                                                    height: 0.5 *
//                                                        SizeConfig
//                                                            .heightMultiplier,
//                                                  ),
                                              Text(
                                                dataSaleListAm[index].category,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .merge(
                                                      TextStyle(
                                                        fontSize: 2.1 *
                                                            SizeConfig
                                                                .textMultiplier,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                              ),
//                                                  SizedBox(
//                                                    height: 0.5 *
//                                                        SizeConfig
//                                                            .heightMultiplier,
//                                                  ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Flexible(
                                                    child: Container(
                                                      child: Text(
                                                        "${toCurrency.format(dataSaleListAm[index].oldPrice)} ብር",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle1
                                                            .merge(
                                                              TextStyle(
                                                                fontSize: 2.1 *
                                                                    SizeConfig
                                                                        .textMultiplier,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ),
//                                                      SizedBox(
//                                                        width: 10.0,
//                                                      ),
                                                  Text(
                                                    "${toCurrency.format(dataSaleListAm[index].newPrice)} ብር",
                                                    style: TextStyle(
                                                      fontSize: 2.3 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(
                                                        0xffEF3651,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
