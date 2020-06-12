
import 'package:client/core/event/event.dart';
import 'package:client/core/service/data.dart';
import 'package:client/ui/pages/main/main.dart';
import 'package:flutter/material.dart';
import 'package:client/core/extension/int_extension.dart';
import '../configure.dart';

import 'account/login_page.dart';
import 'guide_page.dart';

class YZCHomePage extends StatefulWidget {
  static const String routeName = '/';

  @override
  _YZCHomePageState createState() => _YZCHomePageState();
}

class _YZCHomePageState extends State<YZCHomePage> {
  String _curState = 'guide';

  void _guideOver(arg) {
    YZCData.guide.isGuided = true;
    YZCData.guide.save();

    setState(() {
      _curState = YZCData.user.isLogin ? 'main' : 'login';
    });
  }

  void _enterLoginPage(arg) {
    setState(() {
      _curState = 'login';
    });
  }

  void _enterMainPage(arg) {
    setState(() {
      _curState = 'main';
    });
  }

  @override
  void initState() {
    super.initState();

    _curState = !YZCData.guide.isGuided ? 'guide' : (YZCData.user.isLogin ? 'main' : 'login');
    YZCEvent.on('guideOver', _guideOver);
    YZCEvent.on('loginPage', _enterLoginPage);
    YZCEvent.on('mainPage', _enterMainPage);
  }

  @override
  void dispose() {
    YZCEvent.off('guideOver', _guideOver);
    YZCEvent.off('loginPage', _enterLoginPage);
    YZCEvent.off('mainPage', _enterMainPage);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    YZCConfigure.init(context);
print('begin _curState:$_curState');
    if (_curState == 'guide') {
      return YZCGuidePage();
    } else if (_curState == 'login') {
      return YZCLoginPage();
    }
    return WYMainScreen();// YZCMainPage();
  }
}
