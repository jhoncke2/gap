import 'package:flutter/material.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/static/static_form_field.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
// ignore: must_be_immutable
class ParagraphFormFieldWidget extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final ParagraphFormFieldOld paragraphFormField;
  TextStyle textStyle;
  ParagraphFormFieldWidget({Key key, this.paragraphFormField}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    _defineTextStyleBySubtype();
    return Container(
      width: size.width * 0.8 ,
      child: Text(
        paragraphFormField.label,
        style: textStyle,
      ),
    );
  }

  void _defineTextStyleBySubtype(){
    if(paragraphFormField.subType == ParagraphSubtypeOld.P){
          _defineTextStyle(_sizeUtils.normalTextSize, FontWeight.normal);
    }else if(paragraphFormField.subType == ParagraphSubtypeOld.ADDRESS){
          _defineTextStyle(_sizeUtils.normalTextSize, FontWeight.normal);
    }else if(paragraphFormField.subType == ParagraphSubtypeOld.BLOCKQUOTE){
      _defineTextStyle(_sizeUtils.normalTextSize, FontWeight.normal);      
    }else if(paragraphFormField.subType == ParagraphSubtypeOld.CANVAS){
      _defineTextStyle(_sizeUtils.normalTextSize, FontWeight.normal);      
    }else if(paragraphFormField.subType == ParagraphSubtypeOld.OUTPUT){
      _defineTextStyle(_sizeUtils.normalTextSize, FontWeight.normal);      
    }
  }
  
  void _defineTextStyle(double fontSize, FontWeight fontWeight){
    textStyle = TextStyle(
      color: Colors.black,
      fontSize: fontSize,
      fontWeight: fontWeight
    );
  }
  
  
}