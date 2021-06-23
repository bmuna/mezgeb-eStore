import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mezgebestore/language/AppLanguage.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/pages/editAddressPage.dart';
import 'package:mezgebestore/pages/profile.dart';
import 'package:mezgebestore/stores/business_name.dart';
import 'package:mezgebestore/stores/size_config.dart';
import 'package:provider/provider.dart';

class EditAddress extends StatefulWidget {
  static const String id = 'editAddress_screen';

  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  BusinessName businessName = BusinessName();

  String userId;
  void getUser() async {
    userId = (await FirebaseAuth.instance.currentUser()).uid;
    print(userId);
  }

  @override
  void initState() {
    super.initState();
    getUser();
    print('$userId');
  }

  Stream<QuerySnapshot> getData() async* {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    yield* Firestore.instance
        .collection("business")
        .document(businessName.name)
        .collection('users')
        .document(user.uid)
        .collection('shipping')
        .snapshots();
  }

  deleteButton(BuildContext context, String value) async {
    print(value);
    print(userId);
    Firestore.instance
        .collection("business")
        .document(businessName.name)
        .collection("users")
        .document(userId)
        .collection('shipping')
        .document(value)
        .delete()
        .then((_) {
      print("success!");
    });

    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).accentColor,
      duration: Duration(milliseconds: 900),
      content: Container(
        height: 5 * SizeConfig.heightMultiplier,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).translate('delete'),
              style: Theme.of(context).textTheme.subtitle2.merge(
                  TextStyle(fontSize: 2.3 * SizeConfig.heightMultiplier)),
            ),
            Icon(
              Icons.check,
              color: Colors.green,
              size: 3 * SizeConfig.heightMultiplier,
            )
          ],
        ),
      ),
    ));
//    switch (value) {
//      case 'Delete':
//        break;
//      case 'Edit':
//        break;
//    }
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

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
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          bottomOpacity: 0.0,
          elevation: 3.0,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context).translate("editYourAddress"),
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
                    builder: (_) => Profile(),
                  ),
                  (Route<dynamic> route) => false);
            },
          ),
        ),
        body: Column(
          children: <Widget>[
            StreamBuilder(
                stream: getData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData || snapshot.data.documents.isEmpty) {
                    return Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            "No address",
                            style: TextStyle(
                              fontSize: 2.7 * SizeConfig.textMultiplier,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.7 * SizeConfig.widthMultiplier,
                              ),
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: 2.3 * SizeConfig.heightMultiplier,
                                ),
                                height: 15 * SizeConfig.heightMultiplier,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    1.5 * SizeConfig.heightMultiplier,
                                  ),
                                  color: Theme.of(context).backgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 4.0,
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      2.7 * SizeConfig.heightMultiplier,
                                      1.2 * SizeConfig.heightMultiplier,
                                      0 * SizeConfig.heightMultiplier,
                                      1.2 * SizeConfig.heightMultiplier),
                                  child: Stack(children: <Widget>[
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          cardColor: Colors.white,
                                        ),
                                        child: appLanguage.appLocale ==
                                                Locale('en')
                                            ? PopupMenuButton<String>(
                                                onSelected: (value) {
                                                  value == "Delete"
                                                      ? setState(() {
                                                          deleteButton(
                                                            context,
                                                            snapshot.data
                                                                    .documents[
                                                                index]['id'],
                                                          );
                                                        })
                                                      : setState(() {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EditAddressPage(
                                                                snapshot.data
                                                                        .documents[
                                                                    index]['place'],
                                                                snapshot.data
                                                                            .documents[
                                                                        index]
                                                                    ['address'],
                                                                snapshot.data
                                                                        .documents[
                                                                    index]['phone'],
                                                                snapshot.data
                                                                        .documents[
                                                                    index]['id'],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                },
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  return {'Edit', 'Delete'}
                                                      .map((String choice) {
                                                    return PopupMenuItem(
                                                      value: choice,
                                                      child: Text(
                                                        choice,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 0.2 *
                                                              SizeConfig
                                                                  .textMultiplier,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList();
                                                },
                                              )
                                            : PopupMenuButton<String>(
                                                onSelected: (value) {
                                                  value == "ሰርዝ"
                                                      ? setState(() {
                                                          deleteButton(
                                                            context,
                                                            snapshot.data
                                                                    .documents[
                                                                index]['id'],
                                                          );
                                                        })
                                                      : setState(() {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EditAddressPage(
                                                                snapshot.data
                                                                        .documents[
                                                                    index]['place'],
                                                                snapshot.data
                                                                            .documents[
                                                                        index]
                                                                    ['address'],
                                                                snapshot.data
                                                                        .documents[
                                                                    index]['phone'],
                                                                snapshot.data
                                                                        .documents[
                                                                    index]['id'],
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                },
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  return {'አስተካክል', 'ሰርዝ'}
                                                      .map((String choice) {
                                                    return PopupMenuItem(
                                                      value: choice,
                                                      child: Text(
                                                        choice,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 0.2 *
                                                              SizeConfig
                                                                  .textMultiplier,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList();
                                                },
                                              ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              AppLocalizations.of(context)
                                                  .translate("place"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .merge(
                                                    TextStyle(
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      fontSize: 2.1 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                    ),
                                                  ),
                                            ),
                                            SizedBox(
                                                width: 1.3 *
                                                    SizeConfig
                                                        .heightMultiplier),
                                            Text(
                                                '${snapshot.data.documents[index]['place']}'
                                                    .toUpperCase(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .merge(
                                                      TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 2.1 *
                                                            SizeConfig
                                                                .textMultiplier,
                                                      ),
                                                    ))
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      "addressEditYourAddress"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .merge(
                                                    TextStyle(
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      fontSize: 2.1 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                    ),
                                                  ),
                                            ),
                                            SizedBox(
                                                width: 1.3 *
                                                    SizeConfig
                                                        .heightMultiplier),
                                            Text(
                                                '${snapshot.data.documents[index]['address']}'
                                                    .toUpperCase(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .merge(
                                                      TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 2.1 *
                                                            SizeConfig
                                                                .textMultiplier,
                                                      ),
                                                    ))
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              AppLocalizations.of(context)
                                                  .translate("phone"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .merge(
                                                    TextStyle(
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      fontSize: 2.1 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                    ),
                                                  ),
                                            ),
                                            SizedBox(
                                                width: 1.3 *
                                                    SizeConfig
                                                        .heightMultiplier),
                                            Text(
                                                '${snapshot.data.documents[index]['phone']}'
                                                    .toUpperCase(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .merge(
                                                      TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 2.1 *
                                                            SizeConfig
                                                                .textMultiplier,
                                                      ),
                                                    ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
