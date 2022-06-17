import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:mezgebestore/constant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mezgebestore/language/AppLanguage.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/models/shipping_out.dart';
import 'package:mezgebestore/pages/shipping.dart';
import 'package:mezgebestore/stores/business_name.dart';
import 'package:mezgebestore/stores/size_config.dart';
import 'package:mezgebestore/widgets/main_button.dart';
import 'package:provider/provider.dart';

class AddShippingAddress extends StatefulWidget {
  static const String id = 'AddShippingAddress_screen';

  final ShippingOut shipping;
  AddShippingAddress({this.shipping});
  @override
  _AddShippingAddressState createState() => _AddShippingAddressState();
}

class _AddShippingAddressState extends State<AddShippingAddress> {
  BusinessName businessName = BusinessName();

  String place;
  String phoneNumber;
  String address;
  GeoFirePoint myLocation;
  List<Marker> myMarker = [];
  LatLng tappedPoints;
  GoogleMapController _controller;
  final _formKey = GlobalKey<FormState>();
  var _userLocation = LatLng(8.9806, 38.7578);
  bool isLoading;
  String userId;

  var circle = Circle(
    circleId: CircleId("car"),
    zIndex: 1,
    strokeColor: Colors.blue,
    fillColor: Colors.blue.withAlpha(70),
  );

  @override
  void initState() {
    super.initState();
    getUser();
//    requestPermission();
    getLocationPermission();
    print('$userId');
  }

  @override
  void dispose() {
    super.dispose();
  }

  getLocationPermission() async {
    var location = new Location();
    try {
      location.requestPermission(); //to lunch location permission popup
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

  void getUser() async {
    userId = (await FirebaseAuth.instance.currentUser()).uid;
    print(userId);
  }

  getData() async {
    final geo = Geoflutterfire();
    myLocation = geo.point(
        latitude: tappedPoints.latitude, longitude: tappedPoints.longitude);
    var ref = Firestore.instance
        .collection("business")
        .document(businessName.name)
        .collection('users')
        .document(userId)
        .collection('shipping')
        .document();
    ref.setData({
      'place': place,
      'phone': phoneNumber,
      'address': address,
      'location': myLocation.geoPoint,
      'id': ref.documentID
    });
  }

  _handleTap(LatLng tappedPoint) {
    print(tappedPoint);
    tappedPoints = tappedPoint;
    setState(() {
      myMarker = [];
      myMarker.add(
        Marker(
            infoWindow: InfoWindow(
              title: "Hi, your shipping address is located here!",
            ),
            markerId: MarkerId(
              tappedPoint.toString(),
            ),
            position: tappedPoint,
            draggable: true,
            onDragEnd: (dragEndPosition) {
              print(dragEndPosition);
            }),
      );
    });
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

//  Location location = new Location();

  moveToTapped() async {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: tappedPoints, zoom: 14.0, bearing: 45.0, tilt: 45.0),
    ));
  }

