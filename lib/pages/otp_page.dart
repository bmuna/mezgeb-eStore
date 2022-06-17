import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mezgebestore/language/app_localization.dart';
import 'package:mezgebestore/stores/size_config.dart';
import 'package:mezgebestore/widgets/main_button.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:provider/provider.dart';
import 'package:mezgebestore/stores/login_store.dart';
import 'package:mezgebestore/widgets/loader_hud.dart';

class OtpPage extends StatefulWidget {
  static const String id = 'otp_screen';
  String phone;
  OtpPage({Key key, this.phone}) : super(key: key);
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String text = '';

  void _onKeyboardTap(String value) {
    setState(() {
      text = text + value;
    });
  }

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 6.2 * SizeConfig.heightMultiplier,
        width: 11 * SizeConfig.widthMultiplier,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffEF3651), width: 0),
            borderRadius: BorderRadius.all(
                Radius.circular(1.2 * SizeConfig.heightMultiplier))),
        child: Center(
            child: Text(
          text[position],
          style: TextStyle(color: Colors.white),
        )),
      );
    } catch (e) {
      return Container(
        height: 6.2 * SizeConfig.heightMultiplier,
        width: 11 * SizeConfig.widthMultiplier,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0),
            borderRadius: BorderRadius.all(
                Radius.circular(1.2 * SizeConfig.heightMultiplier))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(
      builder: (_, loginStore, __) {
        return Observer(
          builder: (_) => LoaderHUD(
            inAsyncCall: loginStore.isOtpLoading,
            child: Scaffold(
              key: loginStore.otpScaffoldKey,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                bottomOpacity: 0.0,
                elevation: 0.0,
                leading: IconButton(
                  icon: Container(
                    padding: EdgeInsets.all(1.5 * SizeConfig.heightMultiplier),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(3.1 * SizeConfig.heightMultiplier)),
                      color: Color(0xffF47B8D).withAlpha(20),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      iconSize: 2.8 * SizeConfig.heightMultiplier,
                      color: Theme.of(context).indicatorColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            5.5 * SizeConfig.widthMultiplier),
                                    child: Text(
                                        AppLocalizations.of(context)
                                            .translate('verificationPageText'),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 3.1 *
                                                SizeConfig.heightMultiplier,
                                            fontWeight: FontWeight.w500))),
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          78 * SizeConfig.heightMultiplier),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      otpNumberWidget(0),
                                      otpNumberWidget(1),
                                      otpNumberWidget(2),
                                      otpNumberWidget(3),
                                      otpNumberWidget(4),
                                      otpNumberWidget(5),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5.5 * SizeConfig.widthMultiplier,
                                vertical: 1.5 * SizeConfig.heightMultiplier),
                            constraints: BoxConstraints(
                                maxWidth: 78 * SizeConfig.heightMultiplier),

                            child: MainButton(
                              onPressed: () {
                                loginStore.validateOtpAndLogin(
                                    context, text, widget.phone);
                              },
                              text: AppLocalizations.of(context)
                                  .translate('confirmButtonText'),
                            ),
//                            child: RaisedButton(
//                              onPressed: () {
//                                loginStore.validateOtpAndLogin(context, text);
//                              },
//                              color: MyColors.primaryColor,
//                              shape: const RoundedRectangleBorder(
//                                  borderRadius:
//                                      BorderRadius.all(Radius.circular(14))),
//                              child: Container(
//                                padding: const EdgeInsets.symmetric(
//                                    vertical: 8, horizontal: 8),
//                                child: Row(
//                                  mainAxisAlignment:
//                                      MainAxisAlignment.spaceBetween,
//                                  children: <Widget>[
//                                    Text(
//                                      'Confirm',
//                                      style: TextStyle(color: Colors.white),
//                                    ),
//                                    Container(
//                                      padding: const EdgeInsets.all(8),
//                                      decoration: BoxDecoration(
//                                        borderRadius: const BorderRadius.all(
//                                            Radius.circular(20)),
//                                        color: MyColors.primaryColorLight,
//                                      ),
//                                      child: Icon(
//                                        Icons.arrow_forward_ios,
//                                        color: Colors.white,
//                                        size: 16,
//                                      ),
//                                    )
//                                  ],
//                                ),
//                              ),
//                            ),
                          ),
                          NumericKeyboard(
                            onKeyboardTap: _onKeyboardTap,
                            textColor: const Color(0xffEF3651),
                            rightIcon: Icon(
                              Icons.backspace,
                              color: const Color(0xffEF3651),
                            ),
                            rightButtonFn: () {
                              setState(() {
                                text = text.substring(0, text.length - 1);
                              });
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
