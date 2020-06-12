import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class YZCFile {
  static String writeablePath = "";
  static String cachePath = "";
  static String tmpPath = "";

  static void setWriteablePath(String path) {
    writeablePath = path;
    cachePath = writeablePath + '/cache';
    tmpPath = writeablePath + '/tmp';
  }

  static String fullPath(String file) {
    if (file.startsWith('/')) {
      return file;
    } else {
      return writeablePath + '/' + file;
    }
  }

  static String fullPathCache(String file) {
    if (file.startsWith('/')) {
      return file;
    } else {
      return cachePath + '/' + file;
    }
  }

  static String fullPathTemp(String file) {
    if (file.startsWith('/')) {
      return file;
    } else {
      return tmpPath + '/' + file;
    }
  }

  static bool fileExists(String file) {
    try {
      File f = File(fullPath(file));
      if (f.existsSync()) return true;
    } on FileSystemException {
      return false;
    }
    return false;
  }

  static String md5File(String file) {
    try {
      File f = File(fullPath(file));
      if (f.existsSync()) {
        return md5.convert(f.readAsBytesSync()).toString();
      }
    } on FileSystemException {
    }
    return '';
  }

  static void renameFile(String file, String newName) {
    try {
      File f = File(fullPath(file));
      if (f.existsSync()) {
        f.renameSync(fullPath(newName));
      }
    } on FileSystemException {

    }
  }

  static void deleteFile(String file) {
    try {
      File f = File(fullPath(file));
      if (f.existsSync()) f.deleteSync();
    } on FileSystemException  {
      return;
    }
  }

  static String loadString(String file) {
    try {
      File f = File(fullPath(file));
      return f.readAsStringSync();
    } on FileSystemException  {
      return '';
    }
  }

  static Map<String, dynamic> loadJSON(String file) {
    try {
      File f = File(fullPath(file));
      if (f.existsSync()) {
        return json.decode(f.readAsStringSync());
      } else {
        return {};
      }
    } on FileSystemException  {
      return {};
    }
  }

  static void saveString(String file, String data) {
    try {
      File f = File(fullPath(file));
      f.writeAsStringSync(data);
    } on FileSystemException  {
    }
  }

  static void saveJSON(String file, Map<String, dynamic> data) {
    saveString(file, json.encode(data));
  }
}
