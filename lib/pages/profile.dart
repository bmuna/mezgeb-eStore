import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/pages/edit_profiles.dart';
import 'package:mezgebestore/pages/editAddress.dart';

import 'package:mezgebestore/pages/login_page.dart';
import 'package:mezgebestore/pages/my_order_page.dart';
import 'package:mezgebestore/pages/setting.dart';
import 'package:mezgebestore/stores/business_name.dart';
import 'package:mezgebestore/stores/size_config.dart';

class Profile extends StatefulWidget {
  static const String id = 'profile_screen';

  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  BusinessName businessName = BusinessName();

  String userId;
  String profilePic;
  String fullName;
  var document;
  Map<String, dynamic> documentFields;
//  String count;
  var count;

  void getUser() async {
    try {
      userId = (await FirebaseAuth.instance.currentUser()).uid;
      var documents = await Firestore.instance
          .collection("business")
          .document(businessName.name)
          .collection('users')
          .document(userId)
          .collection("shipping")
          .getDocuments();
      count = documents.documents.length.toString();
      print("print: $count");
    } catch (e) {
      print(e);
    }
  }

//  List<DocumentSnapshot> _myDocCount;
//  void countDocuments() async {
//    QuerySnapshot _myDoc = await Firestore.instance
//        .collection('users')
//        .document("f9V0Y4i4SUbuLAyImurM60pCmKK2")
//        .collection("shipping")
//        .getDocuments();
//    _myDocCount = _myDoc.documents;
//    print("here is: ${_myDocCount.length}"); // Count of Documents in Collection
//  }
  Stream stream;
  @override
  void initState() {
    super.initState();
    getUser();
    stream = Firestore.instance
        .collection('users')
        .document(userId)
        .collection("shipping")
        .snapshots();
  }

  Future<DocumentSnapshot> getUserInfo() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    return await Firestore.instance
        .collection("business")
        .document(businessName.name)
        .collection("users")
//        .document(firebaseUser.uid)
        .document(firebaseUser.uid)
        .collection('profile')
//        .document(firebaseUser.uid)
        .document(firebaseUser.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 5 * SizeConfig.heightMultiplier,
              ),
              child: FutureBuilder(
                future: getUserInfo(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData || !snapshot.data.exists) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).translate('myProfile'),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .merge(TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 4.3 * SizeConfig.textMultiplier,
                              )),
                        ),
                        SizedBox(
                          height: 3.1 * SizeConfig.heightMultiplier,
                        ),
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 8.5 * SizeConfig.heightMultiplier,
                              backgroundColor: Color(0xffEF3651),
                              child: ClipOval(
                                child: Container(
                                  height: 16 * SizeConfig.heightMultiplier,
                                  width: 16 * SizeConfig.heightMultiplier,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage('images/profile.jpg'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5.5 * SizeConfig.widthMultiplier),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context)
                                          .translate('fullName')
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .merge(
                                            TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 2.5 *
                                                  SizeConfig.textMultiplier,
                                            ),
                                          ),
                                    ),
                                    SizedBox(
                                      height: 0.5 * SizeConfig.heightMultiplier,
                                    ),
                                    Text('example@gmail.com',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .merge(
                                              TextStyle(
                                                fontWeight: FontWeight.w100,
                                                fontSize: 1.9 *
                                                    SizeConfig.textMultiplier,
                                              ),
                                            )),
                                    SizedBox(
                                      height: 0.5 * SizeConfig.heightMultiplier,
                                    ),
                                    Text("09110000000",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .merge(
                                              TextStyle(
                                                fontWeight: FontWeight.w100,
                                                fontSize: 1.9 *
                                                    SizeConfig.textMultiplier,
                                              ),
                                            )),
                                    SizedBox(
                                      height: 1.5 * SizeConfig.heightMultiplier,
                                    ),
                                  ],
                                ),
//                              userId == null
//                                  ? Container()
//                                  : RaisedButton(
//                                      shape: RoundedRectangleBorder(
//                                        borderRadius: BorderRadius.circular(
//                                          2.8 * SizeConfig.heightMultiplier,
//                                        ),
//                                      ),
//                                      onPressed: () {
//                                        Navigator.push(
//                                          context,
//                                          MaterialPageRoute(
//                                            builder: (context) =>
//                                                EditProfile(),
//                                          ),
//                                        );
//                                      },
//                                      color: Color(0xffEF3651),
//                                      textColor: Colors.white,
//                                      child: Text(
//                                        "Edit profile",
//                                        style: TextStyle(
//                                          fontSize:
//                                              2.1 * SizeConfig.textMultiplier,
//                                        ),
//                                      ),
//                                    ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 3.1 * SizeConfig.heightMultiplier,
                        )
                      ],
                    );
                  }
                  var userDocument = snapshot.data;
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).translate('myProfile'),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .merge(TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 4.3 * SizeConfig.textMultiplier,
                              )),
                        ),
                        SizedBox(
                          height: 3.1 * SizeConfig.heightMultiplier,
                        ),
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                                radius: 8.5 * SizeConfig.heightMultiplier,
                                backgroundColor: Color(0xffEF3651),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    height: 16 * SizeConfig.heightMultiplier,
                                    width: 16 * SizeConfig.heightMultiplier,
                                    placeholder: (context, url) => Container(
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                      child: Container(
                                        child: Icon(
                                          Icons.error,
                                          size:
                                              4.6 * SizeConfig.heightMultiplier,
                                        ),
                                      ),
                                    ),
                                    imageUrl: userDocument['profilePicture'],
                                    fit: BoxFit.cover,
