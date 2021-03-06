import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/variable_form_field.dart';

class SingleValueFormFieldOld extends VariableFormFieldOld{
  dynamic uniqueValue;
  String placeholder;
  
  SingleValueFormFieldOld.fromJson(Map<String, dynamic> json):
    uniqueValue = json['value'],
    placeholder = json['placeholder'],
    super.fromJson(json)
    ;

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['value'] = uniqueValue;
    json['placeholder'] = placeholder;
    return json;
  }

  bool get isCompleted => ![null, ''].contains(uniqueValue);
}