import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mezgebestore/constant.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/pages/editAddress.dart';
import 'package:mezgebestore/stores/business_name.dart';
import 'package:mezgebestore/stores/size_config.dart';
import 'package:mezgebestore/widgets/main_button.dart';

class EditAddressPage extends StatefulWidget {
  String place;
  String address;
  String phone;
  String documentId;
  EditAddressPage(this.place, this.address, this.phone, this.documentId);
  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  BusinessName businessName = BusinessName();

  String placeHolder;
  String addressHolder;
  String phoneHolder;
  String userId;
  var updateData;

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

  void editPage() {
    print(userId);
    print(widget.documentId);
    updateData = Firestore.instance
        .collection("business")
        .document(businessName.name)
        .collection('users')
        .document(userId)
        .collection('shipping')
        .document(widget.documentId)
        .updateData({
      if (placeHolder != null) "place": placeHolder,
      if (addressHolder != null) "address": addressHolder,
      if (phoneHolder != null) "phone": phoneHolder,
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWidgetWrapper(
      height: 4.6 * SizeConfig.heightMultiplier,
      color: Color(0xffEF3651),
      message: "Please check your internet connection!!",
      messageStyle: TextStyle(
        fontFamily: "Inter",
        color: Colors.white,
        fontSize: 2 * SizeConfig.textMultiplier,
        decoration: TextDecoration.none,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          bottomOpacity: 0.0,
          elevation: 3.0,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context).translate("editYourAddress"),
            style: Theme.of(context).textTheme.bodyText1.merge(
                  TextStyle(
                    fontSize: 2.8 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 2.6 * SizeConfig.heightMultiplier,
            color: Theme.of(context).indicatorColor,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(
            2.3 * SizeConfig.heightMultiplier,
          ),
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: widget.place,
                autofocus: false,
                style: Theme.of(context).textTheme.bodyText1.merge(
                      TextStyle(
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                      ),
                    ),
                decoration: KTextFieldDecoration.copyWith(
                  labelText: AppLocalizations.of(context)
                      .translate("describeYourPlace"),
                  labelStyle: Theme.of(context).textTheme.bodyText1.merge(
                        TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 2.3 * SizeConfig.textMultiplier,
                        ),
                      ),
                ),
                onChanged: (valName) {
                  setState(() {
                    placeHolder = valName;
                  });
                },
              ),
              SizedBox(
                height: 3.1 * SizeConfig.heightMultiplier,
              ),
              TextFormField(
                initialValue: widget.address,
                autofocus: false,
                style: Theme.of(context).textTheme.bodyText1.merge(
                      TextStyle(
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                      ),
                    ),
                decoration: KTextFieldDecoration.copyWith(
                  labelText:
                      AppLocalizations.of(context).translate("addressName"),
                  labelStyle: Theme.of(context).textTheme.bodyText1.merge(
                        TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 2.3 * SizeConfig.textMultiplier,
                        ),
                      ),
                ),
                onChanged: (valName) {
                  setState(() {
                    addressHolder = valName;
                  });
                },
              ),
              SizedBox(
                height: 3.1 * SizeConfig.heightMultiplier,
              ),
              TextFormField(
                initialValue: widget.phone,
                keyboardType: TextInputType.phone,
                autofocus: false,
                style: Theme.of(context).textTheme.bodyText1.merge(
                      TextStyle(
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                      ),
                    ),
                decoration: KTextFieldDecoration.copyWith(
                  labelText: AppLocalizations.of(context)
                      .translate("phoneEditAddressPage"),
                  labelStyle: Theme.of(context).textTheme.bodyText1.merge(
                        TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 2.3 * SizeConfig.textMultiplier,
                        ),
                      ),
                ),
                onChanged: (valName) {
                  setState(() {
                    phoneHolder = valName;
                  });
                },
              ),
              SizedBox(
                height: 4.6 * SizeConfig.heightMultiplier,
              ),
            ],
          ),
        ),
        bottomNavigationBar: EditButton(
          edited: editPage,
        ),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  const EditButton({Key key, this.edited}) : super(key: key);

  final Function edited;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: MainButton(
        text: AppLocalizations.of(context).translate("edit"),
        onPressed: () {
          edited();
          Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).accentColor,
            duration: Duration(milliseconds: 900),
            content: Container(
              height: 5 * SizeConfig.heightMultiplier,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate('edited'),
                    style: Theme.of(context).textTheme.subtitle2.merge(
                        TextStyle(fontSize: 2.3 * SizeConfig.heightMultiplier)),
                  ),
                  Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 3 * SizeConfig.heightMultiplier,
                  )
                ],
              ),
            ),
          ));
        },
      ),
    );
  }
}
