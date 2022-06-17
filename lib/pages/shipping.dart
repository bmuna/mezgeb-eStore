import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mezgebestore/language/AppLanguage.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/pages/add_shipping_address.dart';
import 'package:mezgebestore/pages/payment.dart';
import 'package:mezgebestore/stores/business_name.dart';
import 'package:mezgebestore/stores/login_store.dart';
import 'package:mezgebestore/stores/size_config.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class Shipping extends StatefulWidget {
  static const String id = 'shipping_screen';
  final List order;
  final String aUserId;
  const Shipping({Key key, this.aUserId, this.order}) : super(key: key);
  @override
  _ShippingState createState() => _ShippingState();
}

class _ShippingState extends State<Shipping> {
  BusinessName businessName = BusinessName();
  bool showSpinner = false;
  int value;
  String phoneNumber;
  String place;
  String address;
  bool _isButtonDisabled;

  @override
  void initState() {
    super.initState();
    _isButtonDisabled = true;
//    setState(() {
//      getData();
//    });
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

  void allData() async {
    var ref = await Firestore.instance
        .collection("business")
        .document(businessName.name)
        .collection('orders')
        .document();
    ref.setData({
//      'item': widget.order,
      'phone': phoneNumber,
      'address': address,
      'place': place,
    });
  }

  Stream a() {}

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
            AppLocalizations.of(context).translate('shipping'),
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
                    builder: (_) => PaymentPage(),
                  ),
                  (Route<dynamic> route) => false);
            },
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  right: 2.5 * SizeConfig.heightMultiplier,
                  bottom: 0.7 * SizeConfig.heightMultiplier),
              child: SizedBox(
                height: 5.5 * SizeConfig.heightMultiplier,
                width: 5.5 * SizeConfig.heightMultiplier,
                child: FloatingActionButton(
                  backgroundColor: Color(0xffEF3651),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 3.2 * SizeConfig.textMultiplier,
                  ),
                  onPressed: () => {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => AddShippingAddress(),
                        ),
                        (Route<dynamic> route) => false)
                  },
                ),
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: getData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData || snapshot.data.documents.isEmpty) {
                  return Center(
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(150),
                          child: Image.asset('images/location.png',
                              width: 41 * SizeConfig.widthMultiplier,
                              height: 27 * SizeConfig.heightMultiplier,
                              fit: BoxFit.cover),
                        ),
                        SizedBox(
                          height: 3.1 * SizeConfig.heightMultiplier,
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate('emptyShipping'),
                          style: Theme.of(context).textTheme.bodyText1.merge(
                                TextStyle(
                                  fontSize: 2.9 * SizeConfig.textMultiplier,
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
                                  Text(
                                    "Please, add your address using",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .merge(TextStyle(
                                          fontSize:
                                              2 * SizeConfig.textMultiplier,
                                        )),
                                  ),
                                  Text("the plus button above.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .merge(TextStyle(
                                            fontSize:
                                                2 * SizeConfig.textMultiplier,
                                          )))
                                ],
                              )
                            : Column(
                                children: <Widget>[
                                  Text(
                                    "እባክዎን ከላይ ያለውን የመደመር ቁልፍ በመጠቀም",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .merge(TextStyle(
                                          fontSize:
                                              2 * SizeConfig.textMultiplier,
                                        )),
                                  ),
                                  Text("አድራሻዎን ያክሉ።",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .merge(TextStyle(
                                            fontSize:
                                                2 * SizeConfig.textMultiplier,
                                          )))
                                ],
                              )
                      ],
                    ),
                  );
                } else {
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
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
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
                                      2.7 * SizeConfig.heightMultiplier,
                                      1.2 * SizeConfig.heightMultiplier),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.grey,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
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
                                        Transform.scale(
                                          scale: 0.12 *
                                              SizeConfig.heightMultiplier,
                                          child: Radio(
                                            onChanged: (ind) {
                                              setState(() {
                                                value = ind;
                                                phoneNumber = snapshot.data
                                                    .documents[value]['phone'];
                                                place = snapshot.data
                                                    .documents[value]['place'];
                                                address = snapshot
                                                        .data.documents[value]
                                                    ['address'];
                                                _isButtonDisabled = false;
                                                print(phoneNumber);
                                                print(place);
                                                print(address);
                                              });
                                            },
                                            value: index,
                                            groupValue: value,
                                            activeColor:
                                                const Color(0xffEF3651),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
        bottomNavigationBar: StreamBuilder(
          stream: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container(
                height: 2.3 * SizeConfig.heightMultiplier,
              );

//            return Container(
//              child: Padding(
//                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
//                child: Material(
//                  elevation: 5.0,
//                  borderRadius: BorderRadius.circular(30.0),
//                  color: Color(0xffEF3651),
//                  child: MaterialButton(
//                    onPressed: () {
//                      Navigator.of(context).pushAndRemoveUntil(
//                          MaterialPageRoute(
//                            builder: (_) => AddShippingAddress(),
//                          ),
//                          (Route<dynamic> route) => false);
//                    },
//                    minWidth: double.infinity,
//                    height: 42.0,
//                    child: Text(
//                      'Add shipping address',
//                      style: TextStyle(
//                        color: Colors.white,
//                        fontWeight: FontWeight.bold,
//                        fontSize: 15,
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            );
            }
            return Container(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 2.5 * SizeConfig.heightMultiplier,
                  horizontal: 2.7 * SizeConfig.widthMultiplier,
                ),
                child: _isButtonDisabled
                    ? Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(
                          4.6 * SizeConfig.heightMultiplier,
                        ),
                        color: Colors.grey,
                        child: MaterialButton(
                          onPressed: null,
                          minWidth: double.infinity,
                          height: 6.5 * SizeConfig.textMultiplier,
                          child: Text(
                            AppLocalizations.of(context).translate("order"),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 2.3 * SizeConfig.textMultiplier,
                            ),
                          ),
                        ),
                      )
                    : Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(
                          4.6 * SizeConfig.heightMultiplier,
                        ),
                        color: Color(0xffEF3651),
                        child: MaterialButton(
                          onPressed: () {
//                          Navigator.of(context).pushAndRemoveUntil(
//                              MaterialPageRoute(
//                                builder: (_) => AddShippingAddress(),
//                              ),
//                              (Route<dynamic> route) => false);
                          },
                          minWidth: double.infinity,
                          height: 6.5 * SizeConfig.heightMultiplier,
                          child: Text(
                            AppLocalizations.of(context).translate("order"),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 2.3 * SizeConfig.textMultiplier,
                            ),
                          ),
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
//        child: Padding(
//          padding: const EdgeInsets.symmetric(horizontal: 10.0),
//          child: MainButton(
//            text: 'Add shipping address',
//            onPressed: () {
//              Navigator.of(context).pushAndRemoveUntil(
//                  MaterialPageRoute(builder: (_) => AddShippingAddress()),
//                  (Route<dynamic> route) => false);
//            },
//          ),
//        ),
