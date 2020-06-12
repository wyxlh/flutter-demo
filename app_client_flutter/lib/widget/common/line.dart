
import 'package:flutter/material.dart';

class YZCLine extends StatelessWidget {
  final double width;
  final double offset;
  final Color color;

  YZCLine({
    Key key,
    this.width = 1,
    this.offset = 15,
    this.color = Colors.grey,
  }): super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      height: width,
      margin:EdgeInsets.fromLTRB(this.offset, 0, this.offset, 0),
      decoration: new BoxDecoration(
        color: color,
        borderRadius: new BorderRadius.all(new Radius.circular(width / 2)),
      ),
    );
  }
}
