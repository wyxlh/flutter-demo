
import 'package:flutter/material.dart';
import 'package:client/core/extension/int_extension.dart';
import '../../configure.dart';

import '../../ui/common/themeTextStyles.dart';

class YZCButtonUpDown extends StatelessWidget {
  final CrossAxisAlignment crossAxisAlignment;
  final ButtonCallback onPressed;
  final double gap;
  final List<Widget> upItems;
  final List<Widget> downItems;
  final dynamic arg;

  YZCButtonUpDown({
    Key key,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.onPressed,
    this.gap = 10,
    this.upItems,
    this.downItems,
    this.arg,
  }): super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      child: FlatButton(
        color: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onPressed: () { onPressed(arg); },
        child: Container(
          margin:EdgeInsets.fromLTRB(0,15.px,0,0),
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children:<Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: upItems,
              ),
              Container(height: gap,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: downItems,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
