
import 'dart:math';
import 'package:package_info/package_info.dart';
import 'package:flutter/cupertino.dart';
import 'core/io/file/asset.dart';
import 'core/service/data.dart';
import 'ui/common/themeTextStyles.dart';

typedef ButtonCallback = void Function(dynamic arg);

class YZCConfigure {
  static const int MODE_DISTRIBUTE = 0; //发布
  static const int MODE_DEVELOP = 1; //开发

  static int _mode = MODE_DEVELOP;

  static String apiBaseUrl = 'https://prod.jx9n.com/';
  static String h5BaseUrl = 'https://prod.h5.jx9n.com/';
  static String hotUpdateUrl = 'http://192.168.0.231/yzc/';

  static String appVersion = '1.0.0';
  static String appName = '';

  static bool initialized = false;
  /*****屏幕适配*****/
//  static double designedWidth = 375;
//  static double designedHeight = 667;
//
//  static double screenWidth = 0;
//  static double screenHeight = 0;
//
//  static double pixelRatio;
//  static double statusBarHeight;
//  static double bottomBarHeight;
//  static double textScaleFactor;
//
//  static double ratio = 1;
  /*****屏幕适配*****/

  static void init(BuildContext context) {
    if (initialized) return;
    initialized = true;

    switch (_mode) {
      case MODE_DEVELOP:
        apiBaseUrl = 'http://dev.jx9n.cn:10001/';
        h5BaseUrl = 'http://dev.jx9n.cn/';
        break;
    }

    YZCAsset.init(hotUpdateUrl);

    MediaQueryData mediaQueryData = MediaQuery.of(context);
    ThemeTextStyle.init();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appName = packageInfo.appName;
      appVersion = packageInfo.version;
    });
  }

  //static double px(double v) => v * ratio;

  static String mkApiURL(String key) {
    return apiBaseUrl + key;
  }

  static String mkH5URL(String key, [String params = '']) {
    return h5BaseUrl + key + '?uuid=${YZCData.user.uuid}&appVersion=$appVersion&appMode=app&appName=$appName&flutter=true' + params;
  }

  static String mkH5URLEx(String url) {
    return url + '?uuid=${YZCData.user.uuid}&appVersion=$appVersion&appMode=app&appName=$appName&flutter=true';
  }
}

//extension IntFit on int {
//  double get px {
//    return YZCConfigure.px(this.toDouble());
//  }
//}
//
//extension DoubleFit on double {
//  double get px {
//    return YZCConfigure.px(this);
//  }
//}

void debugLog(String str) {
  int i = 0;
  while (i < str.length) {
    int len = min<int>(800, str.length - i);
    print(str.substring(i, i + len));
    i += 800;
  }
}
