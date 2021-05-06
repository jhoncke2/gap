import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
class ScaffoldNativeBackButtonLocker extends StatelessWidget {
  final Widget child;
  ScaffoldNativeBackButtonLocker({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        child: child, 
        onWillPop: ()async{
          return false;
        }
      ),
    );
  }
}