import 'package:flutter/material.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
// ignore: must_be_immutable
class NavigationListButton extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final Color textColor;
  final bool hasBottomBorder;
  final Widget child;
  final Function onTap;
  BuildContext _context;
  
  NavigationListButton({
    Key key,
    @required this.textColor,
    @required this.hasBottomBorder,
    @required this.child,
    @required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    _context = context;
    return MaterialButton(
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _sizeUtils.xasisSobreYasis * 0.01,
          vertical: _sizeUtils.xasisSobreYasis * 0.0225
        ),
        alignment: Alignment.centerLeft, 
        child: this.child,
        decoration: _createButtonDecoration(),
      ),
      onPressed: onTap,
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