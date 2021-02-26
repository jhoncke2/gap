import 'package:gap/data/models/entities/custom_form_field/variable/single_value/single_value_form_field.dart';

class Number extends SingleValueFormField{
  int max;
  int min;
  int step;

  Number.fromJson(Map<String, dynamic> json):
    max = json['max'],
    min = json['min'],
    step = json['step'],
    super.fromJson(json)
    ;

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['max'] = max;
    json['min'] = min;
    json['step'] = step;
    return json;
  }
}