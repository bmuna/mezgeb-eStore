import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mezgebestore/constant.dart';
import 'package:mezgebestore/register_button.dart';
import 'package:provider/provider.dart';
import 'package:mezgebestore/stores/login_store.dart';
import 'package:mezgebestore/widgets/loader_hud.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  String phoneNumber = '';
  showSnackBar() {}
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoaderHUD(
            inAsyncCall: loginStore.isLoginLoading,
            child: Scaffold(
              backgroundColor: Color(0xFF1E1F28),
              key: loginStore.loginScaffoldKey,
              body: SafeArea(
                child: SingleChildScrollView(
                    child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Image.asset('images/'
                              'i.png'),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Column(children: <Widget>[
                        Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: 'We will send you an ',
                                  style: TextStyle(color: Colors.white)),
                              TextSpan(
                                  text: 'One Time Code ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'on this mobile number',
                                  style: TextStyle(color: Colors.white)),
                            ]),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(color: Color(0xff2A2C36)),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              validator: (val) => val.isEmpty
                                  ? 'Please enter a phone number'
                                  : null,
                              onChanged: (value) {
                                setState(() => phoneNumber = value);
                              },
                              controller: phoneController,
                              autofocus: false,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Color(0xffF7F7F7),
                              ),
                              decoration: KTextFieldDecoration.copyWith(
                                hintText: 'eg: +25109000000',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 15,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: RegisterButton(
                          text: 'Next',
                          onPressed: () {
                            if (phoneController.text.isNotEmpty) {
                              loginStore.getCodeWithPhoneNumber(
                                  context, phoneController.text.toString());
                            } else {
                              loginStore.loginScaffoldKey.currentState
                                  .showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    'Please enter a phone number',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
//                      Container(
//                        margin: const EdgeInsets.symmetric(
//                            horizontal: 20, vertical: 10),
//                        constraints: const BoxConstraints(maxWidth: 500),
//                        child: RaisedButton(
//                          onPressed: () {
//                            if (phoneController.text.isNotEmpty) {
//                              loginStore.getCodeWithPhoneNumber(
//                                  context, phoneController.text.toString());
//                            } else {
//                              loginStore.loginScaffoldKey.currentState
//                                  .showSnackBar(SnackBar(
//                                behavior: SnackBarBehavior.floating,
//                                backgroundColor: Colors.red,
//                                content: Text(
//                                  'Please enter a phone number',
//                                  style: TextStyle(color: Colors.white),
//                                ),
//                              ));
//                            }
//                          },
//                          color: MyColors.primaryColor,
//                          shape: const RoundedRectangleBorder(
//                              borderRadius:
//                                  BorderRadius.all(Radius.circular(14))),
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: <Widget>[
//                              Text(
//                                'Next',
//                                style: TextStyle(color: Colors.white),
//                              ),
//                              Container(
//                                padding: const EdgeInsets.all(8),
//                                decoration: BoxDecoration(
//                                  borderRadius: const BorderRadius.all(
//                                      Radius.circular(20)),
//                                  color: MyColors.primaryColorLight,
//                                ),
//                                child: Icon(
//                                  Icons.arrow_forward_ios,
//                                  color: Colors.white,
//                                  size: 16,
//                                ),
//                              )
//                            ],
//                          ),
//                        ),
//                      )
                    ],
                  ),
                )),
              ),
            ),
          ),
        );
      },
    );
  }
}
