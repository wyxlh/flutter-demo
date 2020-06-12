
import 'package:flutter/material.dart';
import 'package:client/core/extension/int_extension.dart';

import '../../ui/common/themeTextStyles.dart';
import '../../widget/common/row.dart';

class YZCAppBar extends StatelessWidget {
  final List<Widget> leftItems;
  final List<Widget> rightItems;

  YZCAppBar({
    Key key,
    this.leftItems,
    this.rightItems,
  }): super(key: key);

  @override
  Widget build(BuildContext context){
    return YZCRow (
      align: MainAxisAlignment.spaceBetween,
      items: [
        YZCRow (items: leftItems,),
        YZCRow (items: rightItems,),
      ],
    );
  }
}
