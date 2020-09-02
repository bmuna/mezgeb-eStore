import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mezgebestore/pages/shipping.dart';
import 'package:mezgebestore/main_button.dart';

class PaymentPage extends StatefulWidget {
  List order;
  PaymentPage({this.order});
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<PaymentPage> {
//  int _index = 0;
  bool one = false;
  Color color;
  String selected = "first";

  @override
  void initState() {
    super.initState();

    color = Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Choose Payment Option'),
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.arrowLeft),
          iconSize: 18,
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
//                  Text('Select payment option'),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Card(
                                color: selected == 'first'
                                    ? Colors.red
                                    : Colors.white,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child:
                                    Image.asset('images/cash.png', height: 180),
                              ),
                              Container(
                                width: double.maxFinite,
                                color: Colors.black.withOpacity(0.7),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('Cash on delivery',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              selected = 'first';
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: Container(
                          child: GestureDetector(
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                Card(
                                  color: selected == 'second'
                                      ? Colors.red
                                      : Colors.white,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Image.asset(
                                    'images/mobile.png',
                                    height: 180,
                                  ),
                                ),
                                Container(
                                  width: double.maxFinite,
                                  color: Colors.black.withOpacity(0.7),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Mobile banking',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                selected = 'second';
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  selected == 'first'
                      ? Column(
                          children: <Widget>[
                            Text(
                              'Cash on Delivery',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Please prepare the necessary amount of'
                                ' cash for your order in advance so '
                                'that your delivery is quick and seamless.'
                                ' Drivers may not always have exact change.'),
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            Text(
                              'Mobile Banking',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('To pay via mobile payment, '
                                'please click on "Check Out"'
                                ' below and send the grand total '
                                'for your order to one of the following '
                                'supported banks below as soon as possible.'),
                            SizedBox(
                              height: 20,
                            ),
//                            a(),
//                            SizedBox(
//                              height: 30,
//                            ),
                            Card(
                              color: Color(
                                0xff2A2C36,
                              ),
                              child: Column(
                                children: <Widget>[
                                  ExpansionTile(
                                    leading: Image.asset(
                                      'images/dashen.png',
                                      height: 50,
                                    ),
                                    title: Text('Dashen Bank'),
                                    children: <Widget>[
                                      ListTile(
                                        title: Text('Account name'),
                                        trailing: Text('Tefer PLC',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                      ListTile(
                                        title: Text('Account Number'),
                                        trailing: Text(
                                          '2331314',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                  ExpansionTile(
                                    leading: Image.asset(
                                      'images/cbe.jpg',
                                      height: 50,
                                    ),
                                    title: Text('CBE Bank'),
                                    children: <Widget>[
                                      ListTile(
                                        title: Text('Account name'),
                                        trailing: Text('Tefer PLC',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                      ListTile(
                                        title: Text('Account Number'),
                                        trailing: Text(
                                          '2331314',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                  ExpansionTile(
                                    leading: Image.asset(
                                      'images/cbir.png',
                                      height: 50,
                                    ),
                                    title: Text('CBE birr'),
                                    children: <Widget>[
                                      ListTile(
                                        title: Text('Account name'),
                                        trailing: Text('Tefer PLC',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                      ListTile(
                                        title: Text('Account Number'),
                                        trailing: Text(
                                          '2331314',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                  ExpansionTile(
                                    leading: Image.asset(
                                      'images/amole.png',
                                      height: 50,
                                    ),
                                    title: Text('Amole'),
                                    children: <Widget>[
                                      ListTile(
                                        title: Text('Account name'),
                                        trailing: Text('Tefer PLC',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                      ListTile(
                                        title: Text('Account Number'),
                                        trailing: Text(
                                          '2331314',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                ],
              ),
              selected == 'first'
                  ? Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: MainButton(
                        text: 'Place your order',
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => Shipping(order: widget.order),
                              ),
                              (Route<dynamic> route) => false);
                        },
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: MainButton(
                        text: 'Place your order',
                        onPressed: () {},
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
