import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/raw_text_form_field.dart';
import 'package:gap/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'text_form_field_widget.dart';
// ignore: must_be_immutable
class SingleTextFormFieldWidget extends TextFormFieldWidget {
  static final SizeUtils sizeUtils = SizeUtils();
  final UniqueLineText uniqueLineText;
  TextInputType keyboardType;
  bool obscureText;

  SingleTextFormFieldWidget({Key key, this.uniqueLineText, bool avaible, int indexInPage, StreamController<int> onChangedController}): 
    super(key: Key(uniqueLineText.name), indexInPage: indexInPage, onTappedController: onChangedController, avaible: avaible)
    ;
  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: sizeUtils.xasisSobreYasis * 0.0175),
      child: _createTextField(context),
    );
  }

  Widget _createTextField(BuildContext context){
    _defineTextFieldParams();
    return Container(
      child: Column(
        children: [
          Text(uniqueLineText.label),
          SizedBox(height: sizeUtils.xasisSobreYasis * 0.02),
          TextFormField(
            enabled: this.avaible,
            initialValue: uniqueLineText.uniqueValue??uniqueLineText.placeholder,
            decoration: InputDecoration(
              helperText: uniqueLineText.description??'',
              isDense: true,
              border: _createInputBorder(context),
              enabledBorder: _createInputBorder(context)
            ),
            onChanged: onChanged,
          )
        ]
      )
    );
  }

  InputBorder _createInputBorder(BuildContext context){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(sizeUtils.xasisSobreYasis * 0.065),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor.withOpacity(0.525),
        width: 3.5
      )
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
    }else if(uniqueLineText.subType == TextSubType.TEL){
      _defineTelSubtypeConfig();
    }else if(uniqueLineText.subType == TextSubType.COLOR){
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

  void onChanged(String newValue){
    uniqueLineText.uniqueValue = newValue;
    PagesNavigationManager.updateFormFieldsPage();
  }
}