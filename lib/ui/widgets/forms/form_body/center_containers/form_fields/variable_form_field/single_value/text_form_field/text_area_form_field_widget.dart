import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/raw_text_form_field.dart';
import 'package:gap/logic/central_manager/pages_navigation_manager.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/single_value/text_form_field/text_form_field_widget.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/variable_form_field_container.dart';
class TextAreaFormFieldWidget extends TextFormFieldWidget{
  final TextArea textArea;

  TextAreaFormFieldWidget({this.textArea, int indexInPage, StreamController<int> onChangedController}):
    super(key: Key(textArea.name), indexInPage: indexInPage, onTappedController: onChangedController)
    ;

  @override
  Widget build(BuildContext context){
    return VariableFormFieldContainer(
      title: textArea.label, 
      child: _createTextBox()
    );
  }

  Widget _createTextBox(){
    return TextFormField(
      initialValue: textArea.placeholder??textArea.value??'',
      maxLines: textArea.rows,
      minLines: 1,
      maxLength: textArea.maxLength,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(5),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        )
      ),
      onChanged: _onChanged,
      onTap: super.onTap,
    );
  }

  void _onChanged(String newValue){
    textArea.uniqueValue = newValue;
    PagesNavigationManager.updateFormFieldsPage();
  }
}