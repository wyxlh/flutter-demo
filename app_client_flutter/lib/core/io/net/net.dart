
import 'package:dio/dio.dart';
import 'http.dart';
//import 'socket.dart';
import 'gql.dart';

class YZCNet {
  //static String _baseURL = 'http://api.jx9n.com'; //正式服务
  //static String _baseURL = 'http://dev.jx9n.cn:10001'; //开发测试服务 //https://prod.jx9n.com/
 // static String _baseURL = 'https://prod.jx9n.com/';
//static String _baseURL = 'http://192.168.2.165:8181'; //本地测试服务

  static YZCHttp _http = YZCHttp();
  //static YZCSocket _socket = YZCSocket();
  static YZCGraphQL _gql = YZCGraphQL();

  static YZCHttp getHttp() {
    return _http;
  }

  static YZCGraphQL getGQL() {
    return _gql;
  }

  static Future<Map<String, dynamic>> httpGet(String url, [Map<String, dynamic> data]) async {
    return await _http.get(url, data);
  }

  static Future<Map<String, dynamic>> httpPost(String url, [Map<String, dynamic> data]) async {
    return await _http.post(url, data);
  }

  static void httpPostWithoutResponse(String url, [Map<String, dynamic> data]) {
    return _http.postIgnoreResponse(url, data);
  }

  static Future<Map<String, dynamic>> gqlPost(String url, String query) async {
    return await _gql.query(url, query);
  }
  
  static Future download(String url, String path, {DownloadProgressCallback onProgress, DownloadCompleted onCompleted}) async {
    return await _http.download(url, path, onProgress: onProgress, onCompleted: onCompleted);
  }

  static Future downloadList(List<Map<String, String>> files, {DownloadProgressCallback onProgress, DownloadCompleted onCompleted}) async {
    int fileCount = files.length;
    int completedReason = 0;
    if (fileCount > 0) {
      double seg = 1 / fileCount;
      for (int i = 0; i < fileCount; ++i) {
        Map<String, String> ele = files[i];
        await download(ele['url'], ele['path'], onProgress: (double progress) {
          if (onProgress != null) onProgress(i * seg + progress * seg);
        }, onCompleted: (int reason) {
          completedReason = reason;
        });
        if (completedReason != 0) break;
      }
    }
    if (onCompleted != null) onCompleted(completedReason);
  }

  static Future downloadChunks(String url, String path, {String md5, DownloadProgressCallback onProgress, DownloadCompleted onCompleted}) async {
    //print('download:$url to $path');
    return await _http.downloadChunks(url, path, md5: md5, onProgress: onProgress, onCompleted: onCompleted);
  }

  static Future downloadChunksList(List<Map<String, String>> files, {String md5, DownloadProgressCallback onProgress, DownloadCompleted onCompleted}) async {
    int fileCount = files.length;
    double seg = 1 / fileCount;
    int completedReason = 0;
    for (int i = 0; i < fileCount; ++i) {
      Map<String, String> ele = files[i];
      await downloadChunks(ele['url'], ele['path'], md5: ele.containsKey('md5') ? ele['md5'] : null, onProgress: (double progress) {
        if (onProgress != null) onProgress(i * seg + progress * seg);
      }, onCompleted: (int reason) {
        completedReason = reason;
      });
      if (completedReason != 0) break;
    }
    if (onCompleted != null) onCompleted(completedReason);
  }
}
