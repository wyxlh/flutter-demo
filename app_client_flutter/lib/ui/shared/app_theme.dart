import 'package:flutter/material.dart';

class WYAppTheme {
  // 1.共有属性
  static const double smallFontSize = 12;
  static const double bodyFontSize = 14;
  static const double normalFontSize = 18;
  static const double largeFontSize = 24;


  // 2.普通模式
  static final Color norTextColors = Colors.red;

  static final ThemeData norTheme = ThemeData(
    canvasColor: Color(0xFFF5F5F5), // 设置页面的颜色
    primaryColor:Colors.white, //主题主色，决定导航栏颜色
    accentColor: Colors.orange,
    textTheme: TextTheme(
      body1: TextStyle(fontSize: bodyFontSize,color: Color(0xFF333333)),
      display1: TextStyle(fontSize: smallFontSize),
      display2: TextStyle(fontSize: normalFontSize, color: Color(0xFF333333)),
      display3: TextStyle(fontSize: largeFontSize, color: Colors.black87),
    )
  );


  // 3.暗黑模式
  static final Color darkTextColors = Colors.green;

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    accentColor: Color(0xFFF5F5F5),
    textTheme: TextTheme(
        body1: TextStyle(fontSize: normalFontSize, color: darkTextColors)
    )
  );
}