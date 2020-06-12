import 'package:client/core/event/event.dart';
import 'package:client/core/io/file/asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:client/core/extension/int_extension.dart';
import '../configure.dart';

class YZCGuidePage extends StatefulWidget {
  @override
  _YZCGuidePageState createState() => _YZCGuidePageState();
}

class _YZCGuidePageState extends State<YZCGuidePage> {
  List<Map<String, dynamic>> _pages;
  PageController _controller;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _controller = PageController();

    _pages = [
      {'bg': 'assets/images/guide/guide_one.jpg', 'widget': Container()},
      {'bg': 'assets/images/guide/guide_two.jpg', 'widget': Container()},
      {'bg': 'assets/images/guide/guide_three.jpg', 'widget': Stack(children: [Positioned(
        left: 100.px,
        right: 100.px,
        bottom: 70.px,
        height: 40.px,
        child: RaisedButton(
          onPressed: (){
            YZCEvent.emit('guideOver');
          },
          color: Colors.deepOrangeAccent,
          textColor: Colors.white,
          child: Text('立即体验', style: TextStyle(fontSize: 16.px, fontWeight: FontWeight.w900),),
        ),
      )])},
    ];
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    final TabController controller = DefaultTabController.of(context);
    return Container(
      color: Colors.white,
      child: DefaultTabController(
        length: _pages.length,
        child: Stack(
            children: <Widget>[
              TabBarView(
                children: _pages.map<Widget>((Map<String, dynamic> p) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: YZCAsset.getImageProvider(p['bg']),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: p['widget'],
                  );
                  //return w;
                }).toList(),
              ),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(bottom: 40.px),
                  child: TabPageSelector(controller: controller),
                ),
              ),
            ],
        ),
      ),
    );
  }
}
