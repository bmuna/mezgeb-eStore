import 'package:flutter/material.dart';
import 'package:mezgebestore/stores/size_config.dart';

class RoundIconButton extends StatelessWidget {
  RoundIconButton({@required this.icon, @required this.onPressed});
  final IconData icon;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(
        icon,
        size: 1.8 * SizeConfig.heightMultiplier,
        color: Colors.grey,
      ),
      onPressed: onPressed,
      elevation: 3.0,
      constraints: BoxConstraints.tightFor(
        width: 8.3 * SizeConfig.widthMultiplier,
        height: 4.6 * SizeConfig.heightMultiplier,
      ),
      shape: CircleBorder(),
      fillColor: Theme.of(context).buttonColor,
    );
  }
}
