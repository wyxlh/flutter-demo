
import 'package:flutter/material.dart';

class YZCRow extends StatelessWidget {
  final List<Widget> items;
  final MainAxisAlignment align;

  YZCRow({
    Key key,
    this.items,
    this.align = MainAxisAlignment.start,
  }): super(key: key);

  @override
  Widget build(BuildContext context){
    return Row (
      crossAxisAlignment:CrossAxisAlignment.center,
      mainAxisAlignment: align,
      children: items,
    );
  }
}
