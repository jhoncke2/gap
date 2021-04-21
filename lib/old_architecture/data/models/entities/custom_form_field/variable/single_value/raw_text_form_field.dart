import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/single_value/single_value_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';

abstract class RawTextFormField extends SingleValueFormField{
  static final int defaultMaxLength = 2000;
  int maxLength;

  RawTextFormField.fromJson(Map<String, dynamic> json):
    maxLength = json['maxlength']??defaultMaxLength,
    super.fromJson(json)
    ;

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['maxlength'] = maxLength;
    return json;
  }

  String get value => super.uniqueValue;
  set value(String newValue){
    super.uniqueValue = newValue;
  }
}

class UniqueLineText extends RawTextFormField{
  TextSubType subType;
  UniqueLineText.fromJson(Map<String, dynamic> json):
    subType = json['subtype'] == null? TextSubType.TEXT : TextSubType.fromValue(json['subtype']),
    super.fromJson(json)
    ;
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['subtype'] = subType.value;
    return json;
  }
}

class TextArea extends RawTextFormField{

  static final defaultNumberOfRows = 5;  
  TextAreaSubType subType;
  int rows;
  TextArea.fromJson(Map<String, dynamic> json):
    subType = TextAreaSubType.fromValue(json['subtype']),
    rows = json['rows']??defaultNumberOfRows,
    super.fromJson(json)
    ;
    
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['subtype'] = subType.value;
    json['rows'] = rows;
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