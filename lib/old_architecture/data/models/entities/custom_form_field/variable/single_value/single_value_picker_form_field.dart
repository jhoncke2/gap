import 'package:flutter/material.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/single_value/single_value_form_field.dart';

import '../../../entities.dart';

class SingleValuePickerFormField extends SingleValueFormField{
  SingleValuePickerFormField.fromJson(Map<String, dynamic> json): 
    super.fromJson(json)
  ;

  Map<String, dynamic> toJson()=>super.toJson();
}

class DateField extends SingleValuePickerFormField{

  DateField.fromJson(Map<String, dynamic>  json) : super.fromJson(json);

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = super.toJson();
    return json;
  }

  DateTime get value => super.uniqueValue == null ? null : transformStringInToDate(super.uniqueValue);
  set value(DateTime newDate){
    super.uniqueValue = transformDateInToString(newDate);
  }

  String get valueAsString => super.uniqueValue;

  DateTime get initialDate => super.placeholder == null ? null : transformStringInToDate(super.placeholder);
}

class TimeField extends SingleValuePickerFormField{

  TimeField.fromJson(Map<String, dynamic> json) : super.fromJson(json);
  Map<String, dynamic> toJson()=>super.toJson();

  TimeOfDay get value => super.uniqueValue == null? null : transformStringIntoTime(super.uniqueValue);
  set value(TimeOfDay newDuration){
    super.uniqueValue = transformTimeInToString(newDuration);
  }

  String get valueAsString => super.uniqueValue == null? null :  uniqueValue;
}