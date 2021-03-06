import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/static/static_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/multi_value/select.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/multi_value/with_alignment.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/single_value/number_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/single_value/single_value_picker_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/single_value/raw_text_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/variable_form_field.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:geolocator/geolocator.dart';

part 'entity.dart';
part 'project.dart';
part 'entity_with_stages.dart';
part 'visit.dart';
part 'formulario.dart';
part 'personal_information.dart';
part 'commented_image.dart';
part 'custom_form_field/custom_form_field.dart';

//Date format: yyyy-mm-dd
DateTime transformStringInToDateOld(String stringDate){
  final List<String> stringDateParts = stringDate.split('-');
  final int year =  int.parse( stringDateParts[0] );
  final int month =  int.parse( stringDateParts[1] );
  final int day =  int.parse( stringDateParts[2] );
  final DateTime date = DateTime(year, month, day);
  return date;
}

String transformDateInToStringOld(DateTime date){
  return '${date.year}-${_getFormatedDayOrMonthDayOld(date.month)}-${_getFormatedDayOrMonthDayOld(date.day)}';
}

String _getFormatedDayOrMonthDayOld(int value){
  return '${(value<10)?"0":""}$value';
}

/*
DateTime transformStringInToTime(String stringTime){
  final List<String> stringTimeParts = stringTime.split(':');
  final int hour = int.parse(stringTimeParts[0]);
  final int minute = int.parse(stringTimeParts[1]);
  final DateTime nowDate = DateTime.now();
  final DateTime time = DateTime(nowDate.year, nowDate.month, nowDate.day, hour, minute);
  return time;
}

String transformTimeInToString(DateTime time){
  return '${time.hour}:${time.minute}';
}
*/

TimeOfDay transformStringIntoTimeOld(String stringDuration){
  final List<String> stringDurationParts = stringDuration.split(':');
  final int hour = int.parse(stringDurationParts[0]);
  final int minute = int.parse(stringDurationParts[1]);
  final TimeOfDay time = TimeOfDay(hour: hour, minute: minute);
  return time;
}

String transformTimeInToStringOld(TimeOfDay time){
  return '${time.hour}:${time.minute}';
}

class EnumValuesOld<V,T> {
  Map<V, T> map;
  Map<T, V> reverseMap;

  EnumValuesOld(this.map);

  Map<T, V> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}