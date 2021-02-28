import 'package:gap/data/models/entities/custom_form_field/variable/variable_form_field.dart';

class SingleValueFormField extends VariableFormField{
  String value;
  String placeholder;
  
  SingleValueFormField.fromJson(Map<String, dynamic> json):
    value = json['value'],
    placeholder = json['placeholder'],
    super.fromJson(json)
    ;

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['value'] = value;
    json['placeholder'] = placeholder;
    return json;
  }

  bool get isCompleted => ![null, ''].contains(value);
}