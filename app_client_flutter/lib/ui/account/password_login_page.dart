import 'package:client/core/event/event.dart';
import 'package:client/core/service/data.dart';
import 'package:flutter/material.dart';
import 'package:client/core/extension/int_extension.dart';

Widget loginBottomWidget() {
  return SizedBox(
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
                onPressed: (){ YZCEvent.emit('forgetPasswordPage'); },
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
                    Text('未有账号？'),
                    Text('注册', style: TextStyle(color: Colors.red)),
                  ],
                ),
                onPressed: (){ YZCEvent.emit('forgetPasswordPage'); },
              )
          ),
        ),
      ],
    ),
  );
}

class YZCPasswordLoginPage extends StatefulWidget {
  @override
  _YZCPasswordLoginPageState createState() => _YZCPasswordLoginPageState();
}

class _YZCPasswordLoginPageState extends State<YZCPasswordLoginPage> {
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  bool _showPassword = false; //密码是否显示明文
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _mobileAutoFocus = true;

  void _onLogin() async {

  }

  void _loginSuccess(arg) {
    YZCEvent.emit('mainPage');
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
      appBar: AppBar(title: Text('登录')),
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
                  validator: (v) {
                    return v.trim().isNotEmpty ? null : '手机号不能为空';
                  }),
              TextFormField(
                controller: _pwdController,
                autofocus: !_mobileAutoFocus,
                decoration: InputDecoration(
                    labelText: '密码',
                    hintText: '6-15位数字或字母',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _showPassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                ),
                obscureText: !_showPassword,
                validator: (v) {
                  return v.trim().isNotEmpty ? null : ('密码不能为空');
                },
              ),
              Container(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    child: Text('验证码快捷登录'),
                    textColor: Colors.red,
                    onPressed: (){ YZCEvent.emit('codeLoginPage'); },
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
