
import 'package:flutter/material.dart';
import 'package:client/core/extension/int_extension.dart';

import 'line.dart';

class YZCColumnGroup extends StatelessWidget {
  final double height;
  final List<Widget> items;
  final EdgeInsetsGeometry margin;
  final bool upLine;
  final bool downLine;

  YZCColumnGroup({
    Key key,
    this.height,
    this.items,
    this.margin,
    this.upLine = false,
    this.downLine = false,
  }): super(key: key);

  @override
  Widget build(BuildContext context){
    List<Widget> widgets = List<Widget>();
    if (upLine) widgets.add(YZCLine(width: 1.px, color: Color(0xffe4e4e4), offset: 1.px,));
    widgets.add(Container(height: 1.px,));
    widgets += items;
    widgets.add(Container(height: 1.px,));
    if (downLine) widgets.add(YZCLine(width: 1.px, color: Color(0xffe4e4e4), offset: 1.px,));

    return Container(
      margin: margin ?? EdgeInsets.fromLTRB(15.px, 10.px, 15.px, 0),
      //padding:EdgeInsets.fromLTRB(0, 2.px, 0, 2.px),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(new Radius.circular(10.px)),
      ),
      height:height,
      width:double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widgets,
      ),
    );
  }
}
