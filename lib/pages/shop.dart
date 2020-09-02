import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mezgebestore/models/data.dart';
import 'package:mezgebestore/pages/detail.dart';

List<Data> _searchList = List();

class Shop extends StatefulWidget {
  static const String id = 'shop2_screen';
  const Shop({Key key}) : super(key: key);
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  Widget appBarTitle = Text(
    "Shop",
    style: TextStyle(color: Colors.white),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  List<Data> _list;
  final databaseReference = Firestore.instance;
  bool _IsSearching;
  String _searchText = "";

  _ShopState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
          _buildSearchList();
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
          _buildSearchList();
        });
      }
    });
  }
  void init() {
    _list = List();
  }

  void getData() async {
    await for (var messages
        in databaseReference.collection("shop").snapshots()) {
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
        _list.add(hold);
      }
      setState(() {});
      _searchList = _list;
    }
  }

  navigateToDetail(Data post) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Detail(post: post)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    init();
    _IsSearching = false;
  }

  List<Data> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _searchList = _list;
    } else {
      _searchList = _list
          .where((element) =>
              element.brand.toLowerCase().contains(_searchText.toLowerCase()) ||
              element.price.toLowerCase().contains(_searchText.toLowerCase()) ||
              element.type.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
      print('${_searchList.length}');
      return _searchList;
    }
  }

  Widget buildBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      bottomOpacity: 0.0,
      elevation: 0.0,
      centerTitle: true,
      title: appBarTitle,
      iconTheme: IconThemeData(color: Colors.white),
      actions: <Widget>[
        IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(
              () {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = Icon(
                    Icons.close,
                    color: Color(0xffEF3651),
                  );
                  this.appBarTitle = TextField(
                    controller: _searchQuery,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: "Search here..",
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffEF3651),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffEF3651),
                        ),
                      ),
                    ),
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              },
            );
          },
        ),
      ],
    );
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = Text(
        "Shop",
        style: TextStyle(color: Colors.white),
      );
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    //SizeConfig().init(context);
    return Scaffold(
      key: key,
      appBar: buildBar(context),
      body: StreamBuilder(
        stream: Firestore.instance.collection("shop").snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return GridView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _searchList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    Container(
                      child: Expanded(
                        child: GestureDetector(
                          onTap: () {
                            navigateToDetail(_searchList[index]);
                          },
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image(
                              fit: BoxFit.fill,
                              image: NetworkImage(_searchList[index].imgUrl[0]),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _searchList[index].type,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _searchList[index].brand,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  _searchList[index].price,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'ETB',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
            );
          }
        },
      ),
    );
  }
}
