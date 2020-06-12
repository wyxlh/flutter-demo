
import 'package:flutter/material.dart';

class YZCRowImageText extends StatelessWidget {
  final Image image;
  final Text text;
  final double gap;

  YZCRowImageText({
    Key key,
    this.text,
    this.image,
    this.gap,
  }): super(key: key);

  @override
  Widget build(BuildContext context){
    return Row(
        children:<Widget>[
          image,
          Container(width: gap,),
          text,
        ]
    );
  }
}
