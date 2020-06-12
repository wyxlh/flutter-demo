
import 'package:flutter/material.dart';
import 'package:client/core/extension/int_extension.dart';

/*
class YZCAppBar extends AppBar {
  YZCAppBar({
    Key key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.shape,
    this.backgroundColor,
    this.brightness,
    this.iconTheme,
    this.actionsIconTheme,
    this.textTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
  }): super(key: key);

  final Widget leading;
  final bool automaticallyImplyLeading;
  final Widget title;
  final List<Widget> actions;
  final Widget flexibleSpace;
  final PreferredSizeWidget bottom;
  final double elevation;
  final ShapeBorder shape;
  final Color backgroundColor;
  final Brightness brightness;
  final IconThemeData iconTheme;
  final IconThemeData actionsIconTheme;
  final TextTheme textTheme;
  final bool primary;
  final bool centerTitle;
  final bool excludeHeaderSemantics;
  final double titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;

  @override
  Size get preferredSize => Size.fromHeight(50.px);
  //Size get preferredSize => Size.fromHeight(kToolbarHeight);

//  @override
//  Widget build(BuildContext context) {
//    return super.build(context);
//  }
}
*/

class YZCAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget leftItem;
  final Widget mediumItem;
  final Widget rightItem;
  final Color color;

  YZCAppBar({
    Key key,
    this.leftItem,
    this.mediumItem,
    this.rightItem,
    this.color = Colors.black,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List<Widget>();
    widgets.add(leftItem ?? IconButton(icon: Icon(Icons.arrow_back_ios), iconSize: 18.px, color: color, onPressed: () { Navigator.pop(context); },));
    if (mediumItem != null) widgets.add(mediumItem);
    widgets.add(rightItem ?? SizedBox(width: 38.px,));
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(5.px,3.px,5.px,3.px),
      child: SafeArea(
        top: true,
        child: Row (
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widgets,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(46.px);
}
