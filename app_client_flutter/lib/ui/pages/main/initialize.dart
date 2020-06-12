import 'package:flutter/material.dart';
import 'package:client/ui/pages/find/find.dart';
import 'package:client/ui/pages/home/home.dart';
import 'package:client/ui/pages/user/user.dart';

final List<Widget> pages = [
  WFHomeScreen(),
  WFFindScreen(),
  WFUserScreen()
];

final List<BottomNavigationBarItem> items = [
  BottomNavigationBarItem(
    title: Text('首页'),
    icon: Icon(Icons.home)
  ),
  BottomNavigationBarItem(
      title: Text('发现'),
      icon: Icon(Icons.star)
  ),
  BottomNavigationBarItem(
      title: Text('我的'),
      icon: Icon(Icons.verified_user)
  ),
];

