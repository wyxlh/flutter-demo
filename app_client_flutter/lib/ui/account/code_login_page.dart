import 'package:client/core/event/event.dart';
import 'package:client/core/service/data.dart';
import 'package:flutter/material.dart';
import 'package:client/core/extension/int_extension.dart';
import 'password_login_page.dart';

class YZCCodeLoginPage extends StatefulWidget {
  @override
  _YZCCodeLoginPageState createState() => _YZCCodeLoginPageState();
}

class _YZCCodeLoginPageState extends State<YZCCodeLoginPage> {
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _mobileAutoFocus = true;

  void _gatherCode() async {

  }

  void _onLogin() async {

  }

  void _loginSuccess(arg) {
    YZCEvent.emit('enterMainPage');
  }

  void _loginFailed(arg) {

  }

  @override
  void initState() {
    super.initState();
    _mobileController.text = YZCData.user.mobile;
    if ((_mobileController.text != null) && (_mobileController.text.length > 0)) {
      _mobileAutoFocus = false;
    }
    YZCEvent.on('loginSuccess', _loginSuccess);
    YZCEvent.on('loginFailed', _loginFailed);
  }

  @override
  void dispose() {
    YZCEvent.off('loginSuccess', _loginSuccess);
    YZCEvent.off('loginFailed', _loginFailed);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('验证码登录')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          //autovalidate: true,
          child: Column(
            children: <Widget>[
              TextFormField(
                  autofocus: _mobileAutoFocus,
                  controller: _mobileController,
                  decoration: InputDecoration(
                    labelText: '手机号',
                    hintText: '请输入手机号',
                    prefixIcon: Icon(Icons.person),
                  ),
                  // 校验用户名（不能为空）
                  validator: (v) {
                    return v.trim().isNotEmpty ? null : '手机号不能为空';
                  }),
              TextFormField(
                controller: _codeController,
                autofocus: !_mobileAutoFocus,
                decoration: InputDecoration(
                    labelText: '验证码',
                    hintText: '请输入验证码',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: FlatButton(
                      child: Text("获取验证码"),
                      //textColor: Colors.blue,
                      onPressed: _gatherCode,
                      /*() {
                        //导航到新路由
                        Navigator.push( context,
                            MaterialPageRoute(builder: (context) {
                              return NewRoute();
                            }));
                      },*/
                    ),
                ),
                validator: (v) {
                  return v.trim().isNotEmpty ? null : ('验证码不能为空');
                },
              ),
              Container(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    child: Text('密码登录'),
                    textColor: Colors.red,
                    onPressed: (){ YZCEvent.emit('passwordLoginPage'); },
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 55.0),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: _onLogin,
                    textColor: Colors.white,
                    child: Text('登录'),
                  ),
                ),
              ),
              loginBottomWidget()
            ],
          ),
        ),
      ),
    );
  }
}
