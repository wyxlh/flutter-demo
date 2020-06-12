import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'file.dart';
import 'package:path_provider/path_provider.dart';
import '../net/http.dart';
import '../net/net.dart';
import 'package:flutter/material.dart';

class YZCAsset {
  static String _url = 'http://192.168.0.231/yzc/';
  static int updateBaseVersion = 0;

  static void init(String url) {
    _url = url;
  }

  static Future hotUpdate({DownloadProgressCallback onProgress, DownloadCompleted onCompleted}) async {
    //获取并检查远端版本号
    Map<String, dynamic> remoteVersion = await YZCNet.getHttp().get(_url + 'version.json');
    if (!remoteVersion.containsKey('version')) {
      print('hotUpdate: cannot get the remote version.');
      if (onCompleted != null) onCompleted(4);
      return;
    }
    //远端版本号与本地固化版本比较
    if (YZCAsset.updateBaseVersion >= remoteVersion['version']) {
      print('hotUpdate: the remote version is too old.');
      if (onCompleted != null) onCompleted(5);
      return;
    }
    //获取并检查本地版本号
    Map<String, dynamic> localVersion = await YZCFile.loadJSON(YZCFile.fullPathCache('version.json'));
    if (localVersion.containsKey('version') && (localVersion['version'] >= remoteVersion['version'])) {
      print('hotUpdate: the version is not changed.');
      if (onCompleted != null) onCompleted(6);
      return;
    }
    //获取远端文件列表
    Map<String, dynamic> remoteFiles = await YZCNet.getHttp().get(_url + 'files.json');
    if (!remoteFiles.containsKey('files')) {
      print('hotUpdate: cannot get the remote files list.');
      if (onCompleted != null) onCompleted(7);
      return;
    }
    //获取本地文件列表并判断本地文件是否需要删除
    Map<String, dynamic> localFiles = await YZCFile.loadJSON(YZCFile.fullPathCache('files.json'));
    localFiles.forEach((file, md5) async {
      if (!remoteFiles.containsKey(file)) {
        await YZCFile.deleteFile(YZCFile.fullPathCache(file));
      }
    });
    //获取更新文件列表
    List<Map<String, String>> files = List();
    remoteFiles['files'].forEach((file, md5) async {
      if (!localFiles.containsKey(file) || (localFiles[file] != md5)) {
        files.add({"url": _url + file, "path": YZCFile.fullPathCache(file + '_yzc'), "md5":md5});
      }
    });
    //下载更新文件
    if (files.length > 0) {
      //print(files);
      YZCNet.downloadChunksList(files, onProgress: (double progress) async {
        if (onProgress != null) onProgress(progress);
      }, onCompleted: (int reason) async {
        if (reason == 0) {
          int fileCount = files.length;
          for (int i = 0; i < fileCount; ++i) {
            String path = files[i]['path'];
            if (path.endsWith('_yzc')) {
              await YZCFile.renameFile(path, path.substring(0, path.length - 4));
            }
          }
          YZCFile.saveJSON(YZCFile.fullPathCache('version.json'), remoteVersion);
          YZCFile.saveJSON(YZCFile.fullPathCache('files.json'), remoteFiles);
        } else {
          int fileCount = files.length;
          for (int i = 0; i < fileCount; ++i) {
            String path = files[i]['path'];
            await YZCFile.deleteFile(path);
          }
        }
        if (onCompleted != null) onCompleted(reason);
      });
    } else {
      print('hotUpdate: no file can be updated.');
      if (onCompleted != null) onCompleted(5);
    }
  }

  static Image getImage(String path, {double width, double height, fit = BoxFit.cover, scale = 1.0}) {
    File f = File(YZCFile.cachePath + '/' + path);
    if (f.existsSync()) {
      return Image.file(f, width: width, height: height, fit: fit, scale: scale,);
    } else {
      return Image.asset(path, width: width, height: height, fit: fit, scale: scale,);
    }
  }

  static ImageProvider getImageProvider(String path) {
    File f = File(YZCFile.cachePath + '/' + path);
    if (f.existsSync()) {
      return FileImage(f);
    } else {
      return AssetImage(path);
    }
  }
}
