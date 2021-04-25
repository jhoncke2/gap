import 'package:flutter/material.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/single_value/single_value_form_field.dart';

import '../../../entities.dart';

class SingleValuePickerFormFieldOld extends SingleValueFormFieldOld{
  SingleValuePickerFormFieldOld.fromJson(Map<String, dynamic> json): 
    super.fromJson(json)
  ;

  Map<String, dynamic> toJson()=>super.toJson();
}

class DateFieldOld extends SingleValuePickerFormFieldOld{

  DateFieldOld.fromJson(Map<String, dynamic>  json) : super.fromJson(json);

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = super.toJson();
    return json;
  }

  DateTime get value => super.uniqueValue == null ? null : transformStringInToDateOld(super.uniqueValue);
  set value(DateTime newDate){
    super.uniqueValue = transformDateInToStringOld(newDate);
  }

  String get valueAsString => super.uniqueValue;

  DateTime get initialDate => super.placeholder == null ? null : transformStringInToDateOld(super.placeholder);
}

class TimeFieldOld extends SingleValuePickerFormFieldOld{

  TimeFieldOld.fromJson(Map<String, dynamic> json) : super.fromJson(json);
  Map<String, dynamic> toJson()=>super.toJson();

  TimeOfDay get value => super.uniqueValue == null? null : transformStringIntoTimeOld(super.uniqueValue);
  set value(TimeOfDay newDuration){
    super.uniqueValue = transformTimeInToStringOld(newDuration);
  }

  String get valueAsString => super.uniqueValue == null? null :  uniqueValue;
}