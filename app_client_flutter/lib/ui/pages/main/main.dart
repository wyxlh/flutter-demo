import 'package:flutter/material.dart';
import 'package:client/ui/shared/help.dart';
import 'initialize.dart';

class WYMainScreen extends StatefulWidget {
  static const String routeName = '/main';

  @override
  _WYMainScreenState createState() => _WYMainScreenState();
}

class _WYMainScreenState extends State<WYMainScreen> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: pages,
        index: _currentIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        selectedItemColor: WFHelp.mainColor,
        items: items,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
