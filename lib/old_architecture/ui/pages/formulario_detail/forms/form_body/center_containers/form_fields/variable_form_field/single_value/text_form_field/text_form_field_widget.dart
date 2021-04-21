import 'dart:async';

import 'package:flutter/material.dart';
class TextFormFieldWidget extends StatelessWidget{
  final StreamController<int> onTappedController;
  final int indexInPage;
  final bool avaible;
  TextFormFieldWidget({Key key, this.onTappedController, this.indexInPage, this.avaible = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    );
  }

  void onTap(){
    //onTappedController.sink.add(indexInPage);
  }
}