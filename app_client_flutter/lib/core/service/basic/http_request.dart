import 'package:client/core/platform/platform.dart';
import 'package:dio/dio.dart';
import '../data.dart';
import 'config.dart';


class HttpRequest {
  static final BaseOptions options = BaseOptions(baseUrl: HttpConfig.baseURL, connectTimeout: HttpConfig.timeout);
  static final Dio dio = Dio(options);

  static Future<T> request<T>(String url,
      {String method = 'get', Map<String, dynamic> params, Interceptor inter}) async {
    // 1.请求的单独配置
    final options = Options(method: method,headers:{'isTest': '99',
      //'version': '1.0',
      'Content-type': 'application/json',
      'certType': '0',
      //'certification': '0',
      //'timestamp': '0',
      //'plat': '0',
      //'appVersion': '4.2.9',
      //'osInformation': '0',
      'channel': '0',
      //'longitude': '0',
      //'latitude': '0',
      //'deviceToken': '0',
      //'userId': '97b337a7f3b943fbb957ccc852c5d6f1',
      'appType': '0'});

    // 2.添加第一个拦截器
//    Interceptor dInter = InterceptorsWrapper(
//        onRequest: (RequestOptions options) {
//          // 1.在进行任何网络请求的时候, 可以添加一个loading显示
//
//          // 2.很多页面的访问必须要求携带Token,那么就可以在这里判断是有Token
//
//          // 3.对参数进行一些处理,比如序列化处理等
////          print("拦截了请求");
//          return options;
//        },
//        onResponse: (Response response) {
////          print("拦截了响应");
//          return response;
//        },
//        onError: (DioError error) {
////          print("拦截了错误");
//          return error;
//        }
//    );
//    List<Interceptor> inters = [dInter];
//    if (inter != null) {
//      inters.add(inter);
//    }
//    dio.interceptors.addAll(inters);
//    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    dio.options.headers.addAll(await YZCPlatform.getHttpHeaders());
    if (YZCData.user.uuid != null) {
      dio.options.headers["userId"] = YZCData.user.uuid;
      dio.options.headers["uuid"] = YZCData.user.uuid;
    }

    // 3.发送网络请求
    if (method == 'post') {
      try {
        Response response = await dio.post(url,data: params,options: options);
          print(response.data);
          return response.data;
      } on DioError catch(e) {
          return Future.error(e);
      }
    }else {
      try {
        Response response = await dio.get(url,queryParameters: params,options: options);
        print(response.data);
         return response.data;
      } on DioError catch(e) {
         return Future.error(e);
      }
    }
  }
}
