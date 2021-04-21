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

List<CustomFormField> customFormFieldsFromJson(dynamic rawFormFields){
  if(rawFormFields is String)
    return List<CustomFormField>.from(json.decode(rawFormFields).map((x) => CustomFormField.fromJson(x)));
  else
    return ((rawFormFields as List).cast<Map<String, dynamic>>()).map((formField) => CustomFormField.fromJson(formField)).toList();
}

//TODO: Borrar en su desuso
//String customFormFieldsToJson(List<CustomFormField> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
List<Map<String, dynamic>> customFormFieldsToJson(List<CustomFormField> data) => data.map((x) => x.toJson()).toList();

class CustomFormField {
  CustomFormField({
      this.type,
      String label,
      this.other,
  }):
    this.label = label.replaceAll(RegExp(r'&nbsp;'), ' ')
  ;

  FormFieldType type;
  String label;
  //TODO: Averiguar qué significa
  bool other;
  

  factory CustomFormField.fromJson(Map<String, dynamic> json){
    final FormFieldType type = typeValues.map[json['type']];
    switch(type){
      case FormFieldType.HEADER:
        return HeaderFormField.fromJson(json);
      case FormFieldType.PARAGRAPH:
        return ParagraphFormField.fromJson(json);
      case FormFieldType.SINGLE_TEXT:
        return UniqueLineText.fromJson(json);
      case FormFieldType.TEXT_AREA:
        return TextArea.fromJson(json);
      case FormFieldType.NUMBER:
        return NumberFormField.fromJson(json);
      case FormFieldType.DATE:
        return DateField.fromJson(json);
      case FormFieldType.TIME:
        return TimeField.fromJson(json);
      case FormFieldType.CHECKBOX_GROUP:
        return CheckBoxGroup.fromJson(json);
      case FormFieldType.RADIO_GROUP:
        return RadioGroupFormField.fromJson(json);
      case FormFieldType.SELECT:
        return SelectFormField.fromJson(json);
      default:
        return ParagraphFormField.fromJson(unsupportedFormFieldJson);
    }
  }
 
  Map<String, dynamic> toJson() => {
    "type": typeValues.reverse[type],
    "label": label.replaceAll(RegExp(r' '), '&nbsp;'),
  };
}

enum FormFieldType { HEADER, PARAGRAPH, SINGLE_TEXT, TEXT_AREA, NUMBER, DATE, TIME, CHECKBOX_GROUP, RADIO_GROUP, SELECT}

final typeValues = EnumValues({
  'header':FormFieldType.HEADER,
  'paragraph':FormFieldType.PARAGRAPH,
  'text':FormFieldType.SINGLE_TEXT,
  'textarea':FormFieldType.TEXT_AREA,
  'number':FormFieldType.NUMBER,
  'date':FormFieldType.DATE,
  'time':FormFieldType.TIME,
  'checkbox-group':FormFieldType.CHECKBOX_GROUP,
  'radio-group':FormFieldType.RADIO_GROUP,
  'select':FormFieldType.SELECT
});

class FormFieldSubType extends Enum<String>{
  FormFieldSubType(String value) : super(value);

  static FormFieldSubType getSubTypeFromValue(String value, List<FormFieldSubType> subTypes){
    for(FormFieldSubType item in subTypes)
      if(item.value == value)
        return item;
    return null;
  }
}