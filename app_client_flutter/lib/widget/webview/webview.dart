import 'dart:convert';
import 'package:client/configure.dart';
import 'package:client/core/event/event.dart';
import 'package:client/core/platform/platform.dart';
import 'package:client/core/service/data.dart';
import 'package:flutter/material.dart';
import 'package:client/core/extension/int_extension.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YZCWebview extends StatefulWidget {
  final String name;
  final String url;
  final String html;
  YZCWebview({Key key, this.name, this.url, this.html}): super(key: key);

  @override
  _YZCWebviewState createState() => _YZCWebviewState();
}

class _YZCWebviewState extends State<YZCWebview> {
  WebViewController _controller;

  JavascriptChannel _jsChannel(BuildContext context) => JavascriptChannel(
    name: "yzc", // 与h5 端的一致 不然收不到消息
    onMessageReceived: (JavascriptMessage msg) async {
      String jsonStr = msg.message;
      print("js: $jsonStr");
      Map d = jsonDecode(jsonStr);
      if (d.containsKey("callback")) {
        await YZCPlatform.jsAPI(d['method'], d['data'], (data) {
          String json = jsonEncode({"callback":d["callback"], "result":data});
          String js = 'if (yzcBridge !== undefined) yzcBridge.onMessage(\'$json\');';
          print("run js: $js");
          _controller.evaluateJavascript(js);
          //fromFlutter("message from Flutter!")
        });
      } else {
        YZCPlatform.jsAPI(d['method'], d['data']);
      }
      //YZCJSBridgeUtil.executeMethod(context, YZCJSBridgeUtil.parseJson(jsonStr));
    });

  String _url;
  String _html;

  void _reloadURL(url) {
    setState(() {
      _html = null;
      _url = url;
    });
    //TipDialog(context, arg);
  }

  void _reloadHTML(html) {
    setState(() {
      _html = html;
      _url = null;
    });
    //TipDialog(context, arg);
  }

  void _executeJS(arg) {
    if (arg['name'] == widget.name) {
      _controller.evaluateJavascript(arg['js']);
    }
  }

  void _goBack(arg) {
    //if (arg == widget.name) {
      _controller.canGoBack().then((yes) {
        if (yes) _controller.goBack();
        else Navigator.of(context).pop();
      });
    //}
  }

  @override
  void initState() {
    super.initState();
    _url = widget.url;
    _html = widget.html;

    YZCEvent.on('webviewReloadUrl', _reloadURL);
    YZCEvent.on('webviewReloadHtml', _reloadHTML);
    YZCEvent.on('webviewExecuteJS', _executeJS);
    YZCEvent.on('webviewGoBack', _goBack);
  }

  @override
  void dispose() {
    YZCEvent.off('webviewReloadUrl', _reloadURL);
    YZCEvent.off('webviewReloadHtml', _reloadHTML);
    YZCEvent.off('webviewExecuteJS', _executeJS);
    YZCEvent.off('webviewGoBack', _goBack);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return WebView(
        //initialUrl: _url,
        javascriptMode: JavascriptMode.unrestricted, // 启用 js交互，默认不启用JavascriptMode.disabled
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          if (_html != null) {
            //print("load html:$_html");
            _controller.loadUrl(Uri.dataFromString(_html, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
          } else if (_url != null) {
            _controller.loadUrl(_url);
          }
        },
        javascriptChannels: <JavascriptChannel>[
          _jsChannel(context) // 与h5 通信
        ].toSet(),
        navigationDelegate: (NavigationRequest request) {
//          if (request.url.startsWith('https://www.youtube.com/')) {
//            print('blocking navigation to $request}');
//            return NavigationDecision.prevent;
//          }
//          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
          _initJavascript();
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
          //_initJavascript();
          _controller?.getTitle().then((title) {
            //print("title:$title");
            YZCEvent.emit("webviewUpdateTitle", title);
          });
        },
        gestureNavigationEnabled: true,
        );
      });
  }

  void evaluateJavascript(String js) {
    _controller.evaluateJavascript(js);
  }

  /*
  static String jsCode = '''
var yzcBridge = {
  ID: 0,
  callbacks: {},
  fixedResults: {},

  call: function(method, args, cb) {
    var ret = {};

    if (typeof args == 'function') {
      cb = args;
      args = {};
    }

    if (this.fixedResults[method] === undefined) {
      var arg = {method: method, data: args === undefined ? {} : args};
      if (typeof cb == 'function') {
        var cbName = 'yzc' + this.ID++;
        this.callbacks[cbName] = cb;
        arg['callback'] = cbName;
      }
      arg = JSON.stringify(arg);
      if (yzc !== undefined) yzc.postMessage(arg);
    } else {
      if (typeof cb == 'function') {
        cb(this.fixedResults[method]);
      }
      return this.fixedResults[method];
    }
    
    return ret;
  },

  onMessage: function(arg) {
    var data = JSON.parse(arg);
    if (data.callback && this.callbacks[data.callback]) {
      this.callbacks[data.callback](data.result);
      delete this.callbacks[data.callback];
    } else if (data.result.key && data.result.value) {
      this.fixedResults[data.result.key] = data.result.value;
    }
  }
};
  ''';
  */
  void _initJavascript() {
    //_controller.evaluateJavascript(jsCode);

//    String json = jsonEncode({"result":{"key":"getUUID", "value":"${YZCData.user.uuid}"}});
//    String js = 'if (yzcBridge !== undefined) yzcBridge.onMessage(\'$json\');';
//    print("run js: $js");
//    _controller.evaluateJavascript(js);
//    json = jsonEncode({"result":{"key":"getUserId", "value":"${YZCData.user.uuid}"}});
//    js = 'if (yzcBridge !== undefined) yzcBridge.onMessage(\'$json\');';
//    print("run js: $js");
//    _controller.evaluateJavascript(js);
//    json = jsonEncode({"result":{"key":"getAppVersion", "value":"${YZCConfigure.appVersion}"}});
//    js = 'if (yzcBridge !== undefined) yzcBridge.onMessage(\'$json\');';
//    print("run js: $js");
//    _controller.evaluateJavascript(js);
//    json = jsonEncode({"result":{"key":"isIphoneX", "value":"0"}});
//    js = 'if (yzcBridge !== undefined) yzcBridge.onMessage(\'$json\');';
//    print("run js: $js");
//    _controller.evaluateJavascript(js);
  }
}
