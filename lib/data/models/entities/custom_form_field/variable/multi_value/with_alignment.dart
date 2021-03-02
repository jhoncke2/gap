import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';

class MultiValueWithAlignment extends MultiValueFormField{
  bool withVerticalAlignment;
  bool other;
  MultiValueWithAlignment.fromJson(Map<String, dynamic> json): 
    withVerticalAlignment = json['inline']??false,
    other = json['other'],
    super.fromJson(json)
    ;
  
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['inline'] = withVerticalAlignment;
    json['other'] = other;
    return json;
  }
}

class CheckBoxGroup extends MultiValueWithAlignment{
  bool withSwitchType;
  
  CheckBoxGroup.fromJson(Map<String, dynamic> json): 
    withSwitchType = json['toggle'],
    super.fromJson(json)
    ;
  
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['toggle'] = withSwitchType;
    return json;
  }
}

class RadioGroupFormField extends MultiValueWithAlignment{

  RadioGroupFormField.fromJson(Map<String, dynamic> json) : super.fromJson(json);
  Map<String, dynamic> toJson()=>super.toJson();
}