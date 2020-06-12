import 'package:flutter/material.dart';

Future TipDialog(BuildContext context, String content, [String title, String confirm]) async {
  return showDialog<int>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title??"提示"),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text(confirm??"确定"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<bool> ConfirmDialog(BuildContext context, String content, [String title, String confirm, String cancel]) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title??"提示"),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text(cancel??"取消"),
            onPressed: () => Navigator.of(context).pop(), // 关闭对话框
          ),
          FlatButton(
            child: Text(confirm??"确定"),
            onPressed: () {
              //关闭对话框并返回true
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
