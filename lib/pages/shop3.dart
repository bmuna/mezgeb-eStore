import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mezgebestore/language/AppLanguage.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/models/check_out.dart';
import 'package:mezgebestore/pages/detail.dart';
import 'package:mezgebestore/stores/business_name.dart';
import 'package:mezgebestore/stores/size_config.dart';
import 'package:mezgebestore/stores/theme_notifier.dart';
import 'package:mezgebestore/theme_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Shop3 extends StatefulWidget {
  static const String id = 'shop3_screen';
  const Shop3({Key key}) : super(key: key);

  @override
  _Shop3State createState() => _Shop3State();
}

class _Shop3State extends State<Shop3> {
//  String businessName = "mezgebTest";
  BusinessName businessName = BusinessName();

//  Widget appBarTitle = Text(
//    "Shop",
//    style: Theme.of(context).textTheme.subtitle1,
//  );
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

  _Shop3State() {
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

//  void getData() async {
//    await for (var items in databaseReference.collection("shop").snapshots()) {
//      for (var item in items.documents) {
//        CheckOutData hold = CheckOutData(
//          id: item.data['id'],
//          imgUrl: item.data['image'],
//          newPrice: item.data['newPrice'],
//          brand: item.data['brand'],
//          type: item.data['type'],
//          description: item.data['description'],
//          size: item.data['size'],
//          color: item.data['color'],
//          oldPrice: item.data['oldPrice'],
//        );
//        _list.add(hold);
//      }
//      setState(() {});
//      _searchList = _list;
//    }
//  }

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

  var _darkTheme = true;

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }

