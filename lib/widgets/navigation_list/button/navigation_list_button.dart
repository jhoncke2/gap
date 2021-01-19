import 'package:flutter/material.dart';
import 'package:gap/utils/size_utils.dart';
// ignore: must_be_immutable
class NavigationListButton extends StatelessWidget {
  final String name;
  final bool hasBottomBorder;
  final Function onTap;
  BuildContext _context;
  SizeUtils _sizeUtils;
  NavigationListButton({
    Key key,
    @required this.name,
    @required this.hasBottomBorder,
    @required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    initInitialConfiguration(context);
    return createButton();
  }

  @protected
  void initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    _sizeUtils = SizeUtils();
  }

  @protected
  Widget createButton(){
    return MaterialButton(
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _sizeUtils.xasisSobreYasis * 0.01,
          vertical: _sizeUtils.xasisSobreYasis * 0.0225
        ),
        alignment: Alignment.centerLeft, 
        child: createButtonChild(),
        decoration: _createButtonDecoration(),
      ),
      onPressed: onTap,
    );
  }

  @protected
  Widget createButtonChild(){
    return createButtonName();
  }

  @protected
  Widget createButtonName(){
    return Text(
      name,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: _sizeUtils.littleTitleSize,
        color: Theme.of(_context).primaryColor
      ),
    );
  }

  BoxDecoration _createButtonDecoration(){
    final BorderSide bottomBorder = (hasBottomBorder)? 
       BorderSide(
          color: Theme.of(_context).primaryColor.withOpacity(0.75),
          width: 0.75
        )
      : BorderSide(
        color: Colors.transparent
      );
    return BoxDecoration(
      border: Border(
        bottom: bottomBorder
      )
    );
  }
}