//                                  fit: BoxFit.fill,
                                  ),
                                )),
                            SizedBox(
                              width: 5.8 * SizeConfig.widthMultiplier,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(userDocument['fullName'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .merge(
                                              TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 2.5 *
                                                    SizeConfig.textMultiplier,
                                              ),
                                            )),
                                    Text(userDocument['email'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .merge(
                                              TextStyle(
                                                fontWeight: FontWeight.w100,
                                                fontSize: 1.9 *
                                                    SizeConfig.textMultiplier,
                                              ),
                                            )),
                                    SizedBox(
                                      height: 0.7 * SizeConfig.heightMultiplier,
                                    ),
                                    Text(userDocument['phone'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .merge(
                                              TextStyle(
                                                fontWeight: FontWeight.w100,
                                                fontSize: 1.9 *
                                                    SizeConfig.textMultiplier,
                                              ),
                                            )),
                                    SizedBox(
                                        height:
                                            1.5 * SizeConfig.heightMultiplier),
                                  ],
                                ),
                                SizedBox(
                                  height: 5 * SizeConfig.heightMultiplier,
                                  width: 18 * SizeConfig.heightMultiplier,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        2.8 * SizeConfig.heightMultiplier,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditProfile(),
                                        ),
                                      );
                                    },
                                    color: Color(0xffEF3651),
                                    textColor: Colors.white,
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('editProfile'),
                                      style: TextStyle(
                                        fontSize:
                                            1.9 * SizeConfig.textMultiplier,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 3.1 * SizeConfig.heightMultiplier,
                        )
                      ]);
                },
              ),
            ),
            Container(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Divider(
                    color: Colors.grey[800],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyOrder(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 1 * SizeConfig.heightMultiplier,
                      ),
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context).translate("myOrder"),
                          style: Theme.of(context).textTheme.bodyText1.merge(
                                TextStyle(
                                  fontSize: 2.1 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 1 * SizeConfig.heightMultiplier,
                          ),
                          child: Text(
                              AppLocalizations.of(context).translate("12Order"),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .merge(
                                    TextStyle(
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                    ),
                                  )),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          iconSize: 3.1 * SizeConfig.textMultiplier,
                          color: Colors.grey,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyOrder(),
                              ),
                            );
                          },
                        ),
//                    trailing: Icon(
//                      Icons.arrow_forward_ios,
//                      color: Colors.grey,
//                      size: 20,
//                    ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[800],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 1 * SizeConfig.heightMultiplier,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditAddress(),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context)
                              .translate("shippingAddress"),
                          style: Theme.of(context).textTheme.bodyText1.merge(
                                TextStyle(
                                  fontSize: 2.1 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 1 * SizeConfig.heightMultiplier,
                          ),
                          child: StreamBuilder(
                            stream: Firestore.instance
                                .collection("business")
                                .document(businessName.name)
                                .collection('users')
                                .document(userId)
                                .collection("shipping")
                                .snapshots(),
//                              .then((value) {
//                            count = value.documents.length + 1;
//                          }),
                            builder: (BuildContext context, snapshot) {
//                              if (userId == null) {
                              if (!snapshot.hasData ||
                                  snapshot.data.documents.isEmpty ||
                                  snapshot.data == null ||
                                  snapshot.data.documents.length == 0 ||
                                  userId == null) {
//                                CircularProgressIndicator();
                                Text(
                                  "${0.toString() + AppLocalizations.of(context).translate("address")}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .merge(
                                        TextStyle(
                                          fontSize:
                                              1.8 * SizeConfig.textMultiplier,
                                        ),
                                      ),
                                );
                              }
                              return Text(
                                  "${count.toString() + AppLocalizations.of(context).translate("address")}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .merge(
                                        TextStyle(
                                          fontSize:
                                              1.8 * SizeConfig.textMultiplier,
                                        ),
                                      ));
                            },
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          iconSize: 3.1 * SizeConfig.textMultiplier,
                          color: Colors.grey,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditAddress(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[800],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Settings(uid: userId),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 1 * SizeConfig.heightMultiplier,
                      ),
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context).translate("settings"),
                          style: Theme.of(context).textTheme.bodyText1.merge(
                                TextStyle(
                                  fontSize: 2.1 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 1 * SizeConfig.heightMultiplier,
                          ),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate("name,phoneNumber"),
                            style: Theme.of(context).textTheme.subtitle1.merge(
                                  TextStyle(
                                    fontSize: 1.8 * SizeConfig.textMultiplier,
                                  ),
                                ),
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          iconSize: 3.1 * SizeConfig.textMultiplier,
                          color: Colors.grey,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Settings(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[800],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
