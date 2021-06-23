import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Cata extends StatefulWidget {
  static const String id = 'cata_screen';

  const Cata({Key key}) : super(key: key);
  @override
  _PortfolioCategoriesAndDisplayState createState() =>
      new _PortfolioCategoriesAndDisplayState();
}

String _showCat = 'bag'; //default state is All

class CategoryChoice {
  const CategoryChoice({this.category, this.categoryName});

  final String category;
  final String categoryName; //'category.[Name]' in Firebase

  @override
  String toString() {
    return 'category: $category categoryName: $categoryName';
  }
}

//const List<CategoryChoice> categories = const <CategoryChoice>[
//  const CategoryChoice(categoryName: 'All'),
//  const CategoryChoice(categoryName: 'bag'),
////  const CategoryChoice(categoryName: 'Curatorial'),
////  const CategoryChoice(categoryName: 'Sustainability'),
//];

class _PortfolioCategoriesAndDisplayState extends State<Cata> {
  var firestore;

  void _select(String newCategory) {
    setState(() {
      _showCat = newCategory;
    });
  }

  Stream getItems() {
    firestore = Firestore.instance;
    Stream qn = firestore.collection('shop').snapshots();
    return qn;
  }

  Widget build(BuildContext context) {
    final NumberFormat toCurrency = NumberFormat("#,##0", "en_US");

    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                child: Row(children: [
              Expanded(
                child: Column(children: [
                  StreamBuilder(
                      stream: getItems(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(children: <Widget>[
                            StreamBuilder(
                              stream: Firestore.instance
                                  .collection("shop")
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  return Container(
                                    height: 50,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            snapshot.data.documents.length,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: <Widget>[
                                              FlatButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _select(snapshot.data
                                                            .documents[index]
                                                        ['type']);
                                                  });
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: 100,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 5.0,
                                                      bottom: 5,
                                                    ),
                                                    child: Text(
                                                      snapshot.data
                                                              .documents[index]
                                                          ['type'],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              )
                                            ],
                                          );
                                        }),
                                  );
                                }
                              },
                            ),
                            StreamBuilder(
                              stream: Firestore.instance
                                  .collection('shop')
                                  .where('type', isEqualTo: _showCat)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return Text("Loading...");
                                return GridView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.7,
                                  ),
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (BuildContext context, index) {
//
                                    return Column(
                                      children: <Widget>[
                                        Container(
                                          child: Expanded(
                                            child: Card(
                                              clipBehavior: Clip.antiAlias,
                                              child: CachedNetworkImage(
                                                height: 128,
                                                placeholder: (context, url) =>
                                                    Container(
                                                  height: 128,
                                                  alignment: Alignment.center,
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  height: 128,
                                                  child: Icon(Icons.error),
                                                ),
                                                imageUrl: snapshot
                                                        .data.documents[index]
                                                    ['image'][0],
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  snapshot.data.documents[index]
                                                      ['type'],
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  snapshot.data.documents[index]
                                                      ['brand'],
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      toCurrency.format(
                                                        snapshot.data.documents[
                                                            index]['newPrice'],
                                                      ),
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      'ETB',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                );
                              },
                            )
                          ]),
                        );
                      }),
                ]),
              )
            ]))));
  }
}
