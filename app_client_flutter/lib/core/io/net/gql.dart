
import 'dart:io';
import 'package:flutter/cupertino.dart';
import '../../platform/platform.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

typedef Widget GraphQLBuilder(QueryResult result);

class YZCGraphQL {
  Map<String, String> _headers = Map<String, String>();

  YZCGraphQL() {
    _headers["Content-type"] = "application/json";
    _headers["appType"] = "1"; //0是云智充app;1是云智充合伙人app
    //_headers["appVersion"] = "1.0.0"; //getAppInfo().versionName
    _headers["certType"] = "1";
    //_headers["certification"] = "1"; //RSAUtil.encryptDataByPublicKey((currentTimeMillis + "502880496058fbb7016068fc201e0019").getBytes(), RSAUtil.keyStrToPublicKey(ff)).trim())
    _headers["channel"] = "yzc-baidu";
    //_headers["deviceToken"] = "00:00:00:00:00"; //getMacAddress()
    _headers["isTest"] = "1"; //99默认为测试,1
    //_headers["osInformation"] = "1:1"; //Build.MODEL + ":" + Build.VERSION.RELEASE
    //_headers["plat"] = "android";
    //_headers["timestamp"] =  DateTime.now().millisecondsSinceEpoch.toString();
    _headers["version"] = "1.0";
  }

  Future<Map<String, dynamic>> query(String url, String query) async {
    Map<String, String> headers = Map<String, String>();
    headers.addAll(_headers);
    headers.addAll(await YZCPlatform.getHttpHeaders());

    HttpLink httpLink = HttpLink(uri: url, headers: headers);
    GraphQLClient client = GraphQLClient (
      link: httpLink as Link,
      cache: OptimisticCache(
        dataIdFromObject: typenameDataIdFromObject,
      ),
    );
    QueryResult result = await client.query(QueryOptions(document: query));
    if (result.data == null) {
      return {"code":"error", "reslut":"获取数据失败。"};
    } else {
      return result.data;
    }
  }
}
