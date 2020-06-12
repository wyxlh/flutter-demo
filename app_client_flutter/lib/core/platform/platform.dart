
import 'dart:convert';

import 'package:client/core/service/data.dart';
import 'package:flutter/services.dart';
import '../../configure.dart';
import '../event/event.dart';
import '../io/net/net.dart';
import '../io/file/asset.dart';

class YZCPlatform {
  static const _methodChannel = const MethodChannel("yzc_method_channel");
  static const _eventChannel = const EventChannel("yzc_event_channel");
  //static Map<String, Function> _callback = Map<String, Function>();

  static Future init() async {
    _eventChannel.receiveBroadcastStream().listen((Object data) {
      print("event channel onData: $data");
    }, onError: (Object error) {
      print("event channel onError: $error");
    });
  }

  static void toast(String tag, String message) async {
    await _methodChannel.invokeMethod('toast', {'tag': tag, 'msg': message});
  }
  
  static Future<String> getAppInfo() async {
    Map<String, dynamic> appInfo = json.decode(await _methodChannel.invokeMethod("getAppInfo"));
    if (appInfo.containsKey('updateBaseVersion')) {
      YZCAsset.updateBaseVersion = appInfo['updateBaseVersion'];
    }
  }

  static Future<Map<String, String>> getHttpHeaders() async {
    Map<String, String> ret = Map<String, String>();
    Map<String, dynamic> headers = json.decode(await _methodChannel.invokeMethod("getHttpHeaders"));
    List<String> keys = headers.keys.toList();
    for (int i = 0; i < keys.length; ++i) {
      ret[keys[i]] = headers[keys[i]].toString();
    }
    return ret;
  }

  static void updateUUID(String uuid) {
    _methodChannel.invokeMethod("updateUUID", uuid);
  }

  static void rebootApp() {
    _methodChannel.invokeMethod("reboot");
  }

  static void callPhone(String cell) {
    _methodChannel.invokeMethod("phoneCilck", cell);
  }

  static Future<String> jsAPI(String method, dynamic params, [Function cb]) async {
    //_callback[method] = cb;
    //Map<String, dynamic> headers = json.decode(await CHANNEL.invokeMethod("getHttpHeaders"));
    switch (method) {
//      case 'getHeadImage': //上传头像点击拍照
//        break;
//      case 'upLoadHeadImage': //从相册选择
//        break;
//      case 'downLoadApp': //版本更新页面 点击下载最新版本
//        break;
      case 'goBack': //goBack
        YZCEvent.emit('webviewGoBack', params);
        break;
      case 'dsBLoginOut': //退出登录
        YZCData.user.logout();
        break;
      case 'getUUID':
        if (cb != null) cb(YZCData.user.uuid);
        return YZCData.user.uuid;
        break;
      case 'placeOrder': //支付订单
        //print(params);
        var order = await YZCNet.httpPost("/app-partner/applyTemplate/unifiedOrder", {"money":params["money"],"payMethod":params["payMethod"],"sn":params["sn"]});
        print(json.encode(order));
        if (200 == order['code']) {
          order['data']["payMethod"] = params["payMethod"];
          String response;
          try {
            response = await _methodChannel.invokeMethod(method, order['data']);
          } on PlatformException catch(e) {
            response = '{"code":1, "msg":"${e.code}"}';
          }
          cb(response);
        } else {
          cb('{"code":1,"msg":"服务器获取订单失败，请检查网络再重试。"}');
        }
        //String response = await _methodChannel.invokeMethod(method, params);
        //cb(response);
        break;
//      case 'saveQrImg': //保存图片
//        break;
//      case 'shareWeixin': //分享图片到微信好友
//        break;
//      case 'shareCircle': //分享图片到朋友圈
//        break;
//      case 'copyUrl': //复制链接
//        break;
//      case 'saveImg': //下载图片
//        break;
//      case 'shareWeixinUrl': //分享url到微信好友
//        break;
//      case 'phoneCilck': //联系客服
//        break;
      case 'getAppVersion':
        if (cb != null) cb(YZCConfigure.appVersion);
        break;
    //case 'getUUID':
      case 'getUserId':
        if (cb != null) cb(YZCData.user.uuid);
        break;
      case 'isIphoneX':
        if (cb != null) cb('0');
        break;
      case 'showNativeTitle':
        if (cb != null) cb('');
        break;
      default:
        if (cb != null) {
          String response;
          try {
            response = await _methodChannel.invokeMethod(method, params);
          } on PlatformException catch(e) {
            response = '{"code":1, "msg":"${e.code}"}';
          }
          cb(response);
        } else {
          _methodChannel.invokeMethod(method, params);
        }
        break;
    }
    return '';
  }
}
