import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mezgebestore/models/check_out.dart';
import 'package:mezgebestore/pages/detail.dart';

class Shop extends StatefulWidget {
  static const String id = 'shop_screen';
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
  List<CheckOutData> _searchList = List();
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  List<CheckOutData> _list;
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
    await for (var items in databaseReference.collection("shop").snapshots()) {
      for (var item in items.documents) {
        CheckOutData hold = CheckOutData(
            id: item.data['id'],
            imgUrl: item.data['image'],
            newPrice: item.data['newPrice'],
            brand: item.data['brand'],
            description: item.data['description'],
            size: item.data['size'],
            color: item.data['color'],
            oldPrice: item.data['oldPrice'],
            category: item.data["category"]);
        _list.add(hold);
      }
      setState(() {});
      _searchList = _list;
    }
  }

  navigateToDetail(CheckOutData post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Detail(
          product: post,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    init();
    _IsSearching = false;
  }

  List<CheckOutData> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _searchList = _list;
    } else {
      _searchList = _list
          .where((element) =>
              element.brand.toLowerCase().contains(_searchText.toLowerCase()) ||
              (element.newPrice).toString().contains(_searchText) ||
              element.category
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()))
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
    final NumberFormat toCurrency = NumberFormat("#,##0", "en_US");

    //SizeConfig().init(context);
    return Scaffold(
        key: key,
        appBar: buildBar(context),
        body: GridView.builder(
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
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(
                          height: 128,
                          placeholder: (context, url) => Container(
                            height: 128,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 128,
                            child: Icon(Icons.error),
                          ),
                          imageUrl: _searchList[index].imgUrl[0],
                          fit: BoxFit.fill,
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
                          _searchList[index].category,
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
                              toCurrency.format(_searchList[index].newPrice),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'ETB',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
        ));
  }
}
