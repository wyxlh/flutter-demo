
import 'package:flutter/material.dart';

class YZCColumnImageText extends StatelessWidget {
  final Image image;
  final Text text;
  final double gap;

  YZCColumnImageText({
    Key key,
    this.text,
    this.image,
    this.gap,
  }): super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
        children:<Widget>[
          image,
          Container(width: gap,),
          text,
        ]
    );
  }
}
