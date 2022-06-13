import 'package:flutter/material.dart';
import 'package:mezgebestore/pages/home.dart';
import 'package:mezgebestore/stores/login_store.dart';
import 'package:provider/provider.dart';

class LogOut extends StatefulWidget {
  static const String id = 'logout_screen';
  const LogOut({Key key}) : super(key: key);

  @override
  _LogOutState createState() => _LogOutState();
}

class _LogOutState extends State<LogOut> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStore>(builder: (_, loginStore, __) {
      return Scaffold(
        body: Container(
          child: MainButton(
            text: 'Log Out',
            onPressed: () {
              loginStore.signOut(context);
            },
          ),
        ),
      );
    });
  }
}
