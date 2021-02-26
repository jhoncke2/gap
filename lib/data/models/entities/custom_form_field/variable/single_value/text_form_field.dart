import 'package:gap/data/models/entities/custom_form_field/variable/single_value/single_value_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/variable_form_field.dart';
import 'package:gap/data/models/entities/entities.dart';

abstract class TextFormField extends SingleValueFormField{
  int maxLength;

  TextFormField.fromJson(Map<String, dynamic> json):
    maxLength = json['maxlength'],
    super.fromJson(json)
    ;

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['maxlength'] = maxLength;
    return json;
  }
}

class SingleText extends VariableFormField{
  TextSubType subType;
  SingleText.fromJson(Map<String, dynamic> json):
    subType = TextSubType.fromValue(json['subtype']),
    super.fromJson(json)
    ;
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['subtype'] = subType.value;
    return json;
  }
}

class TextArea extends VariableFormField{
  TextAreaSubType subType;
  int rows;
  TextArea.fromJson(Map<String, dynamic> json):
    subType = TextAreaSubType.fromValue(json['subtype']),
    rows = json['rows'],
    super.fromJson(json)
    ;
    
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['subtype'] = subType.value;
    return json;
  }
}

class TextSubType extends FormFieldSubType{
  static final List<TextSubType> subtypes = [TEXT, PASSWORD, EMAIL, COLOR, TEL];

  TextSubType(String value) : super(value);

  static TextSubType TEXT = TextSubType('text');
  static TextSubType PASSWORD = TextSubType('password');
  static TextSubType EMAIL = TextSubType('email');
  static TextSubType COLOR = TextSubType('color');
  static TextSubType TEL = TextSubType('tel');

  factory TextSubType.fromValue(String value){
    return FormFieldSubType.getSubTypeFromValue(value, subtypes);
  }
}

class TextAreaSubType extends FormFieldSubType{
  static final List<TextAreaSubType> subtypes = [TEXTAREA];

  TextAreaSubType(String value) : super(value);

  static TextAreaSubType TEXTAREA = TextAreaSubType('textarea');

  factory TextAreaSubType.fromValue(String value){
    return FormFieldSubType.getSubTypeFromValue(value, subtypes);
  }
}