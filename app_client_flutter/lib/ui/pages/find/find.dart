import 'package:flutter/material.dart';
import 'package:client/ui/shared/help.dart';
import 'find_content.dart';

class WFFindScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('find build方法');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        title: Text('发现',style: TextStyle(color: WFHelp.mainTextColor,fontSize: 18,fontWeight: FontWeight.bold)),
      ),
      body: WFFindContent(),
    );
  }
}
