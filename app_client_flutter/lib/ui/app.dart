
import 'package:client/core/router/router.dart';
import 'package:client/ui/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class YZCApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:  WYAppTheme.norTheme,
      routes: WYRouter.routers,
      //home: YZCHomePage(),
      initialRoute: YZCHomePage.routeName,
    );
  }
}
