import 'package:flutter/material.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
class AppBackButtonOld extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final bool withLeftMargin;
  final Function onTap;
  AppBackButtonOld({Key key, this.withLeftMargin = true, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: _sizeUtils.xasisSobreYasis * (withLeftMargin? 0.05 : 0.0)),
      child: IconButton(
        iconSize: _sizeUtils.largeIconSize,
        color: Theme.of(context).primaryColor,
        icon: Icon(
          Icons.arrow_back_ios
        ),
        onPressed: this.onTap ?? (){
          PagesNavigationManager.pop();
        },
      ),
    );
  }
}