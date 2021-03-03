import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/static/static_form_field.dart';
import 'package:gap/ui/utils/size_utils.dart';
// ignore: must_be_immutable
class HeaderFormFieldWidget extends StatelessWidget {
  
  final double h1FontSizePercentage = 1.075;
  final double h2FontSizePercentage = 1;
  final double h3FontSizePercentage = 0.92;
  final double h4FontSizePercentage = 0.85;
  final double h5FontSizePercentage = 0.8;
  final double h6FontSizePercentage = 0.75;
  
  final SizeUtils _sizeUtils = SizeUtils();
  
  final HeaderFormField headerFormField;
  BuildContext _context;
  @protected
  TextStyle textStyle;

  HeaderFormFieldWidget({
    Key key,
    this.headerFormField
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    _context = context;
    _defineTextStyleBySubtype();
    return Container(
      width: double.infinity,
      //alignment: Alignment.center,
      child: Text(
        headerFormField.label,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        style: textStyle,
      ),
    );
  }

  void _defineTextStyleBySubtype(){
    if(headerFormField.subType == HeaderSubType.H1){
      _defineTextStyle(_sizeUtils.subtitleSize * h1FontSizePercentage, FontWeight.bold);
    }else if(headerFormField.subType == HeaderSubType.H2){
      _defineTextStyle(_sizeUtils.subtitleSize * h2FontSizePercentage, FontWeight.bold);
    }else if(headerFormField.subType == HeaderSubType.H3){
      _defineTextStyle(_sizeUtils.subtitleSize * h3FontSizePercentage, FontWeight.bold);      
    }else if(headerFormField.subType == HeaderSubType.H4){
      _defineTextStyle(_sizeUtils.subtitleSize * h4FontSizePercentage, FontWeight.w800);      
    }else if(headerFormField.subType == HeaderSubType.H5){
      _defineTextStyle(_sizeUtils.subtitleSize * h5FontSizePercentage, FontWeight.w700);      
    }else if(headerFormField.subType == HeaderSubType.H6){
      _defineTextStyle(_sizeUtils.subtitleSize * h6FontSizePercentage, FontWeight.w600);      
    }
  }

  void _defineTextStyle(double fontSize, FontWeight fontWeight){
    textStyle = TextStyle(
      color: Theme.of(_context).primaryColor,
      fontSize: fontSize,
      fontWeight: fontWeight
    );
  }
}