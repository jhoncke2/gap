import 'package:flutter/material.dart';

class Formulario{
  final int id;
  final String title;
  final Time initHour;
  final List<Map<String, dynamic>> fields;
  
  Formulario.fromJson({Map<String, dynamic> json}):
    this.id = json['id'],
    this.title = json['title'],
    this.initHour = Time(hour: json['time']['hour'], minute: json['time']['minute']),
    this.fields = json['fields'].cast<Map<String, dynamic>>()
    ;
}

class Time{
  final int hour;
  final int minute;
  Time({
    @required this.hour,
    @required this.minute
  });
}