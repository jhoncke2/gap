import 'package:flutter/material.dart';
import 'package:gap/clean_architecture_structure/core/helpers/format_transformers.dart';

import '../../custom_form_field.dart';
import 'single_value_form_field.dart';

// ignore: must_be_immutable
class DateField extends SingleValueFormField{

  DateField({
    dynamic uniqueValue,
    String placeholder,
    String name,
    bool isRequired,
    String description,
    FormFieldType type,
    String label,
    bool other, 
  }):super(
    uniqueValue: uniqueValue,       
    placeholder: placeholder,
    name: name,
    isRequired: isRequired,
    description: description,
    type: type,
    label: label,
    other: other,       
  );

  DateTime get value => super.uniqueValue == null ? null : transformStringInToDate(super.uniqueValue);
  set value(DateTime newDate){
    super.uniqueValue = transformDateInToString(newDate);
  }
  String get valueAsString => super.uniqueValue == null? null :  uniqueValue;
  DateTime get initialDate => super.placeholder == null ? null : transformStringInToDate(super.placeholder);
  
}

// ignore: must_be_immutable
class TimeField extends SingleValueFormField{

  TimeField({
    dynamic uniqueValue,
    String placeholder,
    String name,
    bool isRequired,
    String description,
    FormFieldType type,
    String label,
    bool other, 
  }):super(
    uniqueValue: uniqueValue,       
    placeholder: placeholder,
    name: name,
    isRequired: isRequired,
    description: description,
    type: type,
    label: label,
    other: other,       
  );

  TimeOfDay get value => super.uniqueValue == null? null : transformStringIntoTime(super.uniqueValue);
  set value(TimeOfDay newDuration){
    super.uniqueValue = transformTimeInToString(newDuration);
  }
  String get valueAsString => super.uniqueValue == null? null :  uniqueValue;
}