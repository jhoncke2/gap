import 'package:flutter/material.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
enum BtnBorderShape{
  Circular,
  Ellyptic
}

class GeneralButton extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final String text;
  final Function onPressed;
  final Color backgroundColor;
  final BtnBorderShape borderShape;
  
  GeneralButton({
    @required this.text,
    @required this.onPressed,
    @required this.backgroundColor,
    this.borderShape = BtnBorderShape.Ellyptic,
    Key key
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: this.backgroundColor,
      shape: _createBtnShape(),
      child: _createButtonText(),    
      onPressed: this.onPressed
    );
  }

  ShapeBorder _createBtnShape(){
    return RoundedRectangleBorder(
      borderRadius: _createBorderRadius(),
      side: BorderSide(
        color: Colors.black26
      )
    );
  }

  BorderRadius _createBorderRadius(){
    if(borderShape == BtnBorderShape.Ellyptic)
      return _createEllipticalBorderRadius();
    else{
      return _createCircularBorderRadius();
    }
  }

  BorderRadius _createEllipticalBorderRadius(){
    return BorderRadius.horizontal(
      left: Radius.elliptical(_sizeUtils.xasisSobreYasis * 0.0275, _sizeUtils.xasisSobreYasis * 0.05),
      right: Radius.elliptical(_sizeUtils.xasisSobreYasis * 0.0275, _sizeUtils.xasisSobreYasis * 0.05)
    );
  }

  BorderRadius _createCircularBorderRadius(){
    return BorderRadius.circular(
      _sizeUtils.xasisSobreYasis * 0.04
    );
  }

  Widget _createButtonText(){
    return Text(
      this.text,
      style: TextStyle(
        color: Colors.white,
        fontSize: _sizeUtils.subtitleSize
      ),
    );
  }
}