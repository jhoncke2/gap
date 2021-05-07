import 'package:flutter/material.dart';

DateTime transformStringInToDate(String stringDate){
  final List<String> stringDateParts = stringDate.split('-');
  final int year =  int.parse( stringDateParts[0] );
  final int month =  int.parse( stringDateParts[1] );
  final int day =  int.parse( stringDateParts[2] );
  final DateTime date = DateTime(year, month, day);
  return date;
}

String transformDateInToString(DateTime date){
  return '${date.year}-${_getFormatedDayOrMonthDay(date.month)}-${_getFormatedDayOrMonthDay(date.day)}';
}

String _getFormatedDayOrMonthDay(int value){
  return '${(value<10)?"0":""}$value';
}

TimeOfDay transformStringIntoTime(String stringDuration){
  final List<String> stringDurationParts = stringDuration.split(':');
  final int hour = int.parse(stringDurationParts[0]);
  final int minute = int.parse(stringDurationParts[1]);
  final TimeOfDay time = TimeOfDay(hour: hour, minute: minute);
  return time;
}

String transformTimeInToString(TimeOfDay time){
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