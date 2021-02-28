import 'package:flutter/material.dart';
import 'package:gap/ui/utils/size_utils.dart';

class MockApp extends StatelessWidget {
  final SizeUtils sizeUtils = SizeUtils();
  final Widget child;
  MockApp(this.child);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _MockScaffoldWidget(
        child: child,
        sizeUtils: sizeUtils
      ),
      color: Colors.white,
    );
  }
}

class _MockScaffoldWidget extends StatelessWidget {
  final SizeUtils sizeUtils;
  final Widget child;
  _MockScaffoldWidget({Key key, this.child, this.sizeUtils}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    sizeUtils.initUtil(size);
    return Scaffold(
      body: child,
    );
  }
}