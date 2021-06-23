import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  RegisterButton({this.text, @required this.onPressed});

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: const Color(0xffEF3651),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: double.infinity,
          height: 42.0,
//          child: Text(
//            text,
//            style: TextStyle(
//              color: Colors.white,
//              fontWeight: FontWeight.bold,
//              fontSize: 15,
//            ),
//          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: Color(0xffF47B8D),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
