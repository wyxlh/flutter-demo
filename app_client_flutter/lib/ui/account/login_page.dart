import 'dart:async';
import 'package:client/core/event/event.dart';
import 'package:client/core/service/data.dart';
import 'package:client/ui/account/register_page.dart';
import 'package:client/ui/shared/help.dart';
import 'package:client/widget/common/editbox.dart';
import 'package:client/widget/webview/webview_page.dart';

import '../../widget/common/button_leftright_round.dart';
import 'package:client/core/extension/int_extension.dart';
import '../../ui/common/themeTextStyles.dart';
import '../../widget/common/app_bar.dart';
import '../../widget/common/page_frame.dart';
import 'package:flutter/material.dart';

import '../dialog/message_box.dart';
import 'forget_password_page.dart';

class YZCLoginPage extends StatefulWidget {
  static const String routeName = '/loginPage';

  @override
  _YZCLoginPageState createState() => _YZCLoginPageState();
}

class _YZCLoginPageState extends State<YZCLoginPage> {
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  bool _showPassword = false; //密码是否显示明文
  GlobalKey _formKey = GlobalKey<FormState>();
  bool _mobileAutoFocus = true;

  bool _loginWithPassword = true;

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

  void _changeLoginMode() {
    setState(() {
      _mobileController.text = YZCData.user.mobile;
      if ((_mobileController.text != null) && (_mobileController.text.length > 0)) {
        _mobileAutoFocus = false;
      }
      _pwdController.text = '';
      _loginWithPassword = !_loginWithPassword;
    });
  }

