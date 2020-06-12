
import 'package:flutter/material.dart';
import '../../configure.dart';

class YZCButtonRowItem extends StatelessWidget {
  final ButtonCallback onPressed;
  final List<Widget> leftItems;
  final List<Widget> mediumItems;
  final List<Widget> rightItems;
  final dynamic arg;

  YZCButtonRowItem({
    Key key,
    this.onPressed,
    this.leftItems,
    this.mediumItems,
    this.rightItems,
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
        child: Row(
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row (
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: leftItems,
            ),
            if (mediumItems != null) Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: mediumItems,
            ),
            if (rightItems != null) Row (
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: rightItems,
            )
          ],
        ),
      )
    );
  }
}
