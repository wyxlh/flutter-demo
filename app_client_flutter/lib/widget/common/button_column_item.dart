
import 'package:flutter/material.dart';
import '../../configure.dart';

class YZCButtonColumnItem extends StatelessWidget {
  final ButtonCallback onPressed;
  final List<Widget> topItems;
  final List<Widget> mediumItems;
  final List<Widget> bottomItems;
  final dynamic arg;

  YZCButtonColumnItem({
    Key key,
    this.onPressed,
    this.topItems,
    this.mediumItems,
    this.bottomItems,
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
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row (
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: topItems,
            ),
            if (mediumItems != null) Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: mediumItems,
            ),
            if (bottomItems != null) Row (
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: bottomItems,
            )
          ],
        ),
      )
    );
  }
}