  Widget buildBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      bottomOpacity: 1,
      elevation: 3.0,
      centerTitle: true,
      automaticallyImplyLeading: false,
//            title: AppBarTitle(),
      title: Text(
        AppLocalizations.of(context).translate('shop'),
        style: Theme.of(context).textTheme.bodyText1.merge(
              TextStyle(
                fontSize: 2.8 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),

      iconTheme: IconThemeData(color: Colors.white),
      actions: <Widget>[
//              IconButton(
//                icon: actionIcon,
//                onPressed: () {
//                  setState(
//                    () {
//                      if (this.actionIcon.icon == Icons.search) {
//                        this.actionIcon = Icon(
//                          Icons.close,
//                          color: Color(0xffEF3651),
//                        );
//                        this.appBarTitle = TextField(
//                          controller: _searchQuery,
//                          style: TextStyle(
//                            color: Colors.white,
//                          ),
//                          decoration: InputDecoration(
//                            hintText: "Search here..",
//                            hintStyle: TextStyle(color: Colors.white),
//                            enabledBorder: UnderlineInputBorder(
//                              borderSide: BorderSide(
//                                color: Color(0xffEF3651),
//                              ),
//                            ),
//                            focusedBorder: UnderlineInputBorder(
//                              borderSide: BorderSide(
//                                color: Color(0xffEF3651),
//                              ),
//                            ),
//                          ),
//                        );
//                        _handleSearchStart();
//                      } else {
//                        _handleSearchEnd();
//                      }
//                    },
//                  );
//                },
//              ),
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
      AppBarTitle();
//      this.appBarTitle = Text(
//        "Shop",
//        style: TextStyle(color: Colors.white),
//      );
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    getData();
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

  @override
  Widget build(BuildContext context) {
    final NumberFormat toCurrency = NumberFormat("#,##0", "en_US");
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
        extendBody: true,
        key: key,
        appBar: buildBar(context),
        body: appLanguage.appLocale == Locale('en')
            ? StreamBuilder(
                stream: Firestore.instance
                    .collection("business")
                    .document(businessName.name)
                    .collection("category")
                    .document("language")
                    .collection("en")
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                        "No item found",
                        style: TextStyle(
                          fontSize: 3 * SizeConfig.textMultiplier,
                        ),
                      ),
                    );
                  } else {
                    return CustomTabView(
                      theme: _darkTheme,
                      itemCount: snapshot.data.documents.length,
                      tabBuilder: (context, index) {
                        return Tab(
                          text: snapshot.data.documents[index]['name'],
                        );
                      },

                      pageBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: StreamBuilder(
                            stream: Firestore.instance
                                .collection("business")
                                .document(businessName.name)
                                .collection('shop')
                                .document("language")
                                .collection("en")
                                .where('category',
                                    isEqualTo: snapshot.data.documents[index]
                                        ['name'])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              return GridView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  return CustomScrollView(slivers: [
                                    SliverFillRemaining(
                                      hasScrollBody: false,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            child: Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  final items =
                                                      snapshot.data.documents;
                                                  for (var item in items) {
                                                    setState(() {
                                                      CheckOutData hold =
                                                          CheckOutData(
                                                        id: item.data['id'],
                                                        imgUrl:
                                                            item.data['image'],
                                                        newPrice: item
                                                            .data['newPrice'],
                                                        brand:
                                                            item.data['brand'],
                                                        category: item
                                                            .data['category'],
                                                        description: item.data[
                                                            'description'],
                                                        size: item.data['size'],
                                                        color:
                                                            item.data['color'],
                                                        oldPrice: item
                                                            .data['oldPrice'],
                                                      );
                                                      _list.add(hold);
                                                    });
//                                            snapshot.data.documents.add(hold);
                                                  }

                                                  navigateToDetail(
                                                      _list[index]);
                                                  _list.clear();
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                    0.7 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black26,
                                                          offset:
                                                              Offset(0.0, 2.0),
                                                          blurRadius: 0.6 *
                                                              SizeConfig
                                                                  .heightMultiplier,
                                                        )
                                                      ],
                                                    ),
                                                    child: CachedNetworkImage(
                                                      height: 20 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        height: 20 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                        alignment:
                                                            Alignment.center,
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Center(
                                                        child: Container(
                                                          height: 20 *
                                                              SizeConfig
                                                                  .heightMultiplier,
                                                          child: Icon(
                                                            Icons.error,
                                                            size: 4.6 *
                                                                SizeConfig
                                                                    .heightMultiplier,
                                                          ),
                                                        ),
                                                      ),
                                                      imageUrl: snapshot.data
                                                              .documents[index]
                                                          ['image'][0],
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 1.5 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                      snapshot.data
                                                              .documents[index]
                                                          ['brand'],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1
                                                          .merge(
                                                            TextStyle(
                                                              fontSize: 2 *
                                                                  SizeConfig
                                                                      .textMultiplier,
                                                            ),
                                                          )),
//                                            SizedBox(
//                                              height: 0.5 *
//                                                  SizeConfig.heightMultiplier,
//                                            ),
                                                  Text(
                                                    snapshot.data
                                                            .documents[index]
                                                        ['category'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .merge(
                                                          TextStyle(
                                                            fontSize: 2.1 *
                                                                SizeConfig
                                                                    .textMultiplier,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                  ),
//                                            SizedBox(
//                                              height: 0.5 *
//                                                  SizeConfig.heightMultiplier,
//                                            ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "${toCurrency.format(snapshot.data.documents[index]['newPrice'])} ETB",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            .merge(
                                                              TextStyle(
                                                                fontSize: 2.3 *
                                                                    SizeConfig
                                                                        .textMultiplier,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
//
                                        ],
                                      ),
                                    )
                                  ]);
                                },
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      onPositionChange: (index) {
                        print('current position: $index');
                      },
//                  onScroll: (position) => print('$position'),
                    );
                  }
                })
            : StreamBuilder(
                stream: Firestore.instance
                    .collection("business")
                    .document(businessName.name)
                    .collection("category")
                    .document("language")
                    .collection("am")
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                        "No item found",
                        style: TextStyle(
                          fontSize: 3 * SizeConfig.textMultiplier,
                        ),
                      ),
                    );
                  } else {
                    return CustomTabView(
                      theme: _darkTheme,
                      itemCount: snapshot.data.documents.length,
                      tabBuilder: (context, index) {
                        return Tab(
                          text: snapshot.data.documents[index]['name'],
                        );
                      },

                      pageBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: StreamBuilder(
                            stream: Firestore.instance
                                .collection("business")
                                .document(businessName.name)
                                .collection('shop')
                                .document("language")
                                .collection("am")
                                .where('category',
                                    isEqualTo: snapshot.data.documents[index]
                                        ['name'])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              return GridView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  return CustomScrollView(slivers: [
                                    SliverFillRemaining(
                                      hasScrollBody: false,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            child: Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  final items =
                                                      snapshot.data.documents;
                                                  for (var item in items) {
                                                    setState(() {
                                                      CheckOutData hold =
                                                          CheckOutData(
                                                        id: item.data['id'],
                                                        imgUrl:
                                                            item.data['image'],
                                                        newPrice: item
                                                            .data['newPrice'],
                                                        brand:
                                                            item.data['brand'],
                                                        category: item
                                                            .data['category'],
                                                        description: item.data[
                                                            'description'],
                                                        size: item.data['size'],
                                                        color:
                                                            item.data['color'],
                                                        oldPrice: item
                                                            .data['oldPrice'],
                                                      );
                                                      _list.add(hold);
                                                    });
//                                            snapshot.data.documents.add(hold);
                                                  }

                                                  navigateToDetail(
                                                      _list[index]);
                                                  _list.clear();
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                    0.7 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black26,
                                                          offset:
                                                              Offset(0.0, 2.0),
                                                          blurRadius: 0.6 *
                                                              SizeConfig
                                                                  .heightMultiplier,
                                                        )
                                                      ],
                                                    ),
                                                    child: CachedNetworkImage(
                                                      height: 20 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        height: 20 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                        alignment:
                                                            Alignment.center,
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Center(
                                                        child: Container(
                                                          height: 20 *
                                                              SizeConfig
                                                                  .heightMultiplier,
                                                          child: Icon(
                                                            Icons.error,
                                                            size: 4.6 *
                                                                SizeConfig
                                                                    .heightMultiplier,
                                                          ),
                                                        ),
                                                      ),
                                                      imageUrl: snapshot.data
                                                              .documents[index]
                                                          ['image'][0],
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 1.5 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                      snapshot.data
                                                              .documents[index]
                                                          ['brand'],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1
                                                          .merge(
                                                            TextStyle(
                                                              fontSize: 2 *
                                                                  SizeConfig
                                                                      .textMultiplier,
                                                            ),
                                                          )),
//                                            SizedBox(
//                                              height: 0.5 *
//                                                  SizeConfig.heightMultiplier,
//                                            ),
                                                  Text(
                                                    snapshot.data
                                                            .documents[index]
                                                        ['category'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .merge(
                                                          TextStyle(
                                                            fontSize: 2.1 *
                                                                SizeConfig
                                                                    .textMultiplier,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                  ),
//                                            SizedBox(
//                                              height: 0.5 *
//                                                  SizeConfig.heightMultiplier,
//                                            ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "${toCurrency.format(snapshot.data.documents[index]['newPrice'])} ETB",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            .merge(
                                                              TextStyle(
                                                                fontSize: 2.3 *
                                                                    SizeConfig
                                                                        .textMultiplier,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
//
                                        ],
                                      ),
                                    )
                                  ]);
                                },
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      onPositionChange: (index) {
                        print('current position: $index');
                      },
//                  onScroll: (position) => print('$position'),
                    );
                  }
                }));
  }
}

