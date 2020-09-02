import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:mezgebestore/constant.dart';
import 'package:mezgebestore/main_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mezgebestore/pages/maps.dart';
import 'package:mezgebestore/pages/shipping.dart';

class AddShippingAddress extends StatefulWidget {
  @override
  _AddShippingAddressState createState() => _AddShippingAddressState();
}

class _AddShippingAddressState extends State<AddShippingAddress> {
  GoogleMapController mapController;
  String place;
  String phoneNumber;
  String address;
  List<Marker> myMarker = [];
  LatLng tappedPoints;
  GoogleMapController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    print('$userId');
  }

  String userId;
  getData() async {
    final geo = Geoflutterfire();
    GeoFirePoint myLocation = geo.point(
        latitude: tappedPoints.latitude, longitude: tappedPoints.longitude);
    userId = (await FirebaseAuth.instance.currentUser()).uid;
    return Firestore.instance
        .collection('users')
        .document(userId)
        .collection('shipping')
        .add({
      'place': place,
      'phone': phoneNumber,
      'address': address,
      'location': myLocation.geoPoint,
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

  Location location = new Location();
  moveToTapped() async {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: tappedPoints, zoom: 14.0, bearing: 45.0, tilt: 45.0),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: Text('New shipping address'),
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.arrowLeft),
          iconSize: 18,
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => Shipping()),
                (Route<dynamic> route) => false);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: Container(
              height: 400,
              child: Stack(
                children: <Widget>[
                  GoogleMap(
                    mapToolbarEnabled: false,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(8.9806, 38.7578), zoom: 14.0),
                    markers: Set.from(myMarker),
                    onTap: _handleTap,
                    onMapCreated: mapCreated,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: RawMaterialButton(
                        onPressed: () {
                          moveToTapped();
                        },
                        elevation: 2.0,
                        fillColor: Colors.blue,
                        child: Icon(
                          Icons.map,
                          size: 15.0,
                        ),
                        padding: EdgeInsets.all(6.0),
                        shape: CircleBorder(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
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
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Color(0xffF7F7F7),
                        ),
                        decoration: KTextFieldDecoration.copyWith(
                          labelText: 'Describe your place',
                          hintText: 'e.g: edna-mall 5th floor',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 15,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
//                  keyboardType: TextInputType.emailAddress,
                        validator: (valName) =>
                            valName.isEmpty ? 'Address is empty' : null,
                        onChanged: (valName) {
                          setState(() => address = valName);
                        },
                        autofocus: false,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Color(0xffF7F7F7),
                        ),
                        decoration: KTextFieldDecoration.copyWith(
                          labelText: 'Address name',
                          hintText: 'eg: home, office etc',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 15,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
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
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Color(0xffF7F7F7),
                        ),
                        decoration: KTextFieldDecoration.copyWith(
                          labelText: 'Phone number',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          hintText: 'eg: 0900000000',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 15,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Column(
                        children: <Widget>[
                          MainButton(
                            text: 'Save address',
                            onPressed: () async {
                              getData();
                              if (_formKey.currentState.validate()) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (_) => Maps()),
                                    (Route<dynamic> route) => false);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
