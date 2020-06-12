import 'package:client/ui/shared/help.dart';
import 'package:flutter/material.dart';
import 'package:client/core/extension/int_extension.dart';

class ThemeTextStyle{
  // ThemeTextStyle._();
  static TextStyle styleWhiteHeader; //标题栏亮色
  static TextStyle styleBlackHeader; //标题栏黑色
  static TextStyle styleWhiteConfirmButton; //按钮亮色字体
  static TextStyle styleBlackConfirmButton; //按钮黑色字体
  static TextStyle styleFormTitle; //输入框前面标题字体
  static TextStyle styleFormHint; //输入框提示字体
  static TextStyle styleFormLittleHint; //输入框提示字体
  static TextStyle styleFormText; //输入框字体





  static TextStyle style_FED0B8;
  static TextStyle white_1;
  static TextStyle white_2;
  static TextStyle white_3;
  static TextStyle white_4;
  static TextStyle white_5;
  static TextStyle white_6;
  static TextStyle black_0;
  static TextStyle black_1;
  static TextStyle black_2;
  static TextStyle black_3;
  static TextStyle black_4;
  static TextStyle black_5;
  static TextStyle black_6;
  static TextStyle style_3AC48B;
  static TextStyle style_FFA213;
  static TextStyle style_333333;
  static TextStyle style_FF6D22;
  static TextStyle style_FF6D22_12;
  static TextStyle style_666666_12;

  static void init() {
    styleWhiteHeader = TextStyle(color: Colors.white, fontSize: 20.px, fontWeight: FontWeight.w700);
    styleBlackHeader = TextStyle(color: WFHelp.mainTextColor, fontSize: 20.px, fontWeight: FontWeight.w700);
    styleWhiteConfirmButton = TextStyle(color: Colors.white, fontSize: 16.px, fontWeight: FontWeight.w400);
    styleBlackConfirmButton = TextStyle(color: WFHelp.mainTextColor, fontSize: 16.px, fontWeight: FontWeight.w400);

    styleFormTitle = TextStyle(color: WFHelp.mainTextColor, fontSize: 14.px, fontWeight: FontWeight.w400);
    styleFormHint = TextStyle(color: WFHelp.mainHintTextColor, fontSize: 14.px, fontWeight: FontWeight.w400);
    styleFormLittleHint = TextStyle(color: WFHelp.mainHintTextColor, fontSize: 12.px, fontWeight: FontWeight.w400);
    styleFormText = TextStyle(color: WFHelp.mainTextColor, fontSize: 14.px, fontWeight: FontWeight.w400);




    style_FED0B8 = TextStyle(color:const Color(0xFFFED0B8),fontSize:12.px,height:1,fontFamily:'PingFang-SC-Medium');
    white_1 = TextStyle(color:const Color(0xFFF5F5F5),fontSize:30.px,height:1,fontFamily:'PingFang-SC-Bold',fontWeight:FontWeight.w700);
    white_2 = TextStyle(color:const Color(0xFFF5F5F5),fontSize:18.px,height:1,fontFamily:'PingFang-SC-Bold',fontWeight:FontWeight.w700);
    white_3 = TextStyle(color:const Color(0xFFF5F5F5),fontSize:16.px,height:1,fontFamily:'PingFang-SC-Bold',fontWeight:FontWeight.w700);
    white_4 = TextStyle(color:const Color(0xFFF5F5F5),fontSize:14.px,height:1,fontFamily:'PingFang-SC-Bold',fontWeight:FontWeight.w700);
    white_5 = TextStyle(color:const Color(0xFFF5F5F5),fontSize:9.px,height:1,fontFamily:'PingFang-SC-Bold',fontWeight:FontWeight.w700);
    white_6 = TextStyle(color:const Color(0xFFF5F5F5),fontSize:9,height:1,fontFamily:'PingFang-SC-Bold',fontWeight:FontWeight.w700);
    black_0 = TextStyle(color:const Color(0xff000000),fontSize:14.px,height:1);
    black_1 = TextStyle(color:const Color(0xFF333333),fontSize:16.px,height:1,fontFamily:'PingFang-SC-Bold',fontWeight:FontWeight.w700);
    black_2 = TextStyle(color:const Color(0xFF333333),fontSize:12.px,height:1,fontFamily:'PingFang-SC-Bold',fontWeight:FontWeight.w700);
    black_3 = TextStyle(color:const Color(0xFF999999),fontSize:12.px,height:1,fontFamily:'PingFang-SC-Medium');
    black_4 = TextStyle(color:const Color(0xFF333333),fontSize:14.px,height:1,fontFamily:'PingFang-SC-Bold',fontWeight:FontWeight.w700);
    black_5 = TextStyle(color:const Color(0xFF333333),fontSize:9.px,height:1,fontFamily:'PingFang-SC-Bold',fontWeight:FontWeight.w700);
    black_6 = TextStyle(color:const Color(0xFF333333),fontSize:9,height:1,fontFamily:'PingFang-SC-Bold',fontWeight:FontWeight.w700);
    style_3AC48B = TextStyle(color:const Color(0xFF3AC48B),fontSize:16.px,height:1,fontFamily:'PingFang-SC-Bold',fontWeight:FontWeight.w700);
    style_FFA213 = TextStyle(color:const Color(0xFFFFA213),fontSize:12.px,height:1.2,fontFamily:'PingFang-SC-Medium');
    style_333333 = TextStyle(color:const Color(0xFF333333),fontSize:16.px,height:1,fontFamily:'PingFang-SC-Bold',fontWeight:FontWeight.w700);
    style_FF6D22 = TextStyle(color:const Color(0xFFFF6D22),fontSize:16.px,height:1,fontFamily:'PingFang-SC-Bold',fontWeight:FontWeight.w700);
    style_FF6D22_12 = TextStyle(color:const Color(0xFFFF6D22),fontSize:12.px,height:1,fontFamily:'PingFang-SC-Bold',fontWeight:FontWeight.w700);
    style_666666_12 = TextStyle(color:const Color(0xff666666),fontSize:12.px,height:1,fontFamily:'PingFang-SC-Bold',fontWeight:FontWeight.w700);
  }
}