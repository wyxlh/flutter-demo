
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/service/data.dart';
import 'ui/app.dart';
import 'package:getuiflut/getuiflut.dart';

Future<void> useGetui() async {
  Getuiflut gt = Getuiflut();
  String gtVersion;
  if (Platform.isIOS) {
    gt.startSdk(appId: '1rF4Wza0hq5spZQ2DfkDo9', appKey: 'raJ98El2eA6inHcUqtQ8Y4', appSecret: 'yv9h22UUiQ9vQTfnoVcz26');
  }
  try {
    gtVersion = await Getuiflut.platformVersion;
  } on PlatformException {
    gtVersion = 'Failed to get getui version';
  }
  print(("Getui version:" + gtVersion));

  gt.addEventHandler(
    onReceiveClientId: (String message) async {
      print("Getui onReceiveClientId: $message"); // 注册收到 cid 的回调
    },
    onReceiveMessageData: (Map<String, dynamic> msg) async {
      print("Getui onReceiveMessageData: $msg"); // 透传消息的内容都会走到这里
    },
    onNotificationMessageArrived: (Map<String, dynamic> msg) async {
      print("Getui onNotificationMessageArrived"); // 消息到达的回调
    },
    onNotificationMessageClicked: (Map<String, dynamic> msg) async {
      print("Getui onNotificationMessageClicked"); // 消息点击的回调
    },
  );

  try {
    Getuiflut.initGetuiSdk;
  } catch(e) {
    print(e.toString());
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  YZCData.init().then((value) {
    //useGetui();
    runApp(YZCApp());

    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  });
}
