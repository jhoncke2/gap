import 'package:gap/data/models/entities/custom_form_field/variable/single_value/single_value_form_field.dart';

class SingleValuePickerFormField extends SingleValueFormField{
  SingleValuePickerFormField.fromJson(Map<String, dynamic> json): 
    super.fromJson(json)
  ;
}

class DateField extends SingleValuePickerFormField{
  DateField.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class TimeField extends SingleValuePickerFormField{
  TimeField.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}