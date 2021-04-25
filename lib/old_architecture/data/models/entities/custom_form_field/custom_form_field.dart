// To parse this JSON data, do
//
//     final customFormField = customFormFieldFromJson(jsonString);

part of '../entities.dart';

final Map<String, dynamic> unsupportedFormFieldJson = {
  'name':'unsuported_input',
  'type':'paragraph',
  'subtype':'p',
  'label':'--tipo de campo no soportado--'
};

List<CustomFormFieldOld> customFormFieldsFromJson(dynamic rawFormFields){
  if(rawFormFields is String)
    return List<CustomFormFieldOld>.from(json.decode(rawFormFields).map((x) => CustomFormFieldOld.fromJson(x)));
  else
    return ((rawFormFields as List).cast<Map<String, dynamic>>()).map((formField) => CustomFormFieldOld.fromJson(formField)).toList();
}

//TODO: Borrar en su desuso
//String customFormFieldsToJson(List<CustomFormField> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
List<Map<String, dynamic>> customFormFieldsToJson(List<CustomFormFieldOld> data) => data.map((x) => x.toJson()).toList();

class CustomFormFieldOld {
  FormFieldTypeOld type;
  String label;
  //TODO: Averiguar qué significa
  bool other;

  CustomFormFieldOld({
      this.type,
      String label,
      this.other,
  }):
    this.label = label.replaceAll(RegExp(r'&nbsp;'), ' ')
  ;

  
  

  factory CustomFormFieldOld.fromJson(Map<String, dynamic> json){
    final FormFieldTypeOld type = typeValues.map[json['type']];
    switch(type){
      case FormFieldTypeOld.HEADER:
        return HeaderFormFieldOld.fromJson(json);
      case FormFieldTypeOld.PARAGRAPH:
        return ParagraphFormFieldOld.fromJson(json);
      case FormFieldTypeOld.SINGLE_TEXT:
        return UniqueLineTextOld.fromJson(json);
      case FormFieldTypeOld.TEXT_AREA:
        return TextAreaOld.fromJson(json);
      case FormFieldTypeOld.NUMBER:
        return NumberFormFieldOld.fromJson(json);
      case FormFieldTypeOld.DATE:
        return DateFieldOld.fromJson(json);
      case FormFieldTypeOld.TIME:
        return TimeFieldOld.fromJson(json);
      case FormFieldTypeOld.CHECKBOX_GROUP:
        return CheckBoxGroupOld.fromJson(json);
      case FormFieldTypeOld.RADIO_GROUP:
        return RadioGroupFormFieldOld.fromJson(json);
      case FormFieldTypeOld.SELECT:
        return SelectFormFieldOld.fromJson(json);
      default:
        return ParagraphFormFieldOld.fromJson(unsupportedFormFieldJson);
    }
  }
 
  Map<String, dynamic> toJson() => {
    "type": typeValues.reverse[type],
    "label": label.replaceAll(RegExp(r' '), '&nbsp;'),
  };
}

enum FormFieldTypeOld { HEADER, PARAGRAPH, SINGLE_TEXT, TEXT_AREA, NUMBER, DATE, TIME, CHECKBOX_GROUP, RADIO_GROUP, SELECT}

final typeValues = EnumValuesOld({
  'header':FormFieldTypeOld.HEADER,
  'paragraph':FormFieldTypeOld.PARAGRAPH,
  'text':FormFieldTypeOld.SINGLE_TEXT,
  'textarea':FormFieldTypeOld.TEXT_AREA,
  'number':FormFieldTypeOld.NUMBER,
  'date':FormFieldTypeOld.DATE,
  'time':FormFieldTypeOld.TIME,
  'checkbox-group':FormFieldTypeOld.CHECKBOX_GROUP,
  'radio-group':FormFieldTypeOld.RADIO_GROUP,
  'select':FormFieldTypeOld.SELECT
});

class FormFieldSubTypeOld extends Enum<String>{
  FormFieldSubTypeOld(String value) : super(value);

  static FormFieldSubTypeOld getSubTypeFromValue(String value, List<FormFieldSubTypeOld> subTypes){
    for(FormFieldSubTypeOld item in subTypes)
      if(item.value == value)
        return item;
    return null;
  }
}