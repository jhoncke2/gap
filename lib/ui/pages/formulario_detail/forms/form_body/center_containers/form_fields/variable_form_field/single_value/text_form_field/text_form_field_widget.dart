import 'dart:async';

import 'package:flutter/material.dart';
class TextFormFieldWidget extends StatelessWidget{
  final StreamController<int> onTappedController;
  final int indexInPage;
  TextFormFieldWidget({Key key, this.onTappedController, this.indexInPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    );
  }

  void onTap(){
    //onTappedController.sink.add(indexInPage);
  }
}