  void _gatherCode() {
    if (!_checkMobile()) return;

    if (_ticks < 0) YZCData.user.gatherVerifyCode(_mobileController.text, 4, success: (Map<String, dynamic> result) {
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

  void _login(arg) {
    if (!_checkMobile() || !_checkPassword()) return;

    OnSuccess success = (Map<String, dynamic> result) {
      YZCEvent.emit('mainPage');
    };
    OnFailed failed = (String msg) {
      TipDialog(context, msg);
    };

    String mobile = _mobileController.text;
    String password = _pwdController.text;

    //mobile = '18817384535';
    //password = '123456';

    if (_loginWithPassword) {
      YZCData.user.loginWithPassword(mobile, password, success: success, failed: failed);
    } else {
      YZCData.user.loginWithCode(mobile, password, success: success, failed: failed);
    }
  }

  void _loginSuccessEx(arg) {
    Navigator.pushNamed(context, YZCWebviewPage.routeName, arguments: {'name':'test', 'title':'云智充', 'url':'https://www.baidu.com', 'html':'''
<html>
<head>
	<meta charset="UTF-8">
  <title>WebView 测试Flutter</title>

<script>
//////////begin for flutter//////////////////
var yzcBridge = {
  ID: 0,
  callbacks: {},
  fixedResults: {},

  call: function(method, args, cb) {
    var ret = {};

    if (typeof args == 'function') {
      cb = args;
      args = {};
    }

    if (this.fixedResults[method] === undefined) {
      var arg = {method: method, data: args === undefined ? {} : args};
      if (typeof cb == 'function') {
        var cbName = 'yzc' + this.ID++;
        this.callbacks[cbName] = cb;
        arg['callback'] = cbName;
      }
      arg = JSON.stringify(arg);
      if (yzc !== undefined) yzc.postMessage(arg);
    } else {
      if (typeof cb == 'function') {
        cb(this.fixedResults[method]);
      }
      return this.fixedResults[method];
    }
    
    return ret;
  },

  onMessage: function(arg) {
    var data = JSON.parse(arg);
    if (data.callback && this.callbacks[data.callback]) {
      this.callbacks[data.callback](data.result);
      delete this.callbacks[data.callback];
    } else if (data.result.key && data.result.value) {
      this.fixedResults[data.result.key] = data.result.value;
    }
  }
};
//////////end for flutter//////////////////
</script>
  
</head>

<body style="background-color: #FFF;">
    <script>
      function getHeadImage() {
        yzcBridge.call("getHeadImage", function(result) {
          document.getElementById("test").innerText = "getHeadImage:" + JSON.stringify(result);
        });
      }
      function upLoadHeadImage() {
        yzcBridge.call("upLoadHeadImage", function(result) {
          document.getElementById("test").innerText = "upLoadHeadImage:" + JSON.stringify(result);
        });
      }
      function downLoadApp() {
        yzcBridge.call("downLoadApp", function(result) {
          document.getElementById("test").innerText = "downLoadApp:" + JSON.stringify(result);
        });
      }
      function goBack() {
        yzcBridge.call("goBack", "test");
      }
      function dsBLoginOut() {
        yzcBridge.call("dsBLoginOut");
      }
      function placeOrderByWx() {
        yzcBridge.call("placeOrder", {"payMethod":1, "money":2000, "sn":'20200214184523014'}, function(result) {
          document.getElementById("test").innerText = "placeOrderByWx:" + JSON.stringify(result);
        });
      }
      function placeOrderByAli() {
        yzcBridge.call("placeOrder", {"payMethod":0, "money":2000, "sn":'20200214184523014'}, function(result) {
          document.getElementById("test").innerText = "placeOrderByAli:" + JSON.stringify(result);
        });
      }
      function shareWeixin() {
        yzcBridge.call("shareWeixin", "https://goss.veer.com/creative/vcg/veer/800water/veer-301663045.jpg", function(result) {
          document.getElementById("test").innerText = "shareWeixin:" + JSON.stringify(result);
        });
      }
      function shareCircle() {
        yzcBridge.call("shareCircle", "https://goss.veer.com/creative/vcg/veer/800water/veer-153835898.jpg", function(result) {
          document.getElementById("test").innerText = "shareCircle:" + JSON.stringify(result);
        });
      }
      function copyUrl() {
        yzcBridge.call("copyUrl", "I will go to clipboard.");
      }
      function saveImg() {
        //yzcBridge.call("saveImg", "https://www.baidu.com");
      }
      function getUUID() {
        document.getElementById("test").innerText = "getUUID:" + yzcBridge.call("getUUID");
        //yzcBridge.call("getUUID", function(result) {document.getElementById("test").innerText = "getUUID:" + result;});
      }
      function shareWeixinUrl() {
        yzcBridge.call("shareWeixinUrl", "https://www.baidu.com", function(result) {
          document.getElementById("test").innerText = "shareWeixinUrl:" + JSON.stringify(result);
        });
      }
      function phoneCilck() {
        yzcBridge.call("phoneCilck", "4008251068");
      }
    </script>
    <h1><center><button onclick="getHeadImage()">上传头像点击拍照</button></center></h1>
    <h1><center><button onclick="upLoadHeadImage()">从相册选择</button></center></h1>
    <!-- <h1><center><button onclick="downLoadApp()">版本更新</button></center></h1> -->
    <h1><center><button onclick="goBack()">goBack</button></center></h1>
    <!-- <h1><center><button onclick="dsBLoginOut()">退出登录</button></center></h1> -->
    <h1><center><button onclick="placeOrderByWx()">微信支付</button></center></h1>
    <h1><center><button onclick="placeOrderByAli()">支付宝支付</button></center></h1>
    <h1><center><button onclick="shareWeixin()">微信分享给好友</button></center></h1>
    <h1><center><button onclick="shareCircle()">微信分享到朋友圈</button></center></h1>
    <h1><center><button onclick="copyUrl()">复制链接</button></center></h1>
    <!-- <h1><center><button onclick="saveImg()">下载图片</button></center></h1> -->
    <h1><center><button onclick="getUUID()">获取uuid</button></center></h1>
    <h1><center><button onclick="shareWeixinUrl()">分享url到微信好友</button></center></h1>
    <h1><center><button onclick="phoneCilck()">联系客服</button></center></h1>
    <p></p>
    <div id='test'>will get from flutter.</div>
    <p></p>
</body>
</html>
    '''});
  }

  @override
  void initState() {
    super.initState();
    _mobileController.text = YZCData.user.mobile;
    if ((_mobileController.text != null) && (_mobileController.text.length > 0)) {
      _mobileAutoFocus = false;
    }
    YZCEvent.on('loginSuccessEx', _loginSuccessEx);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    YZCEvent.off('loginSuccessEx', _loginSuccessEx);
    _mobileController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  double _progress = 0;
  bool _isUpdate = false;
  @override
  Widget build(BuildContext context) {
    return YZCPageFrame(
      //appBar: YZCAppBar(leftItem: SizedBox(width: 24.px,), mediumItem: Text(_loginWithPassword ? '密码登录' : '手机快捷登录', style: ThemeTextStyle.styleBlackHeader,)),
      appBar: YZCAppBar(leftItem: SizedBox(width: 1,)),
      body: Scrollbar(
        child:SingleChildScrollView(
          child:Container(
            padding: EdgeInsets.fromLTRB(15.px, 120.px, 15.px, 15.px),
            child: Form(
              key: _formKey,
                //autovalidate: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /*
        //              SizedBox(
        //                child: Text('看见我了，就说明热更新了。'),
        //              ),
                      SizedBox(
                        height: 5,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                          value: _progress,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () async {
                              if (_isUpdate) return;
                              _isUpdate = true;

                              setState(() {
                                _progress = 0;
                              });
                              YZCAsset.hotUpdate(onProgress: (double progress) {
                                setState(() {
                                  _progress = progress;
                                  //print("download progress: $progress");
                                });
                              }, onCompleted: (int reason) async {
                                //0: OK, else failed，1:不需要下载,2：下载文件失败,3:下载文件校验失败,4:没有远程版本 5：远程版本太老，6：版本没变化，7：没有远程文件列表
                                if (reason == 0) {
                                  if (await ConfirmDialog(context, "更新已经下载好，下次重启会更新。现在就重启吗？")) {
                                    YZCPlatform.rebootApp();
                                  }
                                } else {
                                  print("hotUpdate completed reason: $reason");
                                }
                                _isUpdate = false;
                              });

        //                      String url = 'http://192.168.0.231/yzc';
        //                      String path = YZCFile.cachePath;
        //                      List<Map<String, String>> files = List();
        //                      files.add({"url": url + "/libapp.so", "path": path + '/libapp.so'});
        //                      files.add({"url": url + "/isolate_snapshot_data", "path": path + '/isolate_snapshot_data'});
        //                      files.add({"url": url + "/kernel_blob.bin", "path": path + '/kernel_blob.bin'});
        //                      files.add({"url": url + "/vm_snapshot_data", "path": path + '/vm_snapshot_data'});
        //                      YZCNet.downloadChunksList(files, onProgress: (double progress) async {
        //                        setState(() {
        //                          _progress = progress;
        //                          //print("download progress: $progress");
        //                        });
        //
        //                        if (progress >= 1) {
        //                          if (await ConfirmDialog(context, "更新已经下载好，下次重启会更新。现在就重启吗？")) {
        //                            YZCPlatform.rebootApp();
        //                          }
        //                        }
        //                      });

        //                      YZCNet.downloadChunks(url+"/kernel_blob.bin", path+'/kernel_blob.bin', onProgress: (double progress) {
        //                        setState(() {
        //                          _progress = progress;
        //                          print("download progress: $progress");
        //                        });
        //                      });
                            },
                            textColor: Colors.white,
                            child: Text('热更新'),
                          ),
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              YZCData.user.loginWithPasswordEx("18817384535", "123456");
                            },
                            textColor: Colors.white,
                            child: Text('测试登录'),
                          ),
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () async { Map<String, dynamic> result = await YZCNet.gqlPost("http://dev.jx9n.cn:10001/app-partner-setmeal/graphql", '''
        {
        getAdminAssetsInfoV1(uuid:"411ec8a2f34d4990b23b4a34d42972f0"){
          ... on AssetsInfoVO{
            groupNum,
            onlineNum,
            onlineCdzNum,
            totalNum,
            totalCdzNum,
            errorNum
          }
          ...  on Result{
            code,
            messages
          }
        }
        }
                            ''');
                            print("gql result:" + jsonEncode(result));
                            },
                            textColor: Colors.white,
                            child: Text('测试GQL'),
                          ),
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: (){ Navigator.pushNamed(context, YZCMainPage.routeName); },
                            textColor: Colors.white,
                            child: Text('首页'),
                          ),
                        ],
                      ),
                      */
                      Text(_loginWithPassword ? '密码登录' : '手机快捷登录', style: ThemeTextStyle.styleBlackHeader,),
                      SizedBox(height: 20.px,),
                      YZCEditBox(title: '手机号', hint: '请输入手机号', autofocus: _mobileAutoFocus, controller: _mobileController, inputType: TextInputType.phone,),
                      YZCEditBox(title: _loginWithPassword ? '密码' : '验证码', hint: _loginWithPassword ? '6-15位数字或字母' : '请输入验证码',
                        autofocus: _mobileAutoFocus,
                        controller: _pwdController,
                        obscureText: !_showPassword,
                        suffixIcon: _loginWithPassword ? IconButton(
                          icon: Icon(
                            _showPassword ? Icons.visibility_off : Icons.visibility),
                            color: WFHelp.mainHintTextColor,
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ) : FlatButton(
                          child: Text((_ticks < 0) ? "获取验证码" : "$_ticks秒", style: ThemeTextStyle.styleFormLittleHint),
                          //textColor: Colors.blue,
                          onPressed: (_ticks < 0) ? _gatherCode : null,
                        ),
                      ),
                      Container(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            child: Text(_loginWithPassword ? '验证码快捷登录' : '密码登录', style: TextStyle(color: WFHelp.mainColor),),
                            textColor: WFHelp.mainHintTextColor,
                            onPressed: _changeLoginMode,
                          )
                        ),
                      ),
                      Container(
                        margin:EdgeInsets.fromLTRB(15.px,10.px,15.px,0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:<Widget>[
                              YZCButtonLeftRightRound(
                                onPressed: _login,
                                bgColor: WFHelp.mainColor,
                                title: Text('登录', style: ThemeTextStyle.styleWhiteConfirmButton),),
                            ]
                        ),
                      ),
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
                                        Text('未有账号？'),
                                        Text('注册', style: TextStyle(color: Theme.of(context).accentColor)),
                                      ],
                                    ),
                                    onPressed: (){ Navigator.pushNamed(context, YZCRegisterPage.routeName); },
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
