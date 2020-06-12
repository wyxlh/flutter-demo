class ApiUrls {
  static const String verifyCode = 'yzc-app-api/yzc-app/v1/sms/sendCode'; //获取验证码【原生/H5】 //短信类型:1、注册；4、快捷登录发送验证码；5、修改手机号；6、忘记密码
  static const String register = 'yzc-app-api/yzc-app/v1/member/register'; //注册
  static const String pushCID = 'yzc-app-api/yzc-app/v1/push/update/cid'; //手机端发送pushId给服务端接口
  static const String getUserInfo = 'yzc-app-api/yzc-app/v1/member/mobileLogin'; //通过token获取用户信息
  static const String isOldUser = 'yzc-app-api/yzc-app/v1/member/checkMember'; //查询是否是老用户
  static const String login = 'yzc-app-api/yzc-app/v1/member/login'; //登录
  static const String quickLogin = 'yzc-app-api/yzc-app/v1/member/quickLogin'; //快捷登录
  static const String forgetPassword = 'yzc-app-api/yzc-app/v1/member/forgetThePassword'; //忘记密码



}
