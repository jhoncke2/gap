import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import '../form_fields/static_form_fields/header_form_field_widget.dart';
import '../form_fields/static_form_fields/paragraph_form_field_widget.dart';
import '../form_fields/variable_form_field/multi_value/checkbox_group_form_field_widget.dart';
import '../form_fields/variable_form_field/multi_value/radio_group_form_field_widget.dart';
import '../form_fields/variable_form_field/multi_value/select_form_field_widget.dart';
import '../form_fields/variable_form_field/single_value/date_picker_form_field_widget.dart';
import '../form_fields/variable_form_field/single_value/text_form_field/number_form_field_widget.dart';
import '../form_fields/variable_form_field/single_value/text_form_field/single_text_form_field_widget.dart';
import '../form_fields/variable_form_field/single_value/text_form_field/text_area_form_field_widget.dart';
import '../form_fields/variable_form_field/single_value/time_picker_form_field_widget.dart';

class FormFieldWidgetFactory{
  static Widget createFormFieldWidget(CustomFormFieldOld cff, int fieldPageIndex, StreamController<int> onFieldChangedController, bool isEnabled){
    switch(cff.type){
      case FormFieldTypeOld.HEADER:
        return HeaderFormFieldWidget(headerFormField: cff);
      case FormFieldTypeOld.PARAGRAPH:
        return ParagraphFormFieldWidget(paragraphFormField: cff);
      case FormFieldTypeOld.SINGLE_TEXT:
        return SingleTextFormFieldWidget(uniqueLineText: cff, indexInPage: fieldPageIndex, onChangedController: onFieldChangedController, avaible: isEnabled);
      case FormFieldTypeOld.TEXT_AREA:
        return TextAreaFormFieldWidget(textArea: cff, indexInPage: fieldPageIndex, onChangedController: onFieldChangedController, avaible: isEnabled);
      case FormFieldTypeOld.NUMBER:
        return NumberFormFieldWidget(number: cff, indexInPage: fieldPageIndex, onTappedController: onFieldChangedController, avaible: isEnabled);
      case FormFieldTypeOld.DATE:
        return DatePickerFormFieldWidget(dateFormField: cff, avaible: isEnabled);
      case FormFieldTypeOld.TIME:
        return TimePickerFormFieldWidget(timeFormField: cff, avaible: isEnabled);
      case FormFieldTypeOld.CHECKBOX_GROUP:
        return CheckboxGroupFormFieldWidget(checkBoxGroup: cff, avaible: isEnabled);
      case FormFieldTypeOld.RADIO_GROUP:
        return RadiousGroupFormFieldWidget(radioGroupFormField: cff, avaible: isEnabled);
      case FormFieldTypeOld.SELECT:
        return SelectFormFieldWidget(selectFormField: cff, avaible: isEnabled);
      default:
        return Container();
    }
  }
}