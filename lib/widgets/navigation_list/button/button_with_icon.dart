import 'package:gap/widgets/navigation_list/button/navigation_list_button.dart';

import 'package:flutter/material.dart';
class ButtonWithIcon extends NavigationListButton{
  final IconData icon;
  ButtonWithIcon({
    @required String name,
    @required this.icon,
    @required Function onTap
  }):super(
    name: name,
    hasBottomBorder: false,
  );
}