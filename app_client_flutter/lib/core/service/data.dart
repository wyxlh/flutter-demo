import 'dart:convert';

import 'package:client/core/service/user/user.dart';
import 'package:client/ui/shared/size_fit.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:client/core/extension/int_extension.dart';
import '../../configure.dart';
import '../io/file/file.dart';
import '../platform/platform.dart';
import 'package:path_provider/path_provider.dart';

import 'guide/guide.dart';

typedef void YZCCallback(arg);
typedef OnSuccess = void Function(Map<String, dynamic> result);
typedef OnFailed = void Function(String msg);

class YZCData {
  static String getTypeName(dynamic obj) {
    return obj.runtimeType.toString();
  }

  static YZCGuide guide = YZCGuide();
  static YZCUser user = YZCUser();

  static Future init() async {
    YZCFile.setWriteablePath((await getApplicationSupportDirectory()).path);
    YZCPlatform.getAppInfo();
    WYSizeFit.initialize();
    guide.load();
    user.load();

    user.login();
    debugLog('data, isLogin:${user.isLogin}, userInfo: ' + jsonEncode(user.userInfo));
  }


  static String formatIncomeInteger(int value) {
    return (value ~/ 1000).toString();
  }

  static String formatIncomeDecimal(int value) {
    return sprintf(".%03i", [value % 1000]);
  }

}
