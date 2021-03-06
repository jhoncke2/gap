import 'package:flutter/material.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
class UnloadedNavItems extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.02, vertical: _sizeUtils.xasisSobreYasis * 0.01),
      child: Container(   
        height: _sizeUtils.xasisSobreYasis * 0.35,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(_sizeUtils.xasisSobreYasis * 0.015)
        ),
      ),
    );
  }
}