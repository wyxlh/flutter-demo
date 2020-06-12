import 'package:client/ui/account/forget_password_page.dart';
import 'package:client/ui/account/login_page.dart';
import 'package:client/ui/account/register_page.dart';
import 'package:client/ui/home_page.dart';
import 'package:client/ui/main_page.dart';
import 'package:client/widget/webview/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:client/ui/pages/charge/charge.dart';
import 'package:client/ui/pages/main/main.dart';
import 'package:client/ui/pages/message/message.dart';
import 'package:client/ui/pages/recharge/recharge.dart';
import 'package:client/ui/pages/search/search.dart';

class WYRouter {
  static final String initialRoute = WYMainScreen.routeName;

  static final Map<String, WidgetBuilder> routers = {

    WYMainScreen.routeName: (ctx) => WYMainScreen(), // 主页面
    WFRechargeScreen.routeName: (ctx) => WFRechargeScreen(), // 充值页面
    WFChargeScreen.routeName: (ctx) => WFChargeScreen(), // 充电页面
    WFSearchScreen.routeName: (ctx) => WFSearchScreen(), // 搜索片区
    WFMessageScreen.routeName: (ctx) => WFMessageScreen(), // 消息

    YZCWebviewPage.routeName:(context) => YZCWebviewPage(),
    YZCLoginPage.routeName:(context) => YZCLoginPage(),
    YZCForgetPasswordPage.routeName:(context) => YZCForgetPasswordPage(),
    YZCRegisterPage.routeName:(context) => YZCRegisterPage(),
    YZCMainPage.routeName:(context) => YZCMainPage(),
    YZCHomePage.routeName:(context) => YZCHomePage(),
  };

  // 自己扩展
  static final RouteFactory generateRoute = (settings) {
//    if (settings.name == WYFilterScreen.routeName) {
//      return MaterialPageRoute(
//        builder: (ctx) {
//          return WYFilterScreen();
//        },
//        fullscreenDialog: true,
//      );
//    }
    return null;
  };

  static final RouteFactory unknownRoute = (settings) {
    return null;
  };

}