/// Implementation

class CustomTabView extends StatefulWidget {
  final bool theme;
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;

  CustomTabView({
    this.theme,
    @required this.itemCount,
    @required this.tabBuilder,
    @required this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  TabController controller;
  int _currentCount;
  int _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition ?? 0;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.animation.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub ?? Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          width: double.infinity,
          alignment: Alignment.center,
//            child: Stack(
//                fit: StackFit.passthrough,
//                alignment: Alignment.bottomCenter,
//                children: <Widget>[
//                  Container(
//                    decoration: BoxDecoration(
//                      border: Border(
//                        bottom: BorderSide(
//                            color: Theme.of(context).cardColor, width: 0.5),
//                      ),
//                    ),
//                  ),
          child: Padding(
            padding: EdgeInsets.only(
              top: 0.5 * SizeConfig.heightMultiplier,
            ),
            child: TabBar(
              isScrollable: true,
              controller: controller,
              labelColor: Theme.of(context).accentColor,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 2 * SizeConfig.textMultiplier,
              ),
              unselectedLabelColor: Theme.of(context).accentColor,
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 2 * SizeConfig.textMultiplier,
              ),
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffEF3651),
                    width: 0.5 * SizeConfig.widthMultiplier,
                  ),
                ),
              ),
              tabs: List.generate(
                widget.itemCount,
                (index) => widget.tabBuilder(context, index),
              ),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              widget.itemCount,
              (index) => widget.pageBuilder(context, index),
            ),
          ),
        ),
      ],
    );
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll(controller.animation.value);
    }
  }
}

