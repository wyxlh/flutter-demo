

import 'package:client/core/io/net/net.dart';
import 'package:client/core/platform/platform.dart';
import 'package:client/core/service/basic/api_urls.dart';

import '../../../configure.dart';
import '../base.dart';
import '../data.dart';

class YZCUser extends YZCBase {
  String mobile;

  String uuid;
  String loginDate;
  Map<String, dynamic> userInfo;

  bool isLogin = false;

  YZCUser(): super('user');

  @override
  void fromJson(Map<String, dynamic> d) {
    mobile = d["mobile"];
    uuid = d["uuid"];
    loginDate = d["loginDate"];
    userInfo = d.containsKey('userInfo') ? d['userInfo'] : d;
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic> {
    'mobile': mobile,
    'uuid': uuid,
    'loginDate': loginDate,
    'userInfo': userInfo
  };

  //注册的获取验证码 //短信类型:1、注册；4、快捷登录发送验证码；5、修改手机号；6、忘记密码
  void gatherVerifyCode(String mobile, int type, {OnSuccess success, OnFailed failed}) {
    YZCNet.httpPost(YZCConfigure.mkApiURL(ApiUrls.verifyCode), {"mobile":mobile, "type":type}).then((response) {
      if ((0 == response['code']) || (200 == response['code'])) {
        if (success != null) success(response['data']);
      } else {
        if (failed != null) failed(response['msg']);
      }
    });
  }

  //注册
  void register(String mobile, String password, String code, {OnSuccess success, OnFailed failed}) {
    YZCNet.httpPost(YZCConfigure.mkApiURL(ApiUrls.register), {"mobile":mobile,"password":password,"code":code}).then((response) {
      if ((0 == response['code']) || (200 == response['code'])) {
        var data = response['data'];
        fromJson(data);
        isLogin = true;
        YZCPlatform.updateUUID(uuid);
        save();
        if (success != null) success(data);
      } else {
        if (failed != null) failed(response['msg']);
      }
    });
  }

  //密码登录
  void loginWithPassword(String mobile, String password, {OnSuccess success, OnFailed failed}) {
    YZCNet.httpPost(YZCConfigure.mkApiURL(ApiUrls.login), {"mobile":mobile,"password":password}).then((response) {
      if ((0 == response['code']) || (200 == response['code'])) {
        var data = response['data'];
        fromJson(data);
        isLogin = true;
        YZCPlatform.updateUUID(uuid);
        save();
        if (success != null) success(response['data']);
      } else {
        if (failed != null) failed(response['msg']);
      }
    });
  }

  //验证码登录
  void loginWithCode(String mobile, String code, {OnSuccess success, OnFailed failed}) {
    YZCNet.httpPost(YZCConfigure.mkApiURL(ApiUrls.quickLogin), {"mobile":mobile,"code":code}).then((response) {
      if ((0 == response['code']) || (200 == response['code'])) {
        var data = response['data'];
        fromJson(data);
        isLogin = true;
        YZCPlatform.updateUUID(uuid);
        save();
        if (success != null) success(data);
      } else {
        if (failed != null) failed(response['msg']);
      }
    });
  }

  //忘记密码
  void resetPassword(String mobile, String password, String code, {OnSuccess success, OnFailed failed}) {
    YZCNet.httpPost(YZCConfigure.mkApiURL(ApiUrls.forgetPassword), {"mobile":mobile,"password":password,"code":code}).then((response) {
      if ((0 == response['code']) || (200 == response['code'])) {
        if (success != null) success(response['data']);
      } else {
        if (failed != null) failed(response['msg']);
      }
    });
  }

  //默认登录
  void login({OnSuccess success, OnFailed failed}) {
    isLogin = ((uuid != null) && (uuid.length > 0));
    /*
    isLogin = false;
    if ((uuid != null) && (uuid.length > 0)) {
      YZCNet.httpPost(YZCConfigure.mkApiURL(ApiUrls.getUserInfo), {"accessToken":uuid}).then((response) {
        if ((0 == response['code']) || (200 == response['code'])) {
          isLogin = true;
          if (success != null) success(response['data']);
        } else {
          if (failed != null) failed(response['msg']);
        }
      });
    } else {
      if (failed != null) failed('');
    }*/
  }

  //退出登录
  Future logout() async{
    uuid = null;
    await clear();
  }
}
