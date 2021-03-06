import 'package:flutter/material.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:gap/old_architecture/ui/widgets/header/back_button.dart';
import 'package:gap/old_architecture/ui/widgets/header/logout_button.dart';
// ignore: must_be_immutable
class PageHeaderOld extends StatelessWidget {
  final bool showBackNavButton;
  final bool withTitle;
  final String title;
  final bool titleIsUnderlined;
  final Function onBackButtonTap;

  BuildContext _context;
  SizeUtils _sizeUtils;

  PageHeaderOld({
    this.showBackNavButton = true,
    this.withTitle = false,
    this.title,
    this.titleIsUnderlined = true,
    this.onBackButtonTap
  });

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createTopElement(),
          _createDividerLine(Colors.black87),
          _createDividerLine(Colors.pink),
          //SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
          _createBottomElement()
        ],
      ),
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    _sizeUtils = SizeUtils();
  }

  Widget _createTopElement(){
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _elegirTopLeftElement(),
          LogoutButtonOld()
        ],
      ),
    );
  }

  Widget _elegirTopLeftElement(){
    if(showBackNavButton)
      return AppBackButtonOld(onTap: this.onBackButtonTap);
    else
      return _createEmptyContainer();
  }

  Widget _createEmptyContainer(){
    return Container(
      height: _sizeUtils.largeIconSize / 2,
    );
  }

  Widget _createDividerLine(Color color){
    return Divider(
      color: color,
      thickness: 3,
      height: 3,
    );
  }
  
  Widget _createBottomElement(){
    if(withTitle)
      return _createTitle();
    else
      return Container();
  }

  Widget _createTitle(){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: _sizeUtils.xasisSobreYasis * 0.05),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Theme.of(_context).primaryColor,
          fontSize: _sizeUtils.titleSize,
          fontWeight: FontWeight.bold,
          decoration: (this.titleIsUnderlined)?TextDecoration.underline:null
        ),
      ),
    );
  }
}