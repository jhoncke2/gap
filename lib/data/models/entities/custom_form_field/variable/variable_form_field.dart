import 'package:gap/data/models/entities/entities.dart';

abstract class VariableFormField extends CustomFormField{
  String name;
  bool isRequired;
  String description;

  VariableFormField.fromJson(Map<String, dynamic> json):
  name = json['name'],
  isRequired = json['required']??false,
  description = json['description'],
  super(
    label: json['label'],
    type: typeValues.map[json['type']]
  );

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['name'] = name;
    json['required'] = isRequired;
    json['description'] = description;
    return json;
  }

  bool get isCompleted;
}