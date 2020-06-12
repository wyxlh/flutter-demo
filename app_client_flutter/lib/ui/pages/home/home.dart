import 'package:flutter/material.dart';
import 'package:client/ui/pages/home/home_content.dart';
import 'package:client/ui/pages/message/message.dart';
import 'package:client/ui/shared/help.dart';

class WFHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text( '充电', style: TextStyle(color: WFHelp.mainTextColor,fontSize: 18,fontWeight: FontWeight.bold)),
      brightness: Brightness.light,
        leading: buildLeading(),
        actions: buildActions(context),
      ),
      body: WFHomeContent(),
    );
  }

  // 左边按钮
  Widget buildLeading() {
    return  IconButton(
        icon: Image.asset('assets/images/user/new_service@2x.png', width: 20, height: 40, gaplessPlayback: true),
        onPressed: () {
          print('11');
        }
    );
  }

  // 右边按钮
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Image.asset('assets/images/user/new_msg@2x.png',  width: 20, height: 40, gaplessPlayback: true),
          onPressed: () {
            Navigator.of(context).pushNamed(WFMessageScreen.routeName);
          })
    ];
  }
}
