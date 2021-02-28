// To parse this JSON data, do
//
//     final customFormField = customFormFieldFromJson(jsonString);

part of '../entities.dart';

List<CustomFormField> customFormFieldsFromJsonString(String str) => List<CustomFormField>.from(json.decode(str).map((x) => CustomFormField.fromJson(x)));

String customFormFieldsToJson(List<CustomFormField> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomFormField {
    CustomFormField({
        this.type,
        this.label,
        this.other,
    });

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
          return Number.fromJson(json);
        case FormFieldType.DATE:
          return DateField.fromJson(json);
        case FormFieldType.TIME:
          return TimeField.fromJson(json);
        case FormFieldType.CHECKBOX_GROUP:
          return CheckBoxGroup.fromJson(json);
        case FormFieldType.RADIO_GROUP:
          return RadioGroup.fromJson(json);
        case FormFieldType.SELECT:
          return Select.fromJson(json);
      }
      return null;
    }

    Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "label": label,
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

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}

class FormFieldSubType extends Enum<String>{
  FormFieldSubType(String value) : super(value);

  static FormFieldSubType getSubTypeFromValue(String value, List<FormFieldSubType> subTypes){
    for(FormFieldSubType item in subTypes)
      if(item.value == value)
        return item;
    return null;
  }
}