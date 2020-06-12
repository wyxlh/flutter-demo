
import 'package:flutter/material.dart';

class YZCColumn extends StatelessWidget {
  final List<Widget> items;
  final MainAxisAlignment align;

  YZCColumn({
    Key key,
    this.items,
    this.align = MainAxisAlignment.start,
  }): super(key: key);

  @override
  Widget build(BuildContext context){
    return Column (
      crossAxisAlignment:CrossAxisAlignment.center,
      mainAxisAlignment: align,
      children: items,
    );
  }
}
