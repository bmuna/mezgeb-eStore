import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mezgebestore/models/data.dart';
import 'package:mezgebestore/pages/detail.dart';
import 'package:mezgebestore/pages/navbar_controller.dart';
import 'package:transparent_image/transparent_image.dart';

class Home extends StatefulWidget {
  static const String id = 'Home_screen';

  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final databaseReference = Firestore.instance;
  void getNewData() async {
    await for (var messages in databaseReference
        .collection("shop")
        .where("tag", isEqualTo: 'new')
        .snapshots()) {
      for (var message in messages.documents) {
        Data hold = Data(
          imgUrl: message.data['image'],
          price: message.data['newPrice'],
          brand: message.data['brand'],
          type: message.data['type'],
          description: message.data['description'],
          size: message.data['size'],
          color: message.data['color'],
          oldPrice: message.data['oldPrice'],
        );
        dataNewList.add(hold);
      }
      setState(() {});
    }
  }

  void getSaleData() async {
    await for (var messages in databaseReference
        .collection("shop")
        .where("tag", isEqualTo: 'sale')
        .snapshots()) {
      for (var message in messages.documents) {
        Data hold = Data(
          imgUrl: message.data['image'],
          price: message.data['newPrice'],
          brand: message.data['brand'],
          type: message.data['type'],
          description: message.data['description'],
          size: message.data['size'],
          color: message.data['color'],
          oldPrice: message.data['oldPrice'],
        );
        dataSaleList.add(hold);
      }
      setState(() {});
    }
  }

  List<Data> dataNewList = [];
  List<Data> dataSaleList = [];

  navigateToDetail(Data post) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Detail(post: post)));
  }

  bool isExist;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewData();
    getSaleData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Image.asset('images/main1.png',
                width: double.infinity, height: 480, fit: BoxFit.cover),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 300.0, right: 20.0, left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Fashion',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 40),
                      ),
                      Text(
                        'Sale',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 40),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ButtonTheme(
                        minWidth: 150.0,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () {},
                          color: Color(0xffEF3651),
                          textColor: Colors.white,
                          child: Text(
                            "Check",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'New',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 30),
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
                              "View all",
//                        style: TextStyle(textBaseline: TextBaseline.alphabetic),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 350,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: dataNewList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 300,
                        child: GestureDetector(
                          onTap: () {
                            navigateToDetail(dataNewList[index]);
                          },
                          child: Container(
                              margin: EdgeInsets.all(10),
                              width: 210,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(0.0, 2.0),
                                            blurRadius: 6.0,
                                          )
                                        ]),
                                    child: Column(
                                      children: <Widget>[
                                        Stack(
                                          children: <Widget>[
                                            Container(
                                              height: 200.0,
                                              width: 200,
                                              child: FadeInImage.memoryNetwork(
                                                placeholder: kTransparentImage,
                                                image: dataNewList[index]
                                                    .imgUrl[0],
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ],
                                        ),
//                                        Image(
//                                          height: 200,
//                                          width: 200,
//                                          image: NetworkImage(
//                                              dataNewList[index].imgUrl[0]),
//                                          fit: BoxFit.fill,
//                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 200,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            dataNewList[index].type,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            dataNewList[index].brand,
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                dataNewList[index].price,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 3.0,
                                              ),
                                              Text(
                                                'ETB',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20.0, left: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Sale',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 30),
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
                          "View all",
//                        style: TextStyle(textBaseline: TextBaseline.alphabetic),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 400,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: dataSaleList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 300,
                        child: GestureDetector(
                          onTap: () {
                            navigateToDetail(dataSaleList[index]);
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            width: 210,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 6.0,
                                        )
                                      ]),
                                  child: Column(
                                    children: <Widget>[
                                      Image(
                                        height: 200,
                                        width: 200,
                                        image: NetworkImage(
                                            dataSaleList[index].imgUrl[0]),
                                        fit: BoxFit.fill,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          dataSaleList[index].type,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          dataSaleList[index].brand,
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  dataSaleList[index].oldPrice,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    color: Colors.grey[300],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 3.0,
                                                ),
                                                Text(
                                                  'ETB',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[300],
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  dataSaleList[index].price,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 3.0,
                                                ),
                                                Text(
                                                  'ETB',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
