
import 'dart:io';
import 'dart:async';
//import 'dart:html';
import 'dart:convert';
import 'package:client/core/service/data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import '../../../configure.dart';
import '../file/file.dart';
import '../../platform/platform.dart';

typedef DownloadProgressCallback = void Function(double progress); //0~1

//0: OK, else failed，1:不需要下载,2：下载文件失败,3:下载文件校验失败,4:没有远程版本 5：远程版本太老，6：版本没变化，7：没有远程文件列表
typedef DownloadCompleted = void Function(int reason);

class YZCHttp {
  Map<String, String> _headers = Map<String, String>();

  YZCHttp() {
    //appVersion, certification, deviceToken, osInformation, plat, timestamp 由平台实现
    _headers["Content-type"] = "application/json";
    _headers["appType"] = "0"; //0是云智充app;1是云智充合伙人app
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

  Future<Map<String, dynamic>> get(String url, [Map<String, dynamic> data]) async {
    return await _requestHttp(false, "get", url, data);
  }

  Future<Map<String, dynamic>> post(String url, [Map<String, dynamic> data]) async {
    return await _requestHttp(false, "post", url, data);
  }

  void getIgnoreResponse(String url, [Map<String, dynamic> data]) {
    _requestHttp(true, "get", url, data);
  }

  void postIgnoreResponse(String url, [Map<String, dynamic> data]) {
    _requestHttp(true, "post", url, data);
  }

  Future<Map<String, dynamic>> _requestHttp(bool ignoreResponse, String method, String url, [Map<String, dynamic> data]) async {
    print('http ' + method + ', url=' + url + ', param:' + json.encode(data));
    Dio dio = Dio();
    dio.options.connectTimeout = 15000;
    if (ignoreResponse) {
      dio.options.receiveTimeout = 2000;
    } else {
      dio.options.receiveTimeout = 15000;
    }
    dio.options.headers.addAll(_headers);
    dio.options.headers.addAll(await YZCPlatform.getHttpHeaders());

    if (YZCData.user.uuid != null) {
      dio.options.headers["userId"] = YZCData.user.uuid;
      dio.options.headers["uuid"] = YZCData.user.uuid;
    }

    print("platform headers:" + json.encode(dio.options.headers));

    var result;
    try {
      Response response;
      if (method == 'get') {
        response = (data is Map<String, dynamic>) ? await dio.get(url, queryParameters: data) : await dio.get(url);
      } else if (method == 'post') {
        response = (data is Map<String, dynamic>) ? await dio.post(url, data: data) : await dio.post(url);
      }
      if (response.data != null) {
        //print('response.data:' + response.data.runtimeType.toString() + ', ' + response.data);
        result =  (response.data is String) ? jsonDecode(response.data) : response.data;
      }
    } on DioError catch(e) {
      print(e);
    }
    debugLog('http return:' + json.encode(result ?? {}));
    return result ?? {"code": 1, "msg":"获取数据失败"};
  }

  Future download(String url, String path, {DownloadProgressCallback onProgress, DownloadCompleted onCompleted}) async {
    //print('download{url:$url, path:$path}');
    Dio dio = Dio();
    dio.options.connectTimeout = 15000;
    dio.options.receiveTimeout = 15000;
    dio.options.headers.addAll(_headers);
    dio.options.headers.addAll(await YZCPlatform.getHttpHeaders());
    if (YZCData.user.uuid != null) {
      dio.options.headers["userId"] = YZCData.user.uuid;
      dio.options.headers["uuid"] = YZCData.user.uuid;
    }

    Response response = await dio.download(url, path, onReceiveProgress:(int count, int total) {
      if ((onProgress != null) && (total > 0)) {
        onProgress(count.toDouble() / total);
      }
    }, options: Options(
      responseType:ResponseType.stream,
    ));
    if (onCompleted !=  null) onCompleted(0);
  }

  Future downloadChunks(String url, String path, {String md5, DownloadProgressCallback onProgress, DownloadCompleted onCompleted}) async {
    print('downloadChunks{url:$url, path:$path}');

    const int firstChunkSize = 2;
    const int maxChunkSize = 1024 * 1024;
    //const int maxChunk = 20;

    int total = 0;
    Dio dio = Dio();
    var progress = <int>[];

    dio.options.connectTimeout = 15000;
    dio.options.receiveTimeout = 15000;
    dio.options.headers.addAll(_headers);
    dio.options.headers.addAll(await YZCPlatform.getHttpHeaders());

    if (YZCData.user.uuid != null) dio.options.headers["userId"] = YZCData.user.uuid;

    callback(no) {
      return (int received, _) {
        progress[no] = received;
        if (onProgress != null && total > 0) {
          int part = progress.reduce((a, b) => a + b);
          onProgress(part.toDouble() / total);
        }
      };
    }

    Future<Response> downloadChunk(String url, int start, int end, int no) async {
      progress.add(0);
      --end;
      dio.options.headers["range"] = "bytes=$start-$end";
      return dio.download(url, path + "_temp$no", onReceiveProgress: callback(no));
    }

    Future mergeTempFiles(chunk) async {
      File f = File(path + "_temp0");
      IOSink ioSink = f.openWrite(mode: FileMode.writeOnlyAppend);
      for (int i = 1; i < chunk; ++i) {
        File _f = File(path + "_temp$i");
        await ioSink.addStream(_f.openRead());
        await _f.delete();
      }
      await ioSink.close();
      await f.rename(path);
      if ((md5 != null) && (md5.length > 0) && (onCompleted != null) && (total > 0)) {
        String chckMD5 = await YZCFile.md5File(path);
        if (chckMD5 != md5) {
          onCompleted(3);
        } else {
          onCompleted(0);
        }
      } else {
        onCompleted(0);
      }
    }
    
    Response response = await downloadChunk(url, 0, firstChunkSize, 0);

    if (response.statusCode == 206) {
      total = int.parse(
          response.headers.value(HttpHeaders.contentRangeHeader).split("/").last);
      int reserved = total -
          int.parse(response.headers.value(HttpHeaders.contentLengthHeader));
      print('download: reserved:$reserved / total:$total');
      int chunk = 1;
      int start = firstChunkSize;
      var futures = <Future>[];
      while (reserved > 0) {
        int chunkSize = maxChunkSize;
        if (reserved < maxChunkSize) {
          chunkSize = reserved;
        }
        futures.add(downloadChunk(url, start, start + chunkSize, chunk));
        start += chunkSize;
        reserved -= chunkSize;
        ++chunk;
      }
      print('download: chunks:$chunk');
      if (futures.length > 0) {
        await Future.wait(futures);
      }
      await mergeTempFiles(chunk);
    } else {
      if (onCompleted !=  null) onCompleted(2);
    }
  }
}
