import 'package:flutter/material.dart';
class NativeBackButtonLocker extends StatelessWidget {
  final Widget child;
  const NativeBackButtonLocker({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: child, 
      onWillPop: _onBack
    );
  }

  Future<bool> _onBack()async{
    return false;
  }
}