import 'package:gap/utils/size_utils.dart';
import 'package:gap/widgets/navigation_list/button/navigation_list_button.dart';
import 'package:flutter/material.dart';
// ignore: must_be_immutable
class ButtonWithIcon extends NavigationListButton{
  final SizeUtils _sizeUtils = SizeUtils();
  final IconData icon;
  final Color iconColor;
  ButtonWithIcon({
    @required String name,
    @required Color textColor,
    @required this.icon,
    @required this.iconColor,
    @required Function onTap,
  }):super(
    name: name,
    textColor: textColor,
    hasBottomBorder: false,
    onTap: onTap
  );

  @override
  Widget createButtonChild(){
    return Row(
      children: [
        _createNavItemIcon(),
        SizedBox(width: _sizeUtils.xasisSobreYasis * 0.02),
        createButtonName(),
      ],
    );
  }

  Widget _createNavItemIcon(){
    return Icon(
      icon,
      size: _sizeUtils.largeIconSize,
      color: iconColor,
    );
  }

}