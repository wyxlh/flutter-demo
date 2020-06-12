import 'dart:async';
import 'package:client/core/service/data.dart';
import 'package:client/ui/shared/help.dart';
import 'package:client/widget/common/editbox.dart';

import '../../widget/common/button_leftright_round.dart';
import 'package:client/core/extension/int_extension.dart';
import '../../ui/common/themeTextStyles.dart';
import '../../widget/common/app_bar.dart';
import '../../widget/common/page_frame.dart';
import 'package:flutter/material.dart';

import '../dialog/message_box.dart';
import 'forget_password_page.dart';

class YZCRegisterPage extends StatefulWidget {
  static const String routeName = '/registerPage';

  @override
  _YZCRegisterPageState createState() => _YZCRegisterPageState();
}

class _YZCRegisterPageState extends State<YZCRegisterPage> {
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  bool _showPassword = false; //密码是否显示明文
  GlobalKey _formKey = GlobalKey<FormState>();
  bool _mobileAutoFocus = true;

  Timer _timer;
  int _ticks = -1;

  bool _checkMobile() {
    String mobile = _mobileController.text;

    if (mobile.length < 1) {
      TipDialog(context, '手机号不能为空.');
      return false;
    }

    return true;
  }

  bool _checkPassword() {
    String password = _pwdController.text;

    if (password.length < 1) {
      TipDialog(context, '密码不能为空.');
      return false;
    }

    return true;
  }

  bool _checkCode() {
    String code = _codeController.text;

    if (code.length < 1) {
      TipDialog(context, '验证码不能为空.');
      return false;
    }

    return true;
  }

  void _gatherCode() {
    if (!_checkMobile()) return;

    if (_ticks < 0) YZCData.user.gatherVerifyCode(_mobileController.text, 1, success: (Map<String, dynamic> result) {
      setState(() {
        _ticks = 60;
      });

      _timer?.cancel();
      _timer = null;
      _timer = Timer.periodic(Duration(seconds: 1), (t) {
        setState(() {
          _ticks = 60 - t.tick;
          if (_ticks < 0) {
            _timer?.cancel();
            _timer = null;
          }
        });
      });
      TipDialog(context, '验证码已经发送到您的手机，注意查收。');
    }, failed: (String msg) {
      TipDialog(context, msg);
    });
  }

  void _register(arg) async {
    if (!_checkMobile() || !_checkPassword() || !_checkCode()) return;
    YZCData.user.register(_mobileController.text, _pwdController.text, _codeController.text, success: (Map<String, dynamic> result) {
      Navigator.of(context).pop();
    }, failed: (String msg) {
      TipDialog(context, msg);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _mobileController.dispose();
    _pwdController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YZCPageFrame(
      //appBar: YZCAppBar(mediumItem: Text('注册', style: ThemeTextStyle.styleBlackHeader,)),
      appBar: YZCAppBar(),
      body: Scrollbar(
        child:SingleChildScrollView(
          child:Container(
            padding: EdgeInsets.fromLTRB(15.px, 80.px, 15.px, 15.px),
            child: Form(
              key: _formKey,
              //autovalidate: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('注册', style: ThemeTextStyle.styleBlackHeader,),
                  SizedBox(height: 20.px,),
                  YZCEditBox(title: '手机号', hint: '请输入手机号', autofocus: _mobileAutoFocus, controller: _mobileController, inputType: TextInputType.phone),
                  YZCEditBox(title: '密码', hint: '6-15位数字或字母', autofocus: _mobileAutoFocus, controller: _pwdController, obscureText: !_showPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                          _showPassword ? Icons.visibility_off : Icons.visibility),
                      color: WFHelp.mainHintTextColor,
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ),
                  YZCEditBox(title: '验证码', hint: '请输入验证码', autofocus: _mobileAutoFocus, controller: _codeController, inputType: TextInputType.number,
                    suffixIcon: FlatButton(
                      child: Text((_ticks < 0) ? "获取验证码" : "$_ticks秒", style: ThemeTextStyle.styleFormLittleHint),
                      //textColor: Colors.blue,
                      onPressed: (_ticks < 0) ? _gatherCode : null,
                    ),),
                  Container(
                    margin:EdgeInsets.fromLTRB(15.px,10.px,15.px,0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:<Widget>[
                          YZCButtonLeftRightRound(
                            onPressed: _register,
                            bgColor: WFHelp.mainColor,
                            title: Text('注册', style: ThemeTextStyle.styleWhiteConfirmButton),),
                        ]
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('注册即表明同意'),
                        Text('云智充用户协议', style: TextStyle(color: WFHelp.mainColor)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.px,),
                  SizedBox(
                    //height: 150,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Align(
                              alignment: Alignment.center,
                              child: FlatButton(
                                child: Text('忘记密码'),
                                onPressed: (){ Navigator.pushNamed(context, YZCForgetPasswordPage.routeName); },
                              )
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text("|"),
                        ),
                        Expanded(
                          flex: 5,
                          child: Align(
                              alignment: Alignment.center,
                              child: FlatButton(
                                child: Row(
                                  children: <Widget>[
                                    Text('已有账号？'),
                                    Text('登录', style: TextStyle(color: WFHelp.mainColor)),
                                  ],
                                ),
                                onPressed: (){ Navigator.pop(context); },
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
