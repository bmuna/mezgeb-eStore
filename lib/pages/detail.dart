import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mezgebestore/main_button.dart';
import 'package:mezgebestore/models/data.dart';
import 'package:mezgebestore/pages/navbar_controller.dart';
import 'package:mezgebestore/pages/splash_control.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Detail extends StatefulWidget {
  final Data post;
  Detail({this.post});
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  String firstHalf;
  String secondHalf;
  bool flag = true;
  BottomNavigationBarController controller = BottomNavigationBarController();
  var selectedSize, selectedColor;
  bool liked = false;
  bool containerTap = false;
  _pressed() {
    setState(() {
      liked = !liked;
    });
  }

  bool isExist = false;

  @override
  checkIfLikedOrNot() async {
    DocumentSnapshot ds =
        await databaseReference.collection("shop").document().get();
    this.setState(() {
      isExist = ds.exists;
    });
  }

////  final databaseReference2 = Firestore.instance;
//  void createCheckout() async {
//    DocumentReference ref = await databaseReference.collection("checkout").add({
//      'brand': widget.post.data["brand"],
//      'type': widget.post.data["type"],
//      'image': widget.post.data["image"],
//      'price': widget.post.data["price"],
//      'size': selectedSize,
//      'color': selectedColor,
//      'quantity': 1,
//    });
//    print(ref.documentID);
//  }

//  void createFavorite() async {
//    DocumentReference ref = await databaseReference.collection("Favorite").add({
//      'brand': widget.post.data["brand"],
//      'type': widget.post.data["type"],
//      'image': widget.post.data["image"],
//      'price': widget.post.data["price"],
//      'quantity': 1,
//    });
//    print(ref.documentID);
//  }
  final databaseReference = Firestore.instance;
  var a;
  String userId;

  void getUser() async {
    userId = (await FirebaseAuth.instance.currentUser()).uid;
  }

  void getData() async {
    var ref = await Firestore.instance
        .collection('users')
        .document(userId)
        .collection('cart')
        .document();
    ref.setData({
      'brand': widget.post.brand,
      'type': widget.post.type,
      'image': widget.post.imgUrl,
      'newPrice': widget.post.price,
      'size': selectedSize,
      'color': selectedColor,
      'quantity': 1,
      'id': ref.documentID,
    });
    print(ref.documentID);
  }
//  Future getData() async {
//    userId = (await FirebaseAuth.instance.currentUser()).uid;
//    return await databaseReference
//        .collection('users')
//        .document(userId)
//        .collection('cart')
//        .add({
//      'brand': widget.post.brand,
//      'type': widget.post.type,
//      'image': widget.post.imgUrl,
//      'newPrice': widget.post.price,
//      'size': selectedSize,
//      'color': selectedColor,
//      'quantity': 1,
//    });
//  }

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromLeft,
    backgroundColor: Color(0xff2A2C36),
    isCloseButton: false,
    isOverlayTapDismiss: true,
    descStyle: TextStyle(
        fontWeight: FontWeight.normal, color: Colors.white, fontSize: 15),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: BorderSide(
        color: Colors.white,
      ),
    ),
    titleStyle: TextStyle(
        color: Colors.green, fontWeight: FontWeight.bold, fontSize: 30),
  );

  void size() {
    Alert(
        context: context,
        image: Image.asset(
          "images/sale.png",
          width: 150,
          height: 100,
        ),
        style: alertStyle,
        title: "Almost There!!",
        desc:
            "You can buy your item by checking out or you can continue shopping.",
        buttons: [
          DialogButton(
            child: Text(
              "Check Out",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            onPressed: () {
              getData();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SplashControl(),
                ),
              );
            },
            color: Color(0xffEF3651),
          ),
          DialogButton(
            child: Text(
              "Continue Shopping",
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            color: Colors.white,
          ),
        ]).show();
  }

  String description;
  @override
  void initState() {
    super.initState();
    getUser();
    checkIfLikedOrNot();
    description = widget.post.description;
    if (description.length > 50) {
      firstHalf = description.substring(0, 50);
      secondHalf = description.substring(50, description.length);
    } else {
      firstHalf = description;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: Text(widget.post.type),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              child: PhotoViewGallery.builder(
                itemCount: widget.post.imgUrl.length,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(widget.post.imgUrl[index]),
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  );
                },
                scrollPhysics: BouncingScrollPhysics(),
                backgroundDecoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection("shop").snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return const Text("Loading.....");
                        else {
                          List<DropdownMenuItem> sizeItems = [];
                          List<DropdownMenuItem> colorItems = [];
                          for (int i = 0; i < widget.post.size.length; i++) {
                            sizeItems.add(
                              DropdownMenuItem(
                                child: Text(
//                                snapshot.data.documents[i]['size'][i],
                                  widget.post.size[i],

                                  style: TextStyle(color: Color(0xff11b719)),
                                ),
                                value:
//                              "${snapshot.data.documents[i]['size'][i]}",
                                    "${widget.post.size[i]}",
                              ),
                            );
                          }
                          for (int i = 0; i < widget.post.color.length; i++) {
                            colorItems.add(
                              DropdownMenuItem(
                                child: Text(
                                  widget.post.color[i],
                                  style: TextStyle(color: Color(0xff11b719)),
                                ),
                                value: "${widget.post.color[i]}",
                              ),
                            );
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 130,
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 0.80),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    iconEnabledColor: Colors.white,
                                    items: sizeItems,
                                    onChanged: (sizeValue) {
                                      setState(() {
                                        selectedSize = sizeValue;
                                      });
                                    },
                                    value: selectedSize,
                                    isExpanded: false,
                                    hint: new Text(
                                      "Size",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                width: 130,
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 0.80),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    iconEnabledColor: Colors.white,
                                    items: colorItems,
                                    onChanged: (colorValue) {
                                      setState(() {
                                        selectedColor = colorValue;
                                      });
                                    },
                                    value: selectedColor,
                                    isExpanded: false,
                                    hint: new Text(
                                      "Color",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      color: Color(0xff2A2C36),
                      child: IconButton(
                        onPressed: () {
                          _pressed();
//                        createFavorite();
                        },
                        icon: Icon(
                          liked ? Icons.favorite : Icons.favorite_border,
                          color: liked ? Colors.red : Colors.grey,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.post.brand,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: <Widget>[
                          isExist
                              ? Row(
                                  children: <Widget>[
                                    Text(
                                      widget.post.oldPrice,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.lineThrough,
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
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: <Widget>[
                                    Text(
                                      widget.post.price,
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
                    ],
                  ),
                  Text(
                    widget.post.type,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: new EdgeInsets.symmetric(vertical: 10.0),
                    child: secondHalf.isEmpty
                        ? new Text(firstHalf)
                        : new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(flag
                                  ? (firstHalf + "...")
                                  : (firstHalf + secondHalf)),
                              SizedBox(
                                height: 10,
                              ),
                              new InkWell(
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    new Text(
                                      flag ? "show more" : "show less",
                                      style: new TextStyle(
                                          color: Color(0xffEF3651),
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    flag = !flag;
                                  });
                                },
                              ),

//                  Text(
//                    widget.post.data["description"],
//                    style: TextStyle(
//                      fontWeight: FontWeight.w100,
//                    ),
//                  ),
                              SizedBox(
                                height: 20.0,
                              ),
                              MainButton(
                                onPressed: () {
                                  size();
                                },
                                text: 'Add to cart',
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
