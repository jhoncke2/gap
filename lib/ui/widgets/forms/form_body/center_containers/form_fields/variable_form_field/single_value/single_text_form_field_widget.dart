import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/raw_text_form_field.dart';
import 'package:gap/logic/central_manager/pages_navigation_manager.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/firm_fields/text_field/text_field_with_name.dart';
// ignore: must_be_immutable
class SingleTextFormFieldWidget extends StatelessWidget {

  final UniqueLineText uniqueLineText;
  TextInputType keyboardType;
  bool obscureText;
  SingleTextFormFieldWidget({Key key, this.uniqueLineText}) : super(key: Key(uniqueLineText.name));
  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _createTextField(),
    );
  }

  Widget _createTextField(){
    _defineTextFieldParams();
    return TextFieldWithName(
      fieldName: uniqueLineText.label,
      initialValue: uniqueLineText.placeholder,
      helperText: uniqueLineText.description,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onFieldChanged: _onChanged,
    );
  }

  void _defineTextFieldParams(){
    obscureText = false;
    _defineKeyboardTypeByTextSubType();
  }

  void _defineKeyboardTypeByTextSubType(){
    if(uniqueLineText.subType == TextSubType.TEXT){
      _defineKeyboardTypeAsText();
    }else if(uniqueLineText.subType == TextSubType.EMAIL){
      _defineEmailSubtypeConfig();
    }else if(uniqueLineText.subType == TextSubType.PASSWORD){
      _definePasswordSubtypeConfig();   
    }
    else if(uniqueLineText.subType == TextSubType.TEL){
      _defineTelSubtypeConfig();
    }
    else if(uniqueLineText.subType == TextSubType.COLOR){
      _defineKeyboardTypeAsText();   
    }
  }

  void _defineKeyboardTypeAsText(){
    keyboardType = TextInputType.text;
  }

  void _defineEmailSubtypeConfig(){
    keyboardType = TextInputType.emailAddress;
  }

  void _definePasswordSubtypeConfig(){
    _defineKeyboardTypeAsText();
    obscureText = true;
  }

  void _defineTelSubtypeConfig(){
    keyboardType = TextInputType.phone;
  }

  void _onChanged(String newValue){
    uniqueLineText.uniqueValue = newValue;
    PagesNavigationManager.updateFormFieldsPage();
  }
}