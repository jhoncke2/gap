import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';

class MultiValueWithAlignment extends MultiValueFormField{
  bool inVerticalAlignment;
  MultiValueWithAlignment.fromJson(Map<String, dynamic> json): 
    inVerticalAlignment = json['inline']??false,
    super.fromJson(json)
    ;
  
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['inline'] = inVerticalAlignment;
    return json;
  }

}

class CheckBoxGroup extends MultiValueWithAlignment{
  bool withSwitchType;
  CheckBoxGroup.fromJson(Map<String, dynamic> json) : super.fromJson(json);
  
  Map<String, dynamic> toJson()=>super.toJson();
}

class RadioGroup extends MultiValueWithAlignment{

  RadioGroup.fromJson(Map<String, dynamic> json) : super.fromJson(json);
  Map<String, dynamic> toJson()=>super.toJson();
}