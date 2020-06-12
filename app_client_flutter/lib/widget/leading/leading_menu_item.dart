
import 'package:client/core/io/file/asset.dart';
import 'package:flutter/material.dart';
import 'package:client/core/extension/int_extension.dart';
import '../../configure.dart';

import '../../ui/common/themeTextStyles.dart';

class YZCLeadingMenuItem extends StatelessWidget {
  final PopupMenuItemSelected<String> onSelected;
  final int mode; //0: 首页中，1：我的中
  final List<Map<String, dynamic>> items;

  YZCLeadingMenuItem({
    Key key,
    this.mode = 0,
    this.onSelected,
    this.items,
  }): super(key: key);

  @override
  Widget build(BuildContext context){
    Image image = YZCAsset.getImage((mode == 0) ? 'assets/images/homePage/index/onlineService.png' : 'assets/images/my/index/t_kefu.png',
      width: 17.px, height: 18.px, fit:BoxFit.fill,);

    return PopupMenuButton(
      color: Color(0xEF676665),
      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.px)),
      child:Container(
        //margin:EdgeInsets.fromLTRB(0,12.px,0,0),
        padding: EdgeInsets.fromLTRB(15.px,0,15.px,0),
        child:Column(
          children:<Widget>[
            Container(height:2.px),
            image,
            Container(height:3.px),
            Text('客服', style: TextStyle(color: Color((mode == 0) ? 0xFF333333 : 0xFFF5F5F5), fontSize: 9.px)),
          ]
        )
      ),
      offset:Offset(0.0,56.px),
      elevation: 8.0,
      padding: EdgeInsets.all(0),
      itemBuilder: (BuildContext context) {
        return items.map<PopupMenuItem<String>>((Map<String, dynamic> item) {
          return PopupMenuItem<String>(
            height: 30.px,
            /*child: ListTile(
              leading: YZCAsset.getImage(item['image'], width: 17.px, height: 17.px, fit:BoxFit.fill,),
              title: Text(item['title'], style: ThemeTextStyle.white_4,),
            ),*/
            child: Row(
              children: <Widget>[
                if (item.containsKey('image')) YZCAsset.getImage(item['image'], width: 17.px, height: 17.px, fit:BoxFit.fill,),
                SizedBox(width: 10.px,),
                Text(item['title'], style: ThemeTextStyle.white_4,),
              ],
            ),
            value: item['action'],
          );
        }).toList();
      },
      onSelected: (String action) {
        this.onSelected(action);
      },
    );
  }
}