  Future _mapFuture = Future.delayed(Duration(milliseconds: 500), () => true);

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
          bottomOpacity: 1,
          elevation: 3.0,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context).translate("newShippingAddress"),
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
                  MaterialPageRoute(builder: (_) => Shipping()),
                  (Route<dynamic> route) => false);
            },
          ),
        ),
        body: Center(
          child: FutureBuilder(
            future: _mapFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                print("empty");
                return CircularProgressIndicator();
              }
              return Column(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      height: 62 * SizeConfig.heightMultiplier,
                      child: Stack(
                        children: <Widget>[
                          GoogleMap(
                            myLocationEnabled: true,
                            mapToolbarEnabled: false,
                            initialCameraPosition: CameraPosition(
                              target: _userLocation,
                              zoom: 14.0,
                            ),
                            markers: Set.from(myMarker),
                            onTap: _handleTap,
                            onMapCreated: mapCreated,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 2.7 * SizeConfig.widthMultiplier,
                            ),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: 2.7 * SizeConfig.widthMultiplier,
                                  top: 7.8 * SizeConfig.heightMultiplier,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 11 * SizeConfig.widthMultiplier,
                                      child: GestureDetector(
                                        onTap: () {
                                          moveToTapped();
                                        },
                                        child: Material(
                                          elevation: 2.0,
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                              1.27 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                            child: Icon(
                                              Icons.map,
                                              size: 3.1 *
                                                  SizeConfig.heightMultiplier,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3.1 * SizeConfig.heightMultiplier,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.all(
                            1.5 * SizeConfig.heightMultiplier,
                          ),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
//                  keyboardType: TextInputType.emailAddress,
                                validator: (valName) => valName.isEmpty
                                    ? 'Please describe your place'
                                    : null,
                                onChanged: (valName) {
                                  setState(() => place = valName);
                                },
                                autofocus: false,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .merge(TextStyle(
                                      fontSize: 2.8 * SizeConfig.textMultiplier,
                                    )),
                                decoration: KTextFieldDecoration.copyWith(
                                  errorStyle: TextStyle(
                                    fontSize: 1.8 * SizeConfig.textMultiplier,
                                  ),
                                  labelText: AppLocalizations.of(context)
                                      .translate("describeYourPlace"),
                                  hintText: AppLocalizations.of(context)
                                      .translate("hintDescribePlace"),
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(
                                        TextStyle(
                                          fontWeight: FontWeight.w100,
                                          fontSize:
                                              2.3 * SizeConfig.textMultiplier,
                                        ),
                                      ),
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .merge(
                                        TextStyle(
                                          fontWeight: FontWeight.w100,
                                          fontSize:
                                              2.3 * SizeConfig.textMultiplier,
                                        ),
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: 3.1 * SizeConfig.heightMultiplier,
                              ),
                              TextFormField(
//                  keyboardType: TextInputType.emailAddress,
                                  validator: (valName) => valName.isEmpty
                                      ? 'Address is empty'
                                      : null,
                                  onChanged: (valName) {
                                    setState(() => address = valName);
                                  },
                                  autofocus: false,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(
                                        TextStyle(
                                          fontSize:
                                              2.8 * SizeConfig.textMultiplier,
                                        ),
                                      ),
                                  decoration: KTextFieldDecoration.copyWith(
                                      errorStyle: TextStyle(
                                        fontSize:
                                            1.8 * SizeConfig.textMultiplier,
                                      ),
                                      labelText: AppLocalizations.of(context)
                                          .translate("addressName"),
                                      hintText: AppLocalizations.of(context)
                                          .translate("hintAddressName"),
                                      labelStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .merge(
                                            TextStyle(
                                              fontWeight: FontWeight.w100,
                                              fontSize: 2.3 *
                                                  SizeConfig.textMultiplier,
                                            ),
                                          ),
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .merge(
                                            TextStyle(
                                              fontWeight: FontWeight.w100,
                                              fontSize: 2.3 *
                                                  SizeConfig.textMultiplier,
                                            ),
                                          ))),
                              SizedBox(
                                height: 3.1 * SizeConfig.heightMultiplier,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.phone,
                                validator: (valName) => valName.length != 10
                                    ? 'Phone number is incorrect'
                                    : null,
                                onChanged: (valName) {
                                  setState(() => phoneNumber = valName);
                                },
                                autofocus: false,
                                style:
                                    Theme.of(context).textTheme.bodyText1.merge(
                                          TextStyle(
                                            fontSize:
                                                2.8 * SizeConfig.textMultiplier,
                                          ),
                                        ),
                                decoration: KTextFieldDecoration.copyWith(
                                  errorStyle: TextStyle(
                                    fontSize: 1.8 * SizeConfig.textMultiplier,
                                  ),
                                  labelText: AppLocalizations.of(context)
                                      .translate("phone2"),
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .merge(
                                        TextStyle(
                                          fontWeight: FontWeight.w100,
                                          fontSize:
                                              2.3 * SizeConfig.textMultiplier,
                                        ),
                                      ),
                                  hintText: AppLocalizations.of(context)
                                      .translate("hintPhone"),
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .merge(
                                        TextStyle(
                                          fontWeight: FontWeight.w100,
                                          fontSize:
                                              2.3 * SizeConfig.textMultiplier,
                                        ),
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: 3.1 * SizeConfig.heightMultiplier,
                              ),
                              MainButton(
                                  text: AppLocalizations.of(context)
                                      .translate("saveAddress"),
                                  onPressed: () {
                                    if (tappedPoints == null) {
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor:
                                              Theme.of(context).accentColor,
                                          content: Container(
                                            height:
                                                6 * SizeConfig.heightMultiplier,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                appLanguage.appLocale ==
                                                        Locale('en')
                                                    ? Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child:
                                                                  AutoSizeText(
                                                                "Please point the shipping address by ",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .subtitle2
                                                                    .merge(TextStyle(
                                                                        fontSize:
                                                                            2.3 *
                                                                                SizeConfig.heightMultiplier)),
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  AutoSizeText(
                                                                "tapping on the map!!",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .subtitle2
                                                                    .merge(TextStyle(
                                                                        fontSize:
                                                                            2.3 *
                                                                                SizeConfig.heightMultiplier)),
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Expanded(
                                                        flex: 3,
                                                        child: SizedBox(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Expanded(
                                                                child:
                                                                    AutoSizeText(
                                                                  "እባክዎን በካርታው ላይ ጠቅ በማድረግ ",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .subtitle2
                                                                      .merge(TextStyle(
                                                                          fontSize:
                                                                              2.3 * SizeConfig.heightMultiplier)),
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    AutoSizeText(
                                                                  "የመላኪያ አድራሻውን ይጠቁሙ!!",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .subtitle2
                                                                      .merge(
                                                                        TextStyle(
                                                                            fontSize:
                                                                                2.3 * SizeConfig.heightMultiplier),
                                                                      ),
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                Icon(
                                                  Icons.close,
                                                  color: Color(0xffEF3651),
                                                  size: 3 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      if (_formKey.currentState.validate()) {
                                        getData();
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                  builder: (_) => Shipping(),
                                                ),
                                                (Route<dynamic> route) =>
                                                    false);
                                      }
                                    }
                                  }),
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
        ),
      ),
    );
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
