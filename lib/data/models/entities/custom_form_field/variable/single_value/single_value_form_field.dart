import 'package:gap/data/models/entities/custom_form_field/variable/variable_form_field.dart';

class SingleValueFormField extends VariableFormField{
  String value;
  
  SingleValueFormField.fromJson(Map<String, dynamic> json):
    value = json['value'],
    super.fromJson(json)
    ;

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['value'] = value;
    return json;
  }
}