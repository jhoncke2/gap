import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';

class MultiValueWithAlignmentOld extends MultiValueFormFieldOld{
  bool withVerticalAlignment;
  bool other;
  MultiValueWithAlignmentOld.fromJson(Map<String, dynamic> json): 
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

class CheckBoxGroupOld extends MultiValueWithAlignmentOld{
  bool withSwitchType;
  
  CheckBoxGroupOld.fromJson(Map<String, dynamic> json): 
    withSwitchType = json['toggle'],
    super.fromJson(json)
    ;
  
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['toggle'] = withSwitchType;
    return json;
  }
}

class RadioGroupFormFieldOld extends MultiValueWithAlignmentOld{

  RadioGroupFormFieldOld.fromJson(Map<String, dynamic> json) : super.fromJson(json);
  Map<String, dynamic> toJson()=>super.toJson();
}