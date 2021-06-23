import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/stores/business_name.dart';
import 'package:mezgebestore/stores/size_config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mezgebestore/pages/home.dart';
import 'package:mezgebestore/pages/navbar_controller.dart';
import 'package:mobx/mobx.dart';
import 'package:mezgebestore/pages/otp_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String actualCode;
  String b;

  @observable
  bool isLoginLoading = false;
  @observable
  bool isOtpLoading = false;

  @observable
  GlobalKey<ScaffoldState> loginScaffoldKey = GlobalKey<ScaffoldState>();
  @observable
  GlobalKey<ScaffoldState> otpScaffoldKey = GlobalKey<ScaffoldState>();

  @observable
  FirebaseUser firebaseUser;

  @action
  Future<bool> isAlreadyAuthenticated() async {
    firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      return true;
    } else {
      return false;
    }
  }

  BusinessName businessName = BusinessName();

//  String phoneNumber;
  void a() {}
  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('images/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future uploadFile() async {
    File f = await getImageFileFromAssets('profile.jpg');
    StorageTaskSnapshot snapshot = await FirebaseStorage.instance
        .ref()
        .child('profile pictures/${Path.basename(f.path)}')
        .putFile(f)
        .onComplete;

    if (snapshot.error == null) {
      String downloadUrl = await snapshot.ref.getDownloadURL();
      var a = await Firestore.instance
          .collection("business")
          .document(businessName.name)
          .collection('users')
          .document(firebaseUser.uid)
          .collection('profile')
          .document(firebaseUser.uid);
      a.setData({
        'id': a.documentID,
        "profilePicture": downloadUrl,
        "phone": '0911000000',
        "email": 'example@gmail.com',
        "fullName": 'Full Name',
      });
      b = a.documentID;
      print(a.documentID);
//          .add(
//        {
//          "profilePicture": downloadUrl,
//        },
//      );
    }
  }

  @action
  Future<void> getCodeWithPhoneNumber(BuildContext context, phoneNumber) async {
    isLoginLoading = true;
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (AuthCredential auth) async {
          await _auth.signInWithCredential(auth).then((AuthResult value) {
            if (value != null && value.user != null) {
              print('Authentication successful');
              onAuthenticationSuccessful(context, value, phoneNumber);
            } else {
              loginScaffoldKey.currentState.showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
                content: Text(
                  AppLocalizations.of(context)
                      .translate('invalid Code/invalid authentication'),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 2.3 * SizeConfig.textMultiplier),
                ),
              ));
            }
          }).catchError((error) {
            loginScaffoldKey.currentState.showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              content: Text(
                AppLocalizations.of(context)
                    .translate("invalid Code/invalid authentication2"),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 2.3 * SizeConfig.textMultiplier),
              ),
            ));
          });
        },
        verificationFailed: (AuthException authException) {
          print('Error message: ' + authException.message);
          loginScaffoldKey.currentState.showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            content: Text(
              AppLocalizations.of(context).translate('internetError'),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 2.3 * SizeConfig.textMultiplier),
            ),
          ));
          isLoginLoading = false;
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          actualCode = verificationId;
          isLoginLoading = false;
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => OtpPage(
                    phone: phoneNumber,
                  )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          actualCode = verificationId;
        });
  }

  @action
  Future<void> validateOtpAndLogin(
      BuildContext context, String smsCode, phoneNumber) async {
    isOtpLoading = true;
    final AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: actualCode, smsCode: smsCode);

    await _auth.signInWithCredential(_authCredential).catchError((error) {
      isOtpLoading = false;
      otpScaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        content: Text(
          AppLocalizations.of(context).translate('wrongCode'),
          style: TextStyle(
              color: Colors.white, fontSize: 2.6 * SizeConfig.textMultiplier),
        ),
      ));
    }).then((AuthResult authResult) {
      if (authResult != null && authResult.user != null) {
        print('Authentication successful');
        onAuthenticationSuccessful(context, authResult, phoneNumber);
      }
    });

//    try {
//      var res = await Firestore.instance
//          .collection("user")
//          .document(firebaseUser.uid)
//          .get();
//      var res2 = res.documentID;
//      if (res2 != null) {
//        print("exist!!!!!!");
//      } else {
//        print("not existed");
//      }
//    } catch (err) {
//      print(err);
//    }
//    Firestore.instance
//        .collection('users')
//        .document(firebaseUser.uid)
//        .setData({'phone': phoneNumber, 'userId': firebaseUser.uid});
  }

  Future<void> onAuthenticationSuccessful(
      BuildContext context, AuthResult result, phoneNumber) async {
    isLoginLoading = true;
    isOtpLoading = true;

    firebaseUser = result.user;
    try {
      Firestore.instance
          .collection("business")
          .document(businessName.name)
          .collection("users")
          .document(firebaseUser.uid)
          .get()
          .then((doc) {
        if (doc.exists) {
          a();
          print("Exist!!!!!!!!!");
        } else {
          print("not exist!!!!!!!!!!!");
          uploadFile();
          Firestore.instance
              .collection("business")
              .document(businessName.name)
              .collection('users')
              .document(firebaseUser.uid)
              .setData({'phone': phoneNumber, 'userId': firebaseUser.uid});
        }
      });
    } catch (e) {
      return false;
    }

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => BottomNavigationBarController(
            selectedIndex: 2,
          ),
        ),
        (Route<dynamic> route) => false);
    print('firebaseuser: ${firebaseUser.uid}');

    isLoginLoading = false;
    isOtpLoading = false;
  }

  @action
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => BottomNavigationBarController(
            selectedIndex: 0,
          ),
        ),
        (Route<dynamic> route) => false);
    firebaseUser = null;
  }
}
