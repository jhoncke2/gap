import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';

class SelectFormField extends MultiValueFormField{
  SelectFormField.fromJson(Map<String, dynamic> json) : super.fromJson(json);
  Map<String, dynamic> toJson()=>super.toJson();
}