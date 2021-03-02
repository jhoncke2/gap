import 'package:gap/data/models/entities/custom_form_field/variable/single_value/single_value_form_field.dart';

class NumberFormField extends SingleValueFormField{

  static final int defaultStep = 1;
  int max;
  int min;
  int step;

  NumberFormField.fromJson(Map<String, dynamic> json):
    max = json['max'],
    min = json['min'],
    step = json['step']??defaultStep,
    super.fromJson(json){
      if(this.value == null && this.placeholder != null)
        this.value = int.parse(this.placeholder);
    }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['max'] = max;
    json['min'] = min;
    json['step'] = step;
    return json;
  }

  int get value => super.uniqueValue == null? null : int.parse(super.uniqueValue);
  set value(int newValue){
    super.uniqueValue = newValue.toString();
  }
}