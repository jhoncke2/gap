import 'package:flutter/material.dart';
import 'package:gap/utils/size_utils.dart';
// ignore: must_be_immutable
class NavigationListButton extends StatelessWidget {
  final String name;
  final bool hasBottomBorder;
  final String navigationRoute;
  BuildContext _context;
  SizeUtils _sizeUtils;
  NavigationListButton({
    Key key,
    @required this.name,
    @required this.hasBottomBorder,
    @required this.navigationRoute
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return MaterialButton(
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: _sizeUtils.xasisSobreYasis * 0.01,
          vertical: _sizeUtils.xasisSobreYasis * 0.0225
        ),
        alignment: Alignment.centerLeft,
        
        child: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: _sizeUtils.littleTitleSize,
            color: Theme.of(_context).primaryColor
          ),
        ),
        decoration: _createButtonDecoration(),
      ),
      onPressed: (){
        Navigator.of(_context).pushNamed(navigationRoute);
      },
    );
  }

  BoxDecoration _createButtonDecoration(){
    final BorderSide bottomBorder = (hasBottomBorder)? 
       BorderSide(
          color: Theme.of(_context).primaryColor.withOpacity(0.75),
          width: 0.75
        )
      : BorderSide();
    return BoxDecoration(
      border: Border(
        bottom: bottomBorder
      )
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    _sizeUtils = SizeUtils();
  }
}