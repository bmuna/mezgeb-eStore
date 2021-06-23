import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mezgebestore/language/AppLanguage.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/models/check_out.dart';
import 'package:mezgebestore/pages/detail.dart';
import 'package:mezgebestore/pages/navbar_controller.dart';
import 'package:mezgebestore/stores/business_name.dart';
import 'package:mezgebestore/stores/size_config.dart';
import 'package:provider/provider.dart';

class SalePage extends StatefulWidget {
  static const String id = 'newPage_screen';

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<SalePage> {
  List<CheckOutData> _list;
  BusinessName businessName = BusinessName();

  void initState() {
    super.initState();
    init();
  }

  void init() {
    _list = List();
  }

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

  @override
  Widget build(BuildContext context) {
    final NumberFormat toCurrency = NumberFormat("#,##0", "en_US");
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          bottomOpacity: 1,
          elevation: 3.0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            AppLocalizations.of(context).translate('sale'),
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
        body: appLanguage.appLocale == Locale('en')
            ? StreamBuilder(
                stream: Firestore.instance
                    .collection("business")
                    .document(businessName.name)
                    .collection('shop')
                    .document("language")
                    .collection("en")
                    .where('tag', isEqualTo: 'sale')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  return GridView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          Container(
                            child: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  final items = snapshot.data.documents;
                                  for (var item in items) {
                                    setState(() {
                                      CheckOutData hold = CheckOutData(
                                        id: item.data['id'],
                                        imgUrl: item.data['image'],
                                        newPrice: item.data['newPrice'],
                                        brand: item.data['brand'],
                                        category: item.data['category'],
                                        description: item.data['description'],
                                        size: item.data['size'],
                                        color: item.data['color'],
                                        oldPrice: item.data['oldPrice'],
                                      );
                                      _list.add(hold);
                                    });
                                  }
                                  navigateToDetail(_list[index]);
                                  _list.clear();
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    0.7 * SizeConfig.heightMultiplier,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius:
                                              0.6 * SizeConfig.heightMultiplier,
                                        )
                                      ],
                                    ),
                                    child: CachedNetworkImage(
                                      height: 20 * SizeConfig.heightMultiplier,
                                      placeholder: (context, url) => Container(
                                        height:
                                            20 * SizeConfig.heightMultiplier,
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Center(
                                        child: Container(
                                          height:
                                              20 * SizeConfig.heightMultiplier,
                                          child: Icon(
                                            Icons.error,
                                            size: 4.6 *
                                                SizeConfig.heightMultiplier,
                                          ),
                                        ),
                                      ),
                                      imageUrl: snapshot.data.documents[index]
                                          ['image'][0],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 1.5 * SizeConfig.widthMultiplier,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data.documents[index]['brand'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .merge(
                                          TextStyle(
                                            fontSize:
                                                2.5 * SizeConfig.textMultiplier,
                                          ),
                                        ),
                                  ),
                                  Text(
                                    snapshot.data.documents[index]['category'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .merge(
                                          TextStyle(
                                            fontSize:
                                                2.6 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "${toCurrency.format(snapshot.data.documents[index]['newPrice'])} ETB",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .merge(
                                              TextStyle(
                                                fontSize: 2.8 *
                                                    SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
//
                        ],
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                    ),
                  );
                },
              )
            : StreamBuilder(
                stream: Firestore.instance
                    .collection("business")
                    .document(businessName.name)
                    .collection('shop')
                    .document("language")
                    .collection("am")
                    .where('tag', isEqualTo: 'sale')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  return GridView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          Container(
                            child: Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  final items = snapshot.data.documents;
                                  for (var item in items) {
                                    setState(() {
                                      CheckOutData hold = CheckOutData(
                                        id: item.data['id'],
                                        imgUrl: item.data['image'],
                                        newPrice: item.data['newPrice'],
                                        brand: item.data['brand'],
                                        category: item.data['category'],
                                        description: item.data['description'],
                                        size: item.data['size'],
                                        color: item.data['color'],
                                        oldPrice: item.data['oldPrice'],
                                      );
                                      _list.add(hold);
                                    });
                                  }
                                  navigateToDetail(_list[index]);
                                  _list.clear();
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    0.7 * SizeConfig.heightMultiplier,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius:
                                              0.6 * SizeConfig.heightMultiplier,
                                        )
                                      ],
                                    ),
                                    child: CachedNetworkImage(
                                      height: 20 * SizeConfig.heightMultiplier,
                                      placeholder: (context, url) => Container(
                                        height:
                                            20 * SizeConfig.heightMultiplier,
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        height:
                                            20 * SizeConfig.heightMultiplier,
                                        child: Icon(
                                          Icons.error,
                                          size:
                                              4.6 * SizeConfig.heightMultiplier,
                                        ),
                                      ),
                                      imageUrl: snapshot.data.documents[index]
                                          ['image'][0],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 1.5 * SizeConfig.widthMultiplier,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data.documents[index]['brand'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .merge(
                                          TextStyle(
                                            fontSize:
                                                2.5 * SizeConfig.textMultiplier,
                                          ),
                                        ),
                                  ),
                                  Text(
                                    snapshot.data.documents[index]['category'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .merge(
                                          TextStyle(
                                            fontSize:
                                                2.6 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "${toCurrency.format(snapshot.data.documents[index]['newPrice'])} ብር",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .merge(
                                              TextStyle(
                                                fontSize: 2.8 *
                                                    SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
//
                        ],
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                    ),
                  );
                },
              ));
  }
}
