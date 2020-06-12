import 'package:flutter/material.dart';
import 'package:client/ui/shared/help.dart';
import 'package:client/ui/shared/size_fit.dart';
import 'charge_content.dart';
import 'dart:math';

class WFChargeScreen extends StatelessWidget {
  static const String routeName = '/charge';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('立即充电',style: TextStyle(color: WFHelp.mainTextColor,fontSize: 18,fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: WFChargeContent(),
    );
  }
}
