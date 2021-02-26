import 'package:gap/data/models/entities/entities.dart';

abstract class VariableFormField extends CustomFormField{
  String name;
  bool isRequired;

  VariableFormField.fromJson(Map<String, dynamic> json):
  name = json['name'],
  isRequired = json['required']??false,
  super(
    label: json['label'],
    type: typeValues.map[json['type']]
  );

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['name'] = name;
    json['required'] = isRequired;
    return json;
  }
}