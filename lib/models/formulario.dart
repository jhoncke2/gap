import 'package:flutter/material.dart';
import 'package:gap/enums/process_stage.dart';
import 'package:gap/models/EntityWithStages.dart';

class Formulario extends EntityWithStages {
  final int id;
  final Time initHour;
  final List<Map<String, dynamic>> fields;
  
  Formulario.fromJson({Map<String, dynamic> json}):
    this.id = json['id'],
    this.initHour = Time(hour: json['time']['hour'], minute: json['time']['minute']),
    this.fields = json['fields'].cast<Map<String, dynamic>>(),
    super(
      currentStage: (json['step']=='pendiente')? ProcessStage.Pendiente : ProcessStage.Realizada,
      name: json['name']
    );
}

class Time{
  final int hour;
  final int minute;
  Time({
    @required this.hour,
    @required this.minute
  });
}