import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/general_app_scaffold.dart';
class ScaffoldKeyboardDetector extends StatelessWidget {
  final Widget child;
  ScaffoldKeyboardDetector({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GeneralAppScaffold(
      createChild: ()=>GestureDetector(
        child: this.child,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        }
      ),
    );
  }
}