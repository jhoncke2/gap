import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/static_form_fields/header_form_field_widget.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/static_form_fields/paragraph_form_field_widget.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/multi_value/checkbox_group_form_field_widget.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/multi_value/radio_group_form_field_widget.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/multi_value/select_form_field_widget.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/single_value/date_picker_form_field_widget.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/single_value/number_form_field_widget.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/single_value/single_text_form_field_widget.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/single_value/text_area_form_field_widget.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/variable_form_field/single_value/time_picker_form_field_widget.dart';

class FormFieldWidgetFactory{
  static Widget createFormFieldWidget(CustomFormField cff){
    switch(cff.type){
      case FormFieldType.HEADER:
        return HeaderFormFieldWidget(headerFormField: cff);
      case FormFieldType.PARAGRAPH:
        return ParagraphFormFieldWidget(paragraphFormField: cff);
      case FormFieldType.SINGLE_TEXT:
        return SingleTextFormFieldWidget(uniqueLineText: cff);
      case FormFieldType.TEXT_AREA:
        return TextAreaFormFieldWidget(textArea: cff);
      case FormFieldType.NUMBER:
        return NumberFormFieldWidget(number: cff);
      case FormFieldType.DATE:
        return DatePickerFormFieldWidget(dateFormField: cff);
      case FormFieldType.TIME:
        return TimePickerFormFieldWidget(timeFormField: cff);
      case FormFieldType.CHECKBOX_GROUP:
        return CheckboxGroupFormFieldWidget(checkBoxGroup: cff);
      case FormFieldType.RADIO_GROUP:
        return RadiousGroupFormFieldWidget(radioGroupFormField: cff);
      case FormFieldType.SELECT:
        return SelectFormFieldWidget(selectFormField: cff);
    }
    //TODO: throw err
    return null;
  }
}