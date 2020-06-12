
import 'package:client/core/event/event.dart';

import '../../configure.dart';
import 'package:flutter/material.dart';
import 'package:client/core/extension/int_extension.dart';
import '../../ui/common/themeTextStyles.dart';
import '../../widget/common/app_bar.dart';
import '../../widget/common/page_frame.dart';
import './webview.dart';

class YZCWebviewPage extends StatefulWidget {
  static const String routeName = '/webviewPage';

  @override
  _YZCWebviewPageState createState() => _YZCWebviewPageState();
}

class _YZCWebviewPageState extends State<YZCWebviewPage> {
  bool _loading = true;
  String _title;
  String _name;
  String _url;
  String _html;

  void _updateTitle(title) {
    setState(() {
      _loading = false;
      if (title != null) _title = title;
    });
  }

  @override
  void initState() {
    super.initState();

    YZCEvent.on('webviewUpdateTitle', _updateTitle);
  }

  @override
  void dispose() {
    YZCEvent.off('webviewUpdateTitle', _updateTitle);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    if (_name == null) {
      if (args.containsKey('name')) _name = args['name'];
    }
    if (_url == null) {
      if (args.containsKey('url')) _url = args['url'];
    }
    if (_title == null) {
      if (args.containsKey('title')) _title = args['title'];
    }
    if (_html == null) {
      if (args.containsKey('html')) _html = args['html'];
    }
//    return WebviewScaffold(
//      appBar: AppBar(title: Text((_title != null) ? _title : '')),
//      url: _url,
//    );
    return YZCPageFrame(
      //appBar: YZCAppBar(mediumItem: Container(width: 250.px, child: Text(_title ?? '', style: ThemeTextStyle.black_0, overflow: TextOverflow.ellipsis,),),),
      body: Stack(
        children: [
          YZCWebview(
            name: _name,
            url: _url,
            html: _html,
          ),
          if (_loading) Center(child: SizedBox( child: CircularProgressIndicator(), height: 44.px, width: 44.px,)),
        ],
      ),
    );
  }
}
