import 'package:flutter/material.dart';
import 'package:client/ui/pages/recharge/recharge_content.dart';
import 'package:client/ui/shared/help.dart';

class WFRechargeScreen extends StatelessWidget {
  static const String routeName = '/recharge';
  @override
  Widget build(BuildContext context) {
    print('充值 build方法');
    return Scaffold(
      appBar: AppBar(
        title: Text('充值',style: TextStyle(color: WFHelp.mainTextColor,fontSize: 18,fontWeight: FontWeight.bold)),
      ),
      body: WFRechargeContent(),
    );
  }
}



