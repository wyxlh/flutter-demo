
import 'package:client/core/platform/platform.dart';
import 'package:client/core/extension/int_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:client/core/extension/int_extension.dart';
import '../../configure.dart';
import '../../widget/leading/leading_menu_item.dart';

class YZCLeadingCustomerService extends StatelessWidget {
  final String cell = '4003231232';
  final int mode; //0: 首页中，1：我的中

  YZCLeadingCustomerService({Key key, this.mode = 0}): super(key: key);

  @override
  Widget build(BuildContext context){
    return YZCLeadingMenuItem(mode: mode,
      items: [{'image': 'assets/images/homePage/index/contact.png', 'title': '在线客服', 'action': 'online'},
        {'image': 'assets/images/homePage/index/phone.png', 'title': cell, 'action': 'phone'}],
      onSelected: (String action) {
        switch (action) {
          case "online":
            print("在线客服");
            break;
          case "phone":
            print(cell);
            showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoActionSheet(
                    message: Text(cell, style: TextStyle(fontSize: 26.px),),
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                        child: Text('拨打电话', style: TextStyle(fontSize: 18.px),),
                        onPressed: () { YZCPlatform.callPhone(cell); },
                        isDefaultAction: true,
                      ),
                    ],
                  );
                }
            );
            break;
        }
      },
    );
  }
}
