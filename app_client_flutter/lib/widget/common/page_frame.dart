
import 'package:client/core/io/file/asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/core/extension/int_extension.dart';

class YZCPageFrame extends StatelessWidget {
  final Color headerColor;
  //final Color bgColor;
  final String headerImage;
  final Brightness brightness;
  final PreferredSizeWidget appBar;
  final Widget body;

  YZCPageFrame({
    Key key,
    this.headerColor = const Color(0xFFFFFFFF),
    //this.bgColor = const Color(0xFFF5F5F5),
    this.headerImage,
    this.brightness = Brightness.dark,
    this.appBar,
    this.body,
  }): super(key: key) {
    SystemChrome.setSystemUIOverlayStyle(brightness == Brightness.light ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration decor = ((this.headerImage == null) || (this.headerImage.length < 1)) ?
      BoxDecoration(color: headerColor,) : BoxDecoration(
        image: DecorationImage(
          image: YZCAsset.getImageProvider(headerImage),
          fit: BoxFit.fill,
        ),
    );

    return Container (
      decoration: decor,
      child: Scaffold(
          backgroundColor: Colors.transparent, //把scaffold的背景色改成透明
          appBar: appBar, /* PreferredSize(
            child: appBar,
            preferredSize: Size.fromHeight(60.px),
          ),*/
          body: body,
      ),
    );
  }
}
