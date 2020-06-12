
import 'package:flutter/material.dart';
import '../../configure.dart';
import 'package:client/core/extension/int_extension.dart';

class YZCButtonLeftRightRound extends StatelessWidget {
  final ButtonCallback onPressed;
  final Text title;
  final Color bgColor;
  final dynamic arg;

  YZCButtonLeftRightRound({
    Key key,
    this.onPressed,
    this.title,
    this.bgColor = Colors.white,
    this.arg,
  }): super(key: key);

  @override
  Widget build(BuildContext context){
    return Expanded(
      child:Container(
        height: 35.px,
        margin:EdgeInsets.fromLTRB(5.px,0,5.px,5.px),
        child: FlatButton(
          color: bgColor,
          child: title,
          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.px)),
          onPressed: () { onPressed(arg); },
        )
      )
    );
  }
}
