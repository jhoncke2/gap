import 'package:gap/clean_architecture_structure/core/data/models/form_fields/custom_form_field_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/form_field/static/static_form_field.dart';

class HeaderFormFieldModel extends StaticFormField implements CustomFormFieldModel{
  HeaderFormFieldModel.fromJson(Map<String, dynamic> json):
  super(
    subType: HeaderSubType.fromValue(json['subtype']),
    type: json['type'],
    label: json['label'],
    other: json['other']
  );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = (super as CustomFormFieldModel).toJson();
    json['subtype'] = subType.value;
    return json;
  }
}

class ParagraphFormFieldModel extends StaticFormField implements CustomFormFieldModel{
  ParagraphFormFieldModel.fromJson(Map<String, dynamic> json):
  super(
    subType: ParagraphSubtype.fromValue(json['subtype']),
    type: json['type'],
    label: json['label'],
    other: json['other']
  );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = (super as CustomFormFieldModel).toJson();
    json['subtype'] = subType.value;
    return json;
  }
}