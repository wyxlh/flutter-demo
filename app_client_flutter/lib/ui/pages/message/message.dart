import 'package:flutter/material.dart';
import 'package:client/ui/shared/help.dart';
import 'message_content.dart';


class WFMessageScreen extends StatelessWidget {
  static const String routeName = '/message';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text( '消息', style: TextStyle(color: WFHelp.mainTextColor,fontSize: 18,fontWeight: FontWeight.bold)),
      ),
      body: WFMessageContent(),
    );
  }
}
