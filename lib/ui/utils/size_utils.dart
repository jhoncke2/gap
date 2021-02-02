import 'package:flutter/cupertino.dart';

class SizeUtils{

  static final SizeUtils _instance = SizeUtils._internal();
  SizeUtils._internal();
  factory SizeUtils(){
    return _instance;
  }

  Size size;
  double _xasisYasisProm;
  void initUtil(Size pSize){
    size = pSize;
    _xasisYasisProm = (size.width + size.height)/2;
  }
  double get xasisSobreYasis => _xasisYasisProm;

  Map<String, double> get headerLeftComponentPadding{
    return {
      'top': xasisSobreYasis * 0.015,
      'bottom': xasisSobreYasis * 0.015,
      'left': xasisSobreYasis * 0.04,
      'right': xasisSobreYasis * 0.025
    };
  }

  double get littleHorizontalScaffoldPadding{
    return _xasisYasisProm * 0.045;
  }

  double get normalHorizontalScaffoldPadding{
    return _xasisYasisProm * 0.05;
  }

  double get largeHorizontalScaffoldPadding{
    return _xasisYasisProm * 0.13;
  }

  double get titleSize{
    return _xasisYasisProm * 0.04;
  }

  double get littleTitleSize{
    return _xasisYasisProm * 0.036;
  }

  double get subtitleSize{
    return _xasisYasisProm * 0.0325;
  }

  double get normalTextSize{
    return _xasisYasisProm * 0.0275;
  }

  double get littleTextSize{
    return _xasisYasisProm * 0.022;
  }

  double get normalLabelTextSize{
    return _xasisYasisProm * 0.0345;
  }

  double get littleLabelTextSize{
    return _xasisYasisProm * 0.03;
  }

  double get littleIconSize{
    return _xasisYasisProm * 0.045;
  }

  double get normalIconSize{
    return _xasisYasisProm * 0.055;
  }

  double get largeIconSize{
    return _xasisYasisProm * 0.055;
  }

  double get extraLargeIconSize{
    return _xasisYasisProm * 0.085;
  }
  
  Map<String, double> get largeFlatButtonPadding{
    return {
      'vertical':_xasisYasisProm * 0.003,
      'horizontal':_xasisYasisProm * 0.08
    };
  }

  Map<String, double> get fatLargeFlatButtonPadding{
    return {
      'vertical':_xasisYasisProm * 0.0175,
      'horizontal':_xasisYasisProm * 0.09
    };
  }

  Map<String, double> get shortFlatButtonPadding{
    return {
      'vertical':_xasisYasisProm * 0.0145,
      'horizontal':_xasisYasisProm * 0.045
    };
  }

  double get veryLittleSizedBoxHeigh{
      return _xasisYasisProm * 0.015;
  }

  double get littleSizedBoxHeigh{
    return _xasisYasisProm * 0.03;
  }

  double get normalSizedBoxHeigh{
    return _xasisYasisProm * 0.05;
  }

  double get largeSizedBoxHeigh{
    return _xasisYasisProm * 0.075;
  }

  double get veryMuchLargeSizedBoxHeigh{
    return _xasisYasisProm * 0.12;
  }

  double get giantSizedBoxHeight{
    return _xasisYasisProm * 0.165;
  }
}