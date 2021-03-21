import 'package:flutter/material.dart';
import 'package:gap/logic/central_manager/pages_navigation_manager.dart';
import 'package:gap/ui/utils/size_utils.dart';
class AppBackButton extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  AppBackButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: _sizeUtils.xasisSobreYasis * 0.05),
      child: IconButton(
        iconSize: _sizeUtils.largeIconSize,
        color: Theme.of(context).primaryColor,
        icon: Icon(
          Icons.arrow_back_ios
        ),
        onPressed: (){
          PagesNavigationManager.pop();
        },
      ),
    );
  }
}