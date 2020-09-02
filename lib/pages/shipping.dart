import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mezgebestore/main_button.dart';
import 'package:mezgebestore/pages/add_shipping_address.dart';
import 'package:mezgebestore/pages/payment.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Shipping extends StatefulWidget {
  final List order;
  final String aUserId;
  const Shipping({Key key, this.aUserId, this.order}) : super(key: key);
  @override
  _ShippingState createState() => _ShippingState();
}

class _ShippingState extends State<Shipping> {
  bool showSpinner = false;
  int value;
  String phoneNumber;
  String place;
  String address;

  @override
  void initState() {
    super.initState();
    setState(() {
      getData();
    });
  }

  Stream<QuerySnapshot> getData() async* {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    yield* Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('shipping')
        .snapshots();
  }

  void allData() async {
    var ref = await Firestore.instance.collection('orders').document();
    ref.setData({
//      'item': widget.order,
      'phone': phoneNumber,
      'address': address,
      'place': place,
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Shipping'),
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.arrowLeft),
          iconSize: 18,
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => PaymentPage()),
                (Route<dynamic> route) => false);
          },
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              StreamBuilder(
                stream: getData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 100.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(
                                0xff2A2C36,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
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
                                              'Place:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              '${snapshot.data.documents[index]['place']}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w100),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              'Address:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              '${snapshot.data.documents[index]['address']}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w100),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              'Phone No. :',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              '${snapshot.data.documents[index]['phone']}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w100),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Radio(
                                      onChanged: (ind) {
                                        setState(() {
                                          value = ind;
                                          phoneNumber = snapshot
                                              .data.documents[value]['phone'];
                                          place = snapshot.data.documents[value]
                                              ['place'];
                                          address = snapshot
                                              .data.documents[value]['address'];
                                          print(phoneNumber);
                                          print(place);
                                          print(address);
                                        });
                                      },
                                      value: index,
                                      groupValue: value,
                                      activeColor: const Color(0xffEF3651),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Column(
                children: <Widget>[
//                DottedBorder(
//                  dashPattern: [8, 4],
//                  color: Color(0xffEF3651),
//                  strokeWidth: 1,
//                  child: Container(
//                    height: 42.0,
//                    width: double.infinity,
//                    child: Center(
//                      child: Text(
//                        'Add Address',
//                        textAlign: TextAlign.center,
//                      ),
//                    ),
//                  ),
//                ),
                  MainButton(
                    text: 'Add shipping address',
                    onPressed: () {
                      allData();
//                      setState(() {
//                        showSpinner = true;
//                      });
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => AddShippingAddress()),
                          (Route<dynamic> route) => false);
//                      setState(() {
//                        showSpinner = false;
//                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
