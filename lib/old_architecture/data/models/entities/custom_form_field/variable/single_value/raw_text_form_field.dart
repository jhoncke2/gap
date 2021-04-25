import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/single_value/single_value_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';

abstract class RawTextFormFieldOld extends SingleValueFormFieldOld{
  static final int defaultMaxLength = 2000;
  int maxLength;

  RawTextFormFieldOld.fromJson(Map<String, dynamic> json):
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

class UniqueLineTextOld extends RawTextFormFieldOld{
  TextSubTypeOld subType;
  UniqueLineTextOld.fromJson(Map<String, dynamic> json):
    subType = json['subtype'] == null? TextSubTypeOld.TEXT : TextSubTypeOld.fromValue(json['subtype']),
    super.fromJson(json)
    ;
  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['subtype'] = subType.value;
    return json;
  }
}

class TextAreaOld extends RawTextFormFieldOld{

  static final defaultNumberOfRows = 5;  
  TextAreaSubTypeOld subType;
  int rows;
  TextAreaOld.fromJson(Map<String, dynamic> json):
    subType = TextAreaSubTypeOld.fromValue(json['subtype']),
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

class TextSubTypeOld extends FormFieldSubTypeOld{
  static final List<TextSubTypeOld> subtypes = [TEXT, PASSWORD, EMAIL, COLOR, TEL];

  TextSubTypeOld(String value) : super(value);

  static TextSubTypeOld TEXT = TextSubTypeOld('text');
  static TextSubTypeOld PASSWORD = TextSubTypeOld('password');
  static TextSubTypeOld EMAIL = TextSubTypeOld('email');
  static TextSubTypeOld COLOR = TextSubTypeOld('color');
  static TextSubTypeOld TEL = TextSubTypeOld('tel');

  factory TextSubTypeOld.fromValue(String value){
    return FormFieldSubTypeOld.getSubTypeFromValue(value, subtypes);
  }
}

class TextAreaSubTypeOld extends FormFieldSubTypeOld{
  static final List<TextAreaSubTypeOld> subtypes = [TEXTAREA];

  TextAreaSubTypeOld(String value) : super(value);

  static TextAreaSubTypeOld TEXTAREA = TextAreaSubTypeOld('textarea');

  factory TextAreaSubTypeOld.fromValue(String value){
    return FormFieldSubTypeOld.getSubTypeFromValue(value, subtypes);
  }
}