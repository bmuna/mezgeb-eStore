import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mezgebestore/main_button.dart';
import 'package:mezgebestore/models/check_out.dart';
import 'package:mezgebestore/pages/payment.dart';

class Cart extends StatefulWidget {
  static const String id = 'cart_screen';
  const Cart({Key key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<CheckOutData> dataList = [];
  FirebaseUser user;

  void getCheckoutData() async {
    user = await FirebaseAuth.instance.currentUser();
    await for (var messages in Firestore.instance
        .collection("users")
        .document(user.uid)
        .collection('cart')
        .snapshots()) {
      for (var message in messages.documents) {
        CheckOutData hold = CheckOutData(
          imgUrl: message.data['image'],
          newPrice: message.data['newPrice'],
          brand: message.data['brand'],
          type: message.data['type'],
          quantity: message.data['quantity'],
          color: message.data['color'],
          size: message.data['size'],
          id: message.data['id'],
        );
        dataList.add(hold);
      }
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCheckoutData();
    returnTotalAmount(dataList);
  }

  String returnTotalAmount(List<CheckOutData> _item) {
    double totalAmount = 0.0;

    for (int i = 0; i < _item.length; i++) {
      totalAmount =
          totalAmount + int.parse(_item[i].newPrice) * _item[i].quantity;
    }
    return (totalAmount.toString());
  }

  handleClick(String value) async {
    print(value);
    Firestore.instance
        .collection("users")
        .document(user.uid)
        .collection('cart')
        .document(value)
        .delete()
        .then((_) {
      print("success!");
    });
    switch (value) {
      case 'Delete':
        break;
    }
  }

//
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          centerTitle: true,
          leading: Icon(
            FontAwesomeIcons.arrowLeft,
            size: 18.0,
          ),
          title: Text("Cart"),
        ),
        body: SingleChildScrollView(
          child: dataList.length == 0
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: dataList.length,
                        itemBuilder: (_, i) {
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Container(
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(
                                      0xff2A2C36,
                                    ),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image(
                                            image: NetworkImage(
                                              dataList[i].imgUrl[0],
                                            ),
                                            height: double.infinity,
                                            width: 100.0,
                                            fit: BoxFit.fill),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  dataList[i].brand,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 2.0),
                                                  child:
                                                      PopupMenuButton<String>(
                                                    onSelected: (value) {
                                                      setState(() {
                                                        handleClick(
                                                            dataList[i].id);
                                                      });
                                                    },
                                                    itemBuilder:
                                                        (BuildContext context) {
                                                      return {
                                                        'Delete',
                                                      }.map((String choice) {
                                                        return PopupMenuItem(
                                                          value: choice,
                                                          child: Text(choice),
                                                        );
                                                      }).toList();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  'color:',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 13),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(
                                                  dataList[i].color,
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                ),
                                                SizedBox(
                                                  width: 13.0,
                                                ),
                                                Text(
                                                  'size:',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 13),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(
                                                  dataList[i].size,
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    RoundIconButton(
                                                      icon: FontAwesomeIcons
                                                          .minus,
                                                      onPressed: () async {
                                                        setState(() {
                                                          if (dataList[i]
                                                                  .quantity >
                                                              1) {
                                                            dataList[i]
                                                                .quantity--;
                                                          }
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      '${dataList[i].quantity}',
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    RoundIconButton(
                                                      icon:
                                                          FontAwesomeIcons.plus,
                                                      onPressed: () async {
                                                        setState(() {
                                                          dataList[i]
                                                              .quantity++;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                          dataList[i].newPrice),
                                                      SizedBox(
                                                        width: 3.0,
                                                      ),
                                                      Text('ETB'),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
//                                        Text('total:${dataList[].price}')
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          );
                        },
                      ),
                      totalAmount(dataList),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: MainButton(
                          text: 'CheckOut',
                          onPressed: () {
                            print(dataList);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PaymentPage(order: dataList),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 100.0,
                      )
                    ],
                  ),
                ),
        ));
  }

  Container totalAmount(List<CheckOutData> _item) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Total Amount:",
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            Text(
              "${returnTotalAmount(_item)} ETB",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  RoundIconButton({@required this.icon, @required this.onPressed});
  final IconData icon;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(
        icon,
        size: 12,
        color: Colors.grey,
      ),
      onPressed: onPressed,
      elevation: 0.0,
      constraints: BoxConstraints.tightFor(
        width: 30,
        height: 30,
      ),
      shape: CircleBorder(),
      fillColor: Color(0xff4c4f5e),
    );
  }
}

//MainCard(dataList[i].imgUrl, dataList[i].brand,
//dataList[i].price, dataList[i].type);
