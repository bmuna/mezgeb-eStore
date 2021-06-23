import 'package:flutter/material.dart';
import 'package:mezgebestore/stores/size_config.dart';

class MainButton extends StatelessWidget {
  MainButton({this.text, @required this.onPressed});

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 1 * SizeConfig.heightMultiplier,
      ),
      child: Container(
        height: 6 * SizeConfig.heightMultiplier,
        child: Material(
          elevation: 0.7 * SizeConfig.heightMultiplier,
          borderRadius: BorderRadius.circular(
            6.4 * SizeConfig.heightMultiplier,
          ),
          color: const Color(0xffEF3651),
          child: MaterialButton(
            onPressed: onPressed,
            minWidth: double.infinity,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 2.3 * SizeConfig.heightMultiplier,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
