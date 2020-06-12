
import 'package:client/core/io/file/asset.dart';
import 'package:flutter/material.dart';
import 'package:client/core/extension/int_extension.dart';
import '../../configure.dart';

import '../../ui/common/themeTextStyles.dart';

class YZCLeadingClickItem extends StatelessWidget {
  final ButtonCallback onPressed;
  final String image;
  final String title;
  final TextStyle style;
  final dynamic arg;

  YZCLeadingClickItem({
    Key key,
    this.onPressed,
    this.image,
    this.title,
    this.style,
    this.arg,
  }): super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      width: 40.px,
      padding: EdgeInsets.fromLTRB(5.px,0,15.px,0),
      child: GestureDetector(
        child: Container(
          child:Column(
            children:<Widget>[
              Container(height:2),
              YZCAsset.getImage(image, width: 17.px, height: 18.px, fit:BoxFit.fill,),
              Container(height:3),
              Text(title, style:TextStyle(color: style.color, fontSize: 9.px))
            ]
          )
        ),
        onTap: () { onPressed(arg); },
      ),
    );
  }
}
