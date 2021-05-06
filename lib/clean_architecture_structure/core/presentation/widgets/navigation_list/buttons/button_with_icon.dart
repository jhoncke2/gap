import 'package:flutter/material.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/navigation_list/buttons/navigation_list_button.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
class ButtonWithIcon extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final String name;
  final Color textColor;
  final IconData icon;
  final Color iconColor;
  final Function onTap;
  ButtonWithIcon({
    @required this.name,
    @required this.textColor,
    @required this.icon,
    @required this.iconColor,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationListButton(
      child: _createButtonChild(),
      textColor: textColor, 
      hasBottomBorder: false, 
      onTap: onTap
    );
  }

  Widget _createButtonChild(){
    return Row(
      children: [
        _createNavItemIcon(),
        SizedBox(width: _sizeUtils.xasisSobreYasis * 0.02),
        _createButtonName(),
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

  Widget _createButtonName(){
    return Text(
      name,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: _sizeUtils.littleTitleSize,
        color: textColor
      ),
    );
  }
}