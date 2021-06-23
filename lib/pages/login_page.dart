import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mezgebestore/constant.dart';
import 'package:mezgebestore/language/AppLanguage.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/stores/size_config.dart';
import 'package:mezgebestore/widgets/main_button.dart';
import 'file:///C:/Users/Munation/Documents/flutter_project/mezgeb_estore/lib/widgets/register_button.dart';
import 'package:provider/provider.dart';
import 'package:mezgebestore/stores/login_store.dart';
import 'package:mezgebestore/widgets/loader_hud.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'loginPage_screen';

  const LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
//  String _selectedCountryCode;
//  List<String> _countryCodes = ['+251'];
  TextEditingController phoneController = TextEditingController();
  String phoneNumber = '';
  showSnackBar() {}

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    var countryDropDown = Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      width: 70,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            width: 0.9,
            color: Colors.grey,
          ),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '+251',
              style: TextStyle(
                fontSize: 2.3 * SizeConfig.heightMultiplier,
              ),
            ),
          ],
        ),
      ),
    );
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoaderHUD(
            inAsyncCall: loginStore.isLoginLoading,
            child: Scaffold(
//              backgroundColor: Color(0xFF1E1F28),
              key: loginStore.loginScaffoldKey,
              body: SafeArea(
                child: SingleChildScrollView(
                    child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 5.5 * SizeConfig.widthMultiplier,
                          vertical: 3.1 * SizeConfig.heightMultiplier,
                        ),
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: 31 * SizeConfig.heightMultiplier,
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: 2.2 * SizeConfig.widthMultiplier),
                          child: Image.asset('images/'
                              'i.png'),
                        ),
                      ),
                      SizedBox(
                        height: 6.2 * SizeConfig.heightMultiplier,
                      ),
                      Column(children: <Widget>[
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: 78 * SizeConfig.heightMultiplier),
                          margin: EdgeInsets.symmetric(
                            horizontal: 3.1 * SizeConfig.widthMultiplier,
                          ),
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: appLanguage.appLocale == Locale('am')
                                  ? TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          text: 'በዚህ የሞባይል ቁጥር ላይ ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .merge(TextStyle(
                                                  fontSize: 2.3 *
                                                      SizeConfig
                                                          .heightMultiplier))),
                                      TextSpan(
                                        text: 'የአንድ ጊዜ ኮድ ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .merge(
                                              TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 2.3 *
                                                      SizeConfig
                                                          .heightMultiplier),
                                            ),
                                      ),
                                      TextSpan(
                                          text: 'እንልክልዎታለን',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .merge(TextStyle(
                                                  fontSize: 2.3 *
                                                      SizeConfig
                                                          .heightMultiplier))),
                                    ])
                                  : TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          text: 'We will send you ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .merge(TextStyle(
                                                  fontSize: 2.3 *
                                                      SizeConfig
                                                          .heightMultiplier))),
                                      TextSpan(
                                        text: 'One Time Code ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .merge(
                                              TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 2.3 *
                                                      SizeConfig
                                                          .heightMultiplier),
                                            ),
                                      ),
                                      TextSpan(
                                          text: 'on this mobile number',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .merge(TextStyle(
                                                  fontSize: 2.3 *
                                                      SizeConfig
                                                          .heightMultiplier))),
                                    ])),
                        ),
                        SizedBox(
                          height: 4.6 * SizeConfig.heightMultiplier,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.1 * SizeConfig.heightMultiplier,
                          ),
                          child: Container(
                            height: 7.8 * SizeConfig.heightMultiplier,
                            decoration: BoxDecoration(
                              color: Color(
                                0xff2A2C36,
                              ),
                            ),
                            child: appLanguage.appLocale == Locale('en')
                                ? TextFormField(
                                    keyboardType: TextInputType.phone,
                                    validator: (val) => val.isEmpty
                                        ? 'Please enter a phone number'
                                        : null,
                                    onChanged: (value) {
                                      setState(() => phoneNumber = value);
                                      print(phoneNumber);
                                    },
                                    controller: phoneController,
                                    autofocus: false,
                                    style: TextStyle(
                                      fontSize:
                                          2.3 * SizeConfig.heightMultiplier,
                                      color: Color(0xffF7F7F7),
                                    ),
                                    decoration: KTextFieldDecoration.copyWith(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(20, 0, 0, 0),
                                      prefixStyle: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize:
                                            2.3 * SizeConfig.textMultiplier,
                                        color: Colors.grey,
                                      ),
                                      prefixIcon: countryDropDown,
                                      hintText: 'eg: 0910000000',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize:
                                            2.3 * SizeConfig.textMultiplier,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                : TextFormField(
                                    keyboardType: TextInputType.phone,
                                    validator: (val) => val.isEmpty
                                        ? 'እባክዎ የስልክ ቁጥር ያስገቡ'
                                        : null,
                                    onChanged: (value) {
                                      setState(() => phoneNumber = value);
                                    },
                                    controller: phoneController,
                                    autofocus: false,
                                    style: TextStyle(
                                      fontSize: 2.8 * SizeConfig.textMultiplier,
                                      color: Color(0xffF7F7F7),
                                    ),
                                    decoration: KTextFieldDecoration.copyWith(
                                      contentPadding: EdgeInsets.zero,
                                      prefixStyle: TextStyle(
                                          fontWeight: FontWeight.w100,
                                          fontSize:
                                              2.3 * SizeConfig.textMultiplier,
                                          color: Colors.grey),
                                      prefixIcon: countryDropDown,
                                      hintText: 'ለምሳሌ: +25109000000',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize:
                                            2.3 * SizeConfig.textMultiplier,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ]),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 3.1 * SizeConfig.heightMultiplier,
                            vertical: 3.1 * SizeConfig.heightMultiplier),
//                        constraints: BoxConstraints(
//                            maxWidth: 78 * SizeConfig.widthMultiplier),
                        child: MainButton(
                          text: AppLocalizations.of(context)
                              .translate('nextButtonInSignPage'),
                          onPressed: () {
                            if (phoneController.text.isNotEmpty) {
                              loginStore.getCodeWithPhoneNumber(context,
                                  "+251" + phoneController.text.toString());
                            } else {
                              loginStore.loginScaffoldKey.currentState
                                  .showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    AppLocalizations.of(context)
                                        .translate('phoneNotEntered'),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            2.3 * SizeConfig.textMultiplier),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
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
