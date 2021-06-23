import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Shop2 extends StatefulWidget {
  static const String id = 'shop2_screen';

  @override
  _Shop2State createState() => _Shop2State();
}

class _Shop2State extends State<Shop2> {
  String clickedCategory = '';
  void select(String newCategory) {
    setState(() {
      clickedCategory = newCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController;

    return StreamBuilder(
      stream: Firestore.instance.collection("category").snapshots(),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return DefaultTabController(
              length: snapshot.data.documents.length,
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text("Shop"),
                ),
                body: Column(
                  children: <Widget>[
                    TabBar(
                      controller: tabController,
                      isScrollable: true,
                      tabs: List.generate(
                        snapshot.data.documents.length,
                        (index) {
                          return Tab(
                            child: GestureDetector(
                              onTap: () {
                                select(snapshot.data.documents[index]['name']);
                              },
                              child: Text(
                                snapshot.data.documents[index]['name'],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
//                    Expanded(
//                      child: TabBarView(
//                        // Tab Bar View
//                        physics: BouncingScrollPhysics(),
//                        controller: tabController,
//                        children: <Widget>[Men(), Women(), Kids()],
//                      ),
//                    ),
                  ],
                ),
              ));
        }
      },
    );
  }
}

//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//
//class Shop2 extends StatefulWidget {
//  static const String id = 'shop2_screen';
//  @override
//  _Shop2State createState() => _Shop2State();
//}
//
//class _Shop2State extends State<Shop2> {
//  String data;
//  void a() async {
////    final QuerySnapshot result =
////        await Firestore.instance.collection('shop2').getDocuments();
////    final List<DocumentSnapshot> documents = result.documents;
////    documents.forEach((data) => print('Datatatatat: $data'));
////    final id = data.documentID;
////    print(id);
////    final userRef = Firestore.instance.collection('shop3');
////    userRef.getDocuments().then((snapshot) {
////      snapshot.documents.forEach((doc) {
////        print(doc.data);
////        print(doc.documentID);
////      });
////    })
//
////    final productsRef = Firestore.instance.collection("shop3");
////    productsRef
////        .document("ubge4KSXfflFHJx9l6RI")
////        .collection("shop3")
////        .getDocuments()
////        .then((QuerySnapshot snapshot) {
////      snapshot.documents.forEach((DocumentSnapshot doc) {
////        print("print: ${doc.data}");
////      });
////    });
//  }
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    a();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        body: Column(children: <Widget>[
////      StreamBuilder(
////          stream: Firestore.instance
////              .collection("shop2")
////              .document("ubge4KSXfflFHJx9l6RI")
////              .snapshots(),
////          builder: (BuildContext context, AsyncSnapshot snapshot) {
////            if (!snapshot.hasData) {
////              CircularProgressIndicator();
////            }
////            return ListView.builder(
////                scrollDirection: Axis.vertical,
////                shrinkWrap: true,
////                itemCount: snapshot.data.documents,
////                itemBuilder: (context, index) {
////                  return Column(
////                    children: <Widget>[
////                      Text(
////                        '${snapshot.data.documents[index]}',
////                      )
////                    ],
////                  );
////                });
////          })
//    ])
////      StreamBuilder(
////        stream: Firestore.instance
////            .collection("shop2")
////            .document("ubge4KSXfflFHJx9l6RI")
////            .snapshots(),
////        builder: (context, snapshot) {
////          if (snapshot.data != null) {
////            QuerySnapshot snap = snapshot.data;
////            List<DocumentSnapshot> documents = snap.documents;
////            return ListView.builder(
//////                  scrollDirection: Axis.horizontal,
////              shrinkWrap: true,
////              itemCount: documents.length,
////              itemBuilder: (BuildContext context, int index) {
////                DocumentSnapshot doc = documents[index];
////                return Container(
////                  height: 20,
////                  width: 30,
////                  child: ClipRRect(
////                      borderRadius: BorderRadius.circular(5),
////                      child: Text("${doc.documentID}")),
////                );
////              },
////            );
////          } else {
////            return CircularProgressIndicator();
////          }
////        },
////      )
//        );
////      FutureBuilder(
////          future: Firestore.instance.collection('shop').getDocuments(),
////          builder: (BuildContext context, snapshot) {
////            if (!snapshot.hasData) {
////              return Center(child: CircularProgressIndicator());
////            }
////            final documents = snapshot.data;
//
////            return Container(
////      Container(
////        height: 40,
////        child: ListView.builder(
////            scrollDirection: Axis.horizontal,
//////                  itemCount: snapshot.data.documents.length,
////            itemBuilder: (context, index) {
////              return Row(children: <Widget>[
////                FlatButton(
////                  onPressed: () {
//////                                    select(_searchList[index].type);
////////                                    getData();
////                  },
////                  child: Container(
////                    height: 30,
////                    width: 120,
////                    child: Padding(
////                      padding: const EdgeInsets.only(
////                        top: 5.0,
////                        bottom: 5,
////                      ),
////
//////                        child: Text(
//////                          data,
//////                          style: TextStyle(
//////                            color: Colors.black,
//////                          ),
//////                        ),
////                    ),
////                    decoration: BoxDecoration(
////                      borderRadius: BorderRadius.circular(20),
////                      color: Colors.white,
////                    ),
////                  ),
////                ),
////                CachedNetworkImage(
////                  height: 128,
////                  placeholder: (context, url) => Container(
////                    height: 128,
////                    alignment: Alignment.center,
////                    child: CircularProgressIndicator(),
////                  ),
////                  errorWidget: (context, url, error) => Container(
////                    height: 128,
////                    child: Icon(Icons.error),
////                  ),
////                  imageUrl: data,
////                  fit: BoxFit.fill,
////                ),
////              ]);
////            }),
////      )
//  }
//}
//
////import 'package:cached_network_image/cached_network_image.dart';
////import 'package:flutter/cupertino.dart';
////import 'package:flutter/material.dart';
////import 'package:cloud_firestore/cloud_firestore.dart';
////import 'package:intl/intl.dart';
////import 'package:mezgebestore/models/check_out.dart';
////import 'package:mezgebestore/pages/cart2.dart';
////import 'package:mezgebestore/pages/detail.dart';
////
////List<CheckOutData> _searchList = List();
////
////class Shop2 extends StatefulWidget {
////  static const String id = 'shop2_screen';
////  const Shop2({Key key}) : super(key: key);
////  @override
////  _Shop2State createState() => _Shop2State();
////}
////
////class _Shop2State extends State<Shop2> {
////  Widget appBarTitle = Text(
////    "Shop",
////    style: TextStyle(color: Colors.white),
////  );
////  Icon actionIcon = Icon(
////    Icons.search,
////    color: Colors.white,
////  );
////  final key = GlobalKey<ScaffoldState>();
////  final TextEditingController _searchQuery = TextEditingController();
////  List<CheckOutData> _list;
////  final databaseReference = Firestore.instance;
////  bool _IsSearching;
////  String _searchText = "";
////
////  _Shop2State() {
////    _searchQuery.addListener(() {
////      if (_searchQuery.text.isEmpty) {
////        setState(() {
////          _IsSearching = false;
////          _searchText = "";
////          _buildSearchList();
////        });
////      } else {
////        setState(() {
////          _IsSearching = true;
////          _searchText = _searchQuery.text;
////          _buildSearchList();
////        });
////      }
////    });
////  }
////  void init() {
////    _list = List();
////  }
////
////  void getData() async {
////    await for (var items in databaseReference.collection("shop").snapshots()) {
////      for (var item in items.documents) {
////        CheckOutData hold = CheckOutData(
////          id: item.data['id'],
////          imgUrl: item.data['image'],
////          newPrice: item.data['newPrice'],
////          brand: item.data['brand'],
////          type: item.data['type'],
////          description: item.data['description'],
////          size: item.data['size'],
////          color: item.data['color'],
////          oldPrice: item.data['oldPrice'],
////        );
////        setState(() {
////          _list.add(hold);
////        });
////      }
////      setState(() {
////        _searchList = _list;
////      });
////    }
////  }
////
////  navigateToDetail(CheckOutData post) {
////    Navigator.push(
////      context,
////      MaterialPageRoute(
////        builder: (context) => Detail(
////          product: post,
////        ),
////      ),
////    );
////  }
////
////  @override
////  void initState() {
////    // TODO: implement initState
////    super.initState();
////    getData();
////    init();
////    _IsSearching = false;
////  }
////
////  List<CheckOutData> _buildSearchList() {
////    if (_searchText.isEmpty) {
////      return _searchList = _list;
////    } else {
////      _searchList = _list
////          .where((element) =>
////              element.brand.toLowerCase().contains(_searchText.toLowerCase()) ||
////              (element.newPrice).toString().contains(_searchText) ||
////              element.type.toLowerCase().contains(_searchText.toLowerCase()))
////          .toList();
////      print('${_searchList.length}');
////      return _searchList;
////    }
////  }
////
////  Widget buildBar(BuildContext context) {
////    return AppBar(
////      backgroundColor: Colors.transparent,
////      bottomOpacity: 0.0,
////      elevation: 0.0,
////      centerTitle: true,
////      title: appBarTitle,
////      iconTheme: IconThemeData(color: Colors.white),
////      actions: <Widget>[
////        IconButton(
////          icon: actionIcon,
////          onPressed: () {
////            setState(
////              () {
////                if (this.actionIcon.icon == Icons.search) {
////                  this.actionIcon = Icon(
////                    Icons.close,
////                    color: Color(0xffEF3651),
////                  );
////                  this.appBarTitle = TextField(
////                    controller: _searchQuery,
////                    style: TextStyle(
////                      color: Colors.white,
////                    ),
////                    decoration: InputDecoration(
////                      hintText: "Search here..",
////                      hintStyle: TextStyle(color: Colors.white),
////                      enabledBorder: UnderlineInputBorder(
////                        borderSide: BorderSide(
////                          color: Color(0xffEF3651),
////                        ),
////                      ),
////                      focusedBorder: UnderlineInputBorder(
////                        borderSide: BorderSide(
////                          color: Color(0xffEF3651),
////                        ),
////                      ),
////                    ),
////                  );
////                  _handleSearchStart();
////                } else {
////                  _handleSearchEnd();
////                }
////              },
////            );
////          },
////        ),
////      ],
////    );
////  }
////
////  void _handleSearchStart() {
////    setState(() {
////      _IsSearching = true;
////    });
////  }
////
////  void _handleSearchEnd() {
////    setState(() {
////      this.actionIcon = Icon(
////        Icons.search,
////        color: Colors.white,
////      );
////      this.appBarTitle = Text(
////        "Shop",
////        style: TextStyle(color: Colors.white),
////      );
////      _IsSearching = false;
////      _searchQuery.clear();
////    });
////  }
////
////  String _showCat = 'bag';
////  void select(String newCategory) {
////    setState(() {
////      _showCat = newCategory;
////    });
////  }
////
////  @override
////  Widget build(BuildContext context) {
////    final NumberFormat toCurrency = NumberFormat("#,##0", "en_US");
////
////    //SizeConfig().init(context);
////    return Scaffold(
////        key: key,
////        appBar: buildBar(context),
////        body: Column(
////          children: <Widget>[
////            StreamBuilder(
////                stream: Firestore.instance.collection("shop").snapshots(),
////                builder: (BuildContext context, AsyncSnapshot snapshot) {
////                  if (!snapshot.hasData) {
////                    return Center(child: CircularProgressIndicator());
////                  } else {
////                    return Container(
////                      height: 40,
////                      child: ListView.builder(
////                          scrollDirection: Axis.horizontal,
////                          itemCount: _searchList.length,
////                          itemBuilder: (context, index) {
////                            return Row(
////                              children: <Widget>[
////                                FlatButton(
////                                  onPressed: () {
////                                    select(_searchList[index].type);
//////                                    getData();
////                                  },
////                                  child: Container(
////                                    height: 30,
////                                    width: 120,
////                                    child: Padding(
////                                      padding: const EdgeInsets.only(
////                                        top: 5.0,
////                                        bottom: 5,
////                                      ),
////                                      child: Text(
////                                        _searchList[index].type,
////                                        textAlign: TextAlign.center,
////                                        style: TextStyle(
////                                          color: Colors.black,
////                                        ),
////                                      ),
////                                    ),
////                                    decoration: BoxDecoration(
////                                      borderRadius: BorderRadius.circular(20),
////                                      color: Colors.white,
////                                    ),
////                                  ),
////                                ),
////                              ],
////                            );
////                          }),
////                    );
////                  }
////                }),
////            StreamBuilder(
////                stream: Firestore.instance
////                    .collection('shop')
////                    .where('type', isEqualTo: _showCat)
////                    .snapshots(),
////                builder: (context, snapshot) {
////                  if (!snapshot.hasData) return Text("Loading...");
////                  return Expanded(
////                    child: GridView.builder(
////                      scrollDirection: Axis.vertical,
////                      itemCount: _searchList.length,
////                      itemBuilder: (context, index) {
////                        return Column(
////                          children: <Widget>[
////                            Container(
////                              child: Expanded(
////                                child: GestureDetector(
////                                  onTap: () {
////                                    navigateToDetail(_searchList[index]);
////                                  },
////                                  child: Card(
////                                    clipBehavior: Clip.antiAlias,
////                                    child: CachedNetworkImage(
////                                      height: 128,
////                                      placeholder: (context, url) => Container(
////                                        height: 128,
////                                        alignment: Alignment.center,
////                                        child: CircularProgressIndicator(),
////                                      ),
////                                      errorWidget: (context, url, error) =>
////                                          Container(
////                                        height: 128,
////                                        child: Icon(Icons.error),
////                                      ),
////                                      imageUrl: _searchList[index].imgUrl[0],
////                                      fit: BoxFit.fill,
////                                    ),
////                                  ),
////                                ),
////                              ),
////                            ),
////                            Container(
////                              child: Padding(
////                                padding: const EdgeInsets.symmetric(
////                                    horizontal: 10.0),
////                                child: Column(
////                                  crossAxisAlignment: CrossAxisAlignment.start,
////                                  children: <Widget>[
////                                    Text(
////                                      _searchList[index].type,
////                                      style: TextStyle(
////                                        fontSize: 15,
////                                        fontWeight: FontWeight.w600,
////                                      ),
////                                    ),
////                                    Text(
////                                      _searchList[index].brand,
////                                      style: TextStyle(
////                                        color: Colors.grey,
////                                      ),
////                                    ),
////                                    Row(
////                                      children: <Widget>[
////                                        Text(
////                                          toCurrency.format(
////                                            _searchList[index].newPrice,
////                                          ),
////                                          style: TextStyle(
////                                              fontSize: 20,
////                                              fontWeight: FontWeight.bold),
////                                        ),
////                                        SizedBox(
////                                          width: 5,
////                                        ),
////                                        Text(
////                                          'ETB',
////                                          style: TextStyle(
////                                              fontSize: 20,
////                                              fontWeight: FontWeight.bold),
////                                        ),
////                                      ],
////                                    ),
////                                  ],
////                                ),
////                              ),
////                            )
//////
////                          ],
////                        );
////                      },
////                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
////                        crossAxisCount: 2,
////                        childAspectRatio: 0.7,
////                      ),
////                    ),
////                  );
////                })
////          ],
////        ));
////  }
////}
