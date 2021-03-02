import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/static/static_form_field.dart';
import 'package:gap/ui/utils/size_utils.dart';
// ignore: must_be_immutable
class HeaderFormFieldWidget extends StatelessWidget {
  
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
      _defineTextStyle(_sizeUtils.subtitleSize * 1.075, FontWeight.bold);
    }else if(headerFormField.subType == HeaderSubType.H2){
      _defineTextStyle(_sizeUtils.subtitleSize, FontWeight.bold);
    }
    else if(headerFormField.subType == HeaderSubType.H3){
      _defineTextStyle(_sizeUtils.subtitleSize * 0.925, FontWeight.bold);      
    }
    else if(headerFormField.subType == HeaderSubType.H4){
      _defineTextStyle(_sizeUtils.subtitleSize * 0.85, FontWeight.w800);      
    }
    else if(headerFormField.subType == HeaderSubType.H5){
      _defineTextStyle(_sizeUtils.subtitleSize * 0.8, FontWeight.w700);      
    }
    else if(headerFormField.subType == HeaderSubType.H6){
      _defineTextStyle(_sizeUtils.subtitleSize * 0.75, FontWeight.w600);      
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