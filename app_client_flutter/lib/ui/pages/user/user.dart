import 'package:client/core/service/basic/h5_urls.dart';
import 'package:client/ui/pages/message/message.dart';
import 'package:client/widget/webview/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:client/ui/shared/help.dart';
import '../../../configure.dart';
import 'user_content.dart';

class WFUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('user build方法');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text( '我的', style: TextStyle(color: WFHelp.mainTextColor,fontSize: 18,fontWeight: FontWeight.bold)),
        centerTitle: true,
        brightness: Brightness.light,
        leading: buildLeading(context),
        actions: buildActions(context),
      ),
      body: WFUserContent(),
    );
  }

  // 左边按钮
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Image.asset('assets/images/user/new_service@2x.png',
          width: 20, height: 40, gaplessPlayback: true),
        onPressed: () {
          print('客服');
        }
    );
  }

  // 右边按钮
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Image.asset('assets/images/user/new_msg@2x.png',  width: 20, height: 40, gaplessPlayback: true),
          onPressed: () {
            print('消息');
            Navigator.of(context).pushNamed(WFMessageScreen.routeName);
          }),
      IconButton(
          icon: Image.asset('assets/images/user/new_setting@2x.png',  width: 20, height: 40, gaplessPlayback: true),
          onPressed: () {
            print('设置');
            Navigator.pushNamed(context, YZCWebviewPage.routeName, arguments: {'url': YZCConfigure.mkH5URL(H5Urls.setting),});
          })
    ];
  }
}
