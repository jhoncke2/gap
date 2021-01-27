import 'package:flutter/material.dart';
import 'package:gap/ui/utils/size_utils.dart';
class Logo extends StatelessWidget {
  final String _logoUrl = 'assets/logos/logo_con_fondo.png';
  final double _heightPercent;
  final double _widthPercent;
  SizeUtils _sizeUtils;
  Logo({
    @required double heightPercent,
    @required double widthPercent
  }):
    _heightPercent = heightPercent,
    _widthPercent = widthPercent
    ;

  @override
  Widget build(BuildContext context) {
    _sizeUtils = SizeUtils();
    return Container(
      child: Image.asset(
        _logoUrl,
        height: _sizeUtils.xasisSobreYasis * _heightPercent,
        width: _sizeUtils.xasisSobreYasis * _widthPercent,
        fit: BoxFit.fill,
      ),
    );
  }
}