//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:mezgebestore/pages/add_shipping_address.dart';
//import 'package:mezgebestore/pages/payment.dart';
//
//class Shop3 extends StatefulWidget {
//  static const String id = 'shop3_screen';
//
//  @override
//  _Shop3State createState() => _Shop3State();
//}
//
//class _Shop3State extends State<Shop3> {
//  String clickedCategory = '';
//  void select(String newCategory) {
//    setState(() {
//      clickedCategory = newCategory;
//    });
//  }
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
////    _onPressed();
//  }
//
//  var firestoreInstance = Firestore.instance;
//  void _onPressed() {
//    firestoreInstance.collection("shop2").getDocuments().then((querySnapshot) {
//      querySnapshot.documents.forEach((result) {
//        firestoreInstance
//            .collection("shop2")
//            .document(result.documentID)
//            .collection(result.documentID)
//            .getDocuments()
//            .then((querySnapshot) {
//          querySnapshot.documents.forEach((result) {
//            print(result.data.length);
//          });
//        });
//      });
//    });
//  }
//
//  Future<QuerySnapshot> taskList() async {
//    QuerySnapshot todoResult;
//    QuerySnapshot result =
//        await firestoreInstance.collection("shop2").getDocuments();
//    for (var res in result.documents) {
//      todoResult = await firestoreInstance
//          .collection("shop2")
//          .document(res.documentID)
//          .collection(res.documentID)
//          .getDocuments();
//    }
//    return todoResult;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: AppBar(
//          backgroundColor: Colors.transparent,
//          bottomOpacity: 0.0,
//          elevation: 0.0,
//          centerTitle: true,
//          title: Text('Shipping'),
//          leading: IconButton(
//            icon: Icon(FontAwesomeIcons.arrowLeft),
//            iconSize: 18,
//            color: Colors.white,
//            onPressed: () {
//              Navigator.of(context).pushAndRemoveUntil(
//                  MaterialPageRoute(builder: (_) => PaymentPage()),
//                  (Route<dynamic> route) => false);
//            },
//          ),
//        ),
//        body: Column(
//          children: <Widget>[
//            StreamBuilder(
//              stream: Firestore.instance.collection("shop2").snapshots(),
//              builder: (context, snapshot) {
//                if (snapshot.data != null) {
//                  QuerySnapshot snap = snapshot.data;
//                  List<DocumentSnapshot> documents = snap.documents;
//                  return Container(
//                    height: 60,
//                    child: ListView.builder(
//                      scrollDirection: Axis.horizontal,
//                      shrinkWrap: true,
//                      itemCount: documents.length,
//                      itemBuilder: (BuildContext context, int index) {
//                        DocumentSnapshot doc = documents[index];
//                        return Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Container(
//                                height: 60,
//                                child: FlatButton(
//                                  onPressed: () {
//                                    select("${doc.documentID}");
//                                  },
//                                  child: Container(
//                                    height: 30,
//                                    width: 120,
//                                    child: Padding(
//                                      padding: const EdgeInsets.only(
//                                        top: 5.0,
//                                        bottom: 5,
//                                      ),
//                                      child: Text(
//                                        "${doc.documentID}",
//                                        textAlign: TextAlign.center,
//                                        style: TextStyle(
//                                          color: Colors.black,
//                                        ),
//                                      ),
//                                    ),
//                                    decoration: BoxDecoration(
//                                      borderRadius: BorderRadius.circular(20),
//                                      color: Colors.white,
//                                    ),
//                                  ),
//                                ),
//                              ),
//                            ]);
//                      },
//                    ),
//                  );
//                } else {
//                  return CircularProgressIndicator();
//                }
//              },
//            ),
//            clickedCategory == ""
////                ? Container(child: Text('Null'))
//                ? FutureBuilder(
//                    future: taskList(),
//                    builder: (context, AsyncSnapshot snapshot) {
//                      if (!snapshot.hasData) return Text("Loading...");
//                      return GridView.builder(
//                        physics: ScrollPhysics(),
//                        shrinkWrap: true,
//                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                          crossAxisCount: 2,
//                          childAspectRatio: 0.7,
//                        ),
//                        itemCount: snapshot.data.documents.length,
//                        itemBuilder: (BuildContext context, index) {
//                          return Column(
//                            children: <Widget>[
//                              Container(
//                                child: Expanded(
//                                  child: Card(
//                                    clipBehavior: Clip.antiAlias,
//                                    child: CachedNetworkImage(
//                                      height: 128,
//                                      placeholder: (context, url) => Container(
//                                        height: 128,
//                                        alignment: Alignment.center,
//                                        child: CircularProgressIndicator(),
//                                      ),
//                                      errorWidget: (context, url, error) =>
//                                          Container(
//                                        height: 128,
//                                        child: Icon(Icons.error),
//                                      ),
//                                      imageUrl: snapshot.data.documents[1]
//                                          ["image"],
//                                      fit: BoxFit.fill,
//                                    ),
//                                  ),
//                                ),
//                              ),
//                              Container(
//                                child: Padding(
//                                  padding: const EdgeInsets.symmetric(
//                                      horizontal: 10.0),
//                                  child: Column(
//                                    crossAxisAlignment:
//                                        CrossAxisAlignment.start,
//                                    children: <Widget>[
//                                      Text(
//                                        snapshot.data.documents[index]["brand"],
//                                        style: TextStyle(
//                                          fontSize: 15,
//                                          fontWeight: FontWeight.w600,
//                                        ),
//                                      ),
//                                      Text(
//                                        snapshot.data.documents[index]['brand'],
//                                        style: TextStyle(
//                                          color: Colors.grey,
//                                        ),
//                                      ),
//                                    ],
//                                  ),
//                                ),
//                              )
////
//                            ],
//                          );
//                        },
//                      );
//                    },
//                  )
//                : StreamBuilder(
//                    stream: Firestore.instance
//                        .collection('shop2')
//                        .document(clickedCategory)
//                        .collection(clickedCategory)
//                        .snapshots(),
//                    builder: (context, snapshot) {
//                      if (!snapshot.hasData) return Text("Loading...");
//                      return Expanded(
//                        child: GridView.builder(
//                          scrollDirection: Axis.vertical,
//                          itemCount: snapshot.data.documents.length,
//                          itemBuilder: (context, index) {
//                            return Column(
//                              children: <Widget>[
//                                Container(
//                                  child: Padding(
//                                    padding: const EdgeInsets.symmetric(
//                                        horizontal: 10.0),
//                                    child: Column(
//                                      crossAxisAlignment:
//                                          CrossAxisAlignment.start,
//                                      children: <Widget>[
//                                        Text(
//                                          snapshot.data.documents[index]
//                                              ['brand'],
//                                          style: TextStyle(
//                                            fontSize: 15,
//                                            fontWeight: FontWeight.w600,
//                                          ),
//                                        ),
//                                      ],
//                                    ),
//                                  ),
//                                )
////
//                              ],
//                            );
//                          },
//                          gridDelegate:
//                              SliverGridDelegateWithFixedCrossAxisCount(
//                            crossAxisCount: 2,
//                            childAspectRatio: 0.7,
//                          ),
//                        ),
//                      );
//                    })
//          ],
//        ));
//  }
//}

