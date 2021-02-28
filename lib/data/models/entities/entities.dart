import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/static/static_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/select.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/with_alignment.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/number.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/single_value_picker_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/text_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/variable_form_field.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';

part 'entity.dart';
part 'project.dart';
part 'entity_with_stages.dart';
part 'visit.dart';
part 'formulario.dart';
part 'old_entities/old_custom_form_field.dart';
part 'personal_information.dart';
part 'commented_image.dart';
part 'custom_form_field/custom_form_field.dart';
part 'formulario_temp.dart';
part 'visit_temp.dart';


//Date format: yyyy-mm-dd
DateTime _transformStringInToDate(String stringDate){
  final List<String> stringDateParts = stringDate.split('-');
  final int year =  int.parse( stringDateParts[0] );
  final int month =  int.parse( stringDateParts[1] );
  final int day =  int.parse( stringDateParts[2] );
  final DateTime date = DateTime(year, month, day);
  return date;
}

String _transformDateInToString(DateTime date){
  return '${date.year}-${date.month}-${date.day}';
}




