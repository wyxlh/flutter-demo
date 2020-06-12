import 'package:flutter/material.dart';
import 'package:client/ui/shared/help.dart';

import 'search_content.dart';

class WFSearchScreen extends StatelessWidget {
  static const String routeName = '/search';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WFSearchContent(),
    );
  }
}
