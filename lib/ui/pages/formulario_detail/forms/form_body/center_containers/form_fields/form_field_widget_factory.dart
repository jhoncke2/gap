import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/entities.dart';
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
  static Widget createFormFieldWidget(CustomFormField cff, int fieldPageIndex, StreamController<int> onFieldChangedController, bool isEnabled){
    switch(cff.type){
      case FormFieldType.HEADER:
        return HeaderFormFieldWidget(headerFormField: cff);
      case FormFieldType.PARAGRAPH:
        return ParagraphFormFieldWidget(paragraphFormField: cff);
      case FormFieldType.SINGLE_TEXT:
        return SingleTextFormFieldWidget(uniqueLineText: cff, indexInPage: fieldPageIndex, onChangedController: onFieldChangedController, avaible: isEnabled);
      case FormFieldType.TEXT_AREA:
        return TextAreaFormFieldWidget(textArea: cff, indexInPage: fieldPageIndex, onChangedController: onFieldChangedController, avaible: isEnabled);
      case FormFieldType.NUMBER:
        return NumberFormFieldWidget(number: cff, indexInPage: fieldPageIndex, onTappedController: onFieldChangedController, avaible: isEnabled);
      case FormFieldType.DATE:
        return DatePickerFormFieldWidget(dateFormField: cff, avaible: isEnabled);
      case FormFieldType.TIME:
        return TimePickerFormFieldWidget(timeFormField: cff, avaible: isEnabled);
      case FormFieldType.CHECKBOX_GROUP:
        return CheckboxGroupFormFieldWidget(checkBoxGroup: cff, avaible: isEnabled);
      case FormFieldType.RADIO_GROUP:
        return RadiousGroupFormFieldWidget(radioGroupFormField: cff, avaible: isEnabled);
      case FormFieldType.SELECT:
        return SelectFormFieldWidget(selectFormField: cff, avaible: isEnabled);
      default:
        return Container();
    }
  }
}