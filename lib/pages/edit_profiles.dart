import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/pages/navbar_controller.dart';
import 'package:mezgebestore/pages/profile.dart';
import 'package:mezgebestore/stores/business_name.dart';
import 'package:mezgebestore/stores/size_config.dart';
import 'package:path/path.dart' as Path;

import '../constant.dart';

class EditProfile extends StatefulWidget {
  static const String id = 'setting_screen';

  const EditProfile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<EditProfile> {
  BusinessName businessName = BusinessName();

  String fullName;
  String phoneNumber;
  String address;
  String email;
  String downloadUrl;
  File _image;
  String _uploadedFileURL;
  bool isLoading = false;
  String userId;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      getUser();
    });
  }

  void getUser() async {
    userId = (await FirebaseAuth.instance.currentUser()).uid;
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    ).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadFile() async {
    setState(() {
      isLoading = true;
    });

    if (_image != null) {
      StorageTaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child('profile pictures/${Path.basename(_image.path)}')
          .putFile(_image)
          .onComplete;

      if (snapshot.error == null) {
        downloadUrl = await snapshot.ref.getDownloadURL();
        await Firestore.instance
            .collection("business")
            .document(businessName.name)
            .collection('users')
            .document(userId)
            .collection('profile')
            .document(userId)
            .updateData({
          "profilePicture": downloadUrl,
          if (email != null)
            "email": email,
          if (fullName != null)
            "fullName": fullName,
          if (phoneNumber != null)
            "phone": phoneNumber,
//        if (downloadUrl?.isEmpty ?? true) "profilePicture": downloadUrl,
//        if (email?.isEmpty ?? true) "email": email,
//        if (fullName?.isEmpty ?? true) "fullName": fullName,
//        if (phoneNumber?.isEmpty ?? true) "phone": phoneNumber,
        });

        print('File Uploaded');
        setState(() {
          _uploadedFileURL = downloadUrl;
          isLoading = false;
          Snakie();
        });
      }
    } else {
      Firestore.instance
          .collection("business")
          .document(businessName.name)
          .collection('users')
          .document(userId)
          .collection('profile')
          .document(userId)
          .updateData({
        if (email != null) "email": email,
        if (fullName != null) "fullName": fullName,
        if (phoneNumber != null) "phone": phoneNumber,
      });
    }
    setState(() {
      isLoading = false;
      Snakie();
    });
  }

  Future<DocumentSnapshot> getUserInfo() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    return await Firestore.instance
        .collection("business")
        .document(businessName.name)
        .collection("users")
        .document(firebaseUser.uid)
        .collection('profile')
        .document(firebaseUser.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          bottomOpacity: 0.0,
          elevation: 3.0,
          title: Text(
            AppLocalizations.of(context).translate('editProfile'),
            style: Theme.of(context).textTheme.bodyText1.merge(
                  TextStyle(
                    fontSize: 2.8 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 2.6 * SizeConfig.heightMultiplier,
            color: Theme.of(context).indicatorColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavigationBarController(
                    selectedIndex: 3,
                  ),
                ),
              );
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Stack(children: <Widget>[
                          FutureBuilder(
                              future: getUserInfo(),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: Container(
                                      height: 4.6 * SizeConfig.heightMultiplier,
                                      width: 4.6 * SizeConfig.heightMultiplier,
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                var userDocument = snapshot.data;
//                                TextEditingController phoneController =
//                                    TextEditingController(
//                                        text: userDocument['phone']);
//                                TextEditingController fullNameController =
//                                    TextEditingController(
//                                        text: userDocument['fullName']);
//                                TextEditingController emailController =
//                                    TextEditingController(
//                                        text: userDocument['email']);
                                return Stack(
                                  alignment: Alignment.topCenter,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 7.8 * SizeConfig.heightMultiplier,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          2.3 * SizeConfig.heightMultiplier,
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 10.9 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                            TextFormField(
//                                              controller: phoneController,
                                              initialValue:
                                                  userDocument['fullName'],
//                                              validator: (valName) => valName
//                                                          .length !=
//                                                      10
//                                                  ? 'Phone number is incorrect'
//                                                  : null,
                                              onChanged: (valName) {
                                                setState(() {
                                                  fullName = valName;
                                                });
                                              },
                                              autofocus: false,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .merge(
                                                    TextStyle(
                                                      fontSize: 2.5 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                    ),
                                                  ),
                                              decoration: KTextFieldDecoration
                                                  .copyWith(),
                                            ),
                                            SizedBox(
                                              height: 3.1 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                            TextFormField(
//                                              controller: phoneController,
                                              initialValue:
                                                  userDocument['phone'],
                                              keyboardType: TextInputType.phone,
//                                              validator: (valName) => valName
//                                                          .length !=
//                                                      10
//                                                  ? 'Phone number is incorrect'
//                                                  : null,
                                              onChanged: (valName) {
                                                setState(() {
                                                  phoneNumber = valName;
                                                });
                                              },
                                              autofocus: false,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .merge(
                                                    TextStyle(
                                                      fontSize: 2.5 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                    ),
                                                  ),
                                              decoration: KTextFieldDecoration
                                                  .copyWith(),
                                            ),
                                            SizedBox(
                                              height: 3.1 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                            TextFormField(
                                              initialValue:
                                                  userDocument['email'],
//                                              controller: emailController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
//                                              validator: (valName) => valName
//                                                          .length !=
//                                                      10
//                                                  ? 'Phone number is incorrect'
//                                                  : null,
                                              onChanged: (valName) {
                                                setState(() {
                                                  email = valName;
                                                  print(userDocument['email']);
                                                });
                                              },
                                              autofocus: false,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .merge(
                                                    TextStyle(
                                                      fontSize: 2.5 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                    ),
                                                  ),
                                              decoration: KTextFieldDecoration
                                                  .copyWith(),
                                            ),
                                            SizedBox(
                                              height: 4.6 *
                                                  SizeConfig.heightMultiplier,
                                            ),
                                            _image != null
                                                ? isLoading
                                                    ? SizedBox(
                                                        width: double.infinity,
                                                        height: 6 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                        child: RaisedButton(
                                                          child:
                                                              CircularProgressIndicator(),
                                                          onPressed: () {},
                                                          color:
                                                              Color(0xffEF3651),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              4.6 *
                                                                  SizeConfig
                                                                      .heightMultiplier,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        width: double.infinity,
                                                        height: 6 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                        child: RaisedButton(
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .translate(
                                                                    'upload'),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 2.3 *
                                                                  SizeConfig
                                                                      .heightMultiplier,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            uploadFile()
                                                                .whenComplete(
                                                                    () {
                                                              print(_formKey);
                                                              Scaffold.of(
                                                                      context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                backgroundColor:
                                                                    Theme.of(
                                                                            context)
                                                                        .accentColor,
                                                                content: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      AppLocalizations.of(
                                                                              context)
                                                                          .translate(
                                                                              'successful'),
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .subtitle2,
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .check,
                                                                      color: Colors
                                                                          .green,
                                                                    )
                                                                  ],
                                                                ),
                                                              ));
                                                            });
                                                          },
                                                          color:
                                                              Color(0xffEF3651),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .circular(4.6 *
                                                                    SizeConfig
                                                                        .heightMultiplier),
                                                          ),
                                                        ),
                                                      )
                                                : SizedBox(
                                                    height: 6 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    width: double.infinity,
                                                    child: RaisedButton(
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .translate(
                                                                'upload'),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 2.3 *
                                                              SizeConfig
                                                                  .heightMultiplier,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        uploadFile()
                                                            .whenComplete(() {
                                                          Scaffold.of(context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .accentColor,
                                                            content: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  AppLocalizations.of(
                                                                          context)
                                                                      .translate(
                                                                          'successful'),
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .subtitle2,
                                                                ),
                                                                Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .green,
                                                                )
                                                              ],
                                                            ),
                                                          ));
                                                        });
                                                      },
                                                      color: Color(0xffEF3651),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(4.6 *
                                                                SizeConfig
                                                                    .heightMultiplier),
                                                      ),
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                    _uploadedFileURL != null
                                        ? CircleAvatar(
                                            radius: 9.3 *
                                                SizeConfig.heightMultiplier,
                                            backgroundImage: FileImage(_image),
                                            child: Container(
                                              alignment: Alignment.bottomRight,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: 7.8 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  top: 7.8 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                ),
                                                child: MaterialButton(
                                                  onPressed: () {
                                                    chooseFile();
                                                  },
                                                  color: Color(0xffEF3651),
                                                  textColor: Colors.white,
                                                  child: Icon(
                                                    Icons.camera_alt,
                                                    size: 3.1 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                  ),
                                                  padding: EdgeInsets.all(
                                                    0.7 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                  ),
                                                  shape: CircleBorder(),
                                                ),
                                              ),
                                            ),
                                          )
                                        : CircleAvatar(
                                            radius: 9.3 *
                                                SizeConfig.heightMultiplier,
                                            backgroundImage: NetworkImage(
                                              userDocument['profilePicture'],
                                            ),
                                            child: Container(
                                              alignment: Alignment.bottomRight,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: 7.8 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  top: 7.8 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                ),
                                                child: MaterialButton(
                                                  onPressed: () {
                                                    chooseFile();
                                                  },
                                                  color: Color(0xffEF3651),
                                                  textColor: Colors.white,
                                                  child: Icon(
                                                    Icons.camera_alt,
                                                    size: 3.1 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                  ),
                                                  padding: EdgeInsets.all(
                                                    0.7 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                  ),
                                                  shape: CircleBorder(),
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                );
                              }),
                        ]),
                      ],
                    ),
                  ]),
            ),
          ),
        ));
  }
}

class Snakie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