//            StreamBuilder(
//              stream: Firestore.instance.collection("shop3").snapshots(),
//              builder: (BuildContext context, AsyncSnapshot snapshot) {
//                if (!snapshot.hasData) {
//                  return CircularProgressIndicator();
//                }
//                return Expanded(
//                  child: ListView.builder(
//                    scrollDirection: Axis.horizontal,
//                    shrinkWrap: true,
//                    itemCount: snapshot.data.documents.length,
//                    itemBuilder: (context, index) {
//                      return Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Container(
//                              height: 60,
//                              child: FlatButton(
//                                onPressed: () {
//                                  select(snapshot.data.documents[index]
//                                      ['categoryName']);
//                                },
//                                child: Container(
//                                  height: 30,
//                                  width: 120,
//                                  child: Padding(
//                                    padding: const EdgeInsets.only(
//                                      top: 5.0,
//                                      bottom: 5,
//                                    ),
//                                    child: Text(
//                                      snapshot.data.documents[index]
//                                          ['categoryName'],
//                                      textAlign: TextAlign.center,
//                                      style: TextStyle(
//                                        color: Colors.black,
//                                      ),
//                                    ),
//                                  ),
//                                  decoration: BoxDecoration(
//                                    borderRadius: BorderRadius.circular(20),
//                                    color: Colors.white,
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ]);
//                    },
//                  ),
//                );
//              },
//            ),
//            StreamBuilder(
//                stream: Firestore.instance
//                    .collection('shop3')
//                    .document("yPkUbwBd997LWnaN01SW")
//                    .collection(_showCat)
//                    .snapshots(),
//                builder: (context, snapshot) {
//                  if (!snapshot.hasData) return Text("Loading...");
//                  return Expanded(
//                    child: GridView.builder(
//                      scrollDirection: Axis.vertical,
//                      itemCount: snapshot.data.documents.length,
//                      itemBuilder: (context, index) {
//                        return Column(
//                          children: <Widget>[
//                            Container(
//                              child: Padding(
//                                padding: const EdgeInsets.symmetric(
//                                    horizontal: 10.0),
//                                child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    Text(
//                                      snapshot.data.documents[index]['brand'],
//                                      style: TextStyle(
//                                        fontSize: 15,
//                                        fontWeight: FontWeight.w600,
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                              ),
//                            )
////
//                          ],
//                        );
//                      },
//                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                        crossAxisCount: 2,
//                        childAspectRatio: 0.7,
//                      ),
//                    ),
//                  );
//                })
//          ],
//        ));
//  }
//}
class AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Shop",
      style: Theme.of(context).textTheme.bodyText1.merge(
            TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
    );
  }
}
