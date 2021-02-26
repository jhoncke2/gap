// To parse this JSON data, do
//
//     final customFormField = customFormFieldFromJson(jsonString);

part of '../entities.dart';

List<CustomFormField> customFormFieldsFromJsonString(String str) => List<CustomFormField>.from(json.decode(str).map((x) => CustomFormField.fromJsonOld(x)));

String customFormFieldsToJson(List<CustomFormField> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomFormField {
    CustomFormField({
        this.type,
        this.isRequired,
        this.label,
        this.toggle,
        this.inline,
        this.name,
        this.other,
        this.values,
        this.multiple,
        this.min,
        this.max,
        this.step,
        this.oldSubType,
        this.maxlength,
        this.rows,
        this.value,
        this.placeholder,
        this.description,
    });

    FormFieldType type;
    bool isRequired;
    String label;
    bool toggle;
    bool inline;
    String name;
    bool other;
    List<Value> values;
    bool multiple;
    int min;
    int max;
    int step;
    OldFormFieldSubType oldSubType;
    int maxlength;
    int rows;
    String value;
    String placeholder;
    String description;

    factory CustomFormField.fromJsonOld(Map<String, dynamic> json){
      final FormFieldType type = typeValues.map[json['type']];
      switch(type){
        case FormFieldType.HEADER:
          return HeaderFormField.fromJson(json);
        case FormFieldType.PARAGRAPH:
          return ParagraphFormField.fromJson(json);
        case FormFieldType.SINGLE_TEXT:
          return SingleText.fromJson(json);
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

    CustomFormField.fromJson(Map<String, dynamic> json){
        this.type = typeValues.map[ json["type"] ];
        //this.isRequired = json["required"] ?? false;
        this.label = json["label"];
        this.toggle = json["toggle"] ?? null;
        //this.inline = json["inline"] ?? null;
        //this.name = json["name"] ?? null;
        //this.other = json["other"] ?? null;
        //this.values = json["values"] == null ? null : List<Value>.from(json["values"].map((x) => Value.fromJson(x)));
        //this.multiple = json["multiple"] ?? null;
        //this.min = json["min"] ?? null;
        //this.max = json["max"] ?? null;
        //this.step = json["step"] ?? null;
        //this.oldSubType = json["subtype"] == null ? null : subtypeValues.map[json['subtype']];
        //this.maxlength = json["maxlength"] ?? null;
        //this.rows = json["rows"] ?? null;
        //this.value = json["value"] ?? null;
        //this.placeholder = json["placeholder"] ?? null;
        //this.description = json["description"] ?? null;
    
    }

    Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        //"required": isRequired,
        "label": label,
        "toggle": toggle,
        //"inline": inline,
        //"name": name,
        //"other": other,
        //"values": values == null ? null : List<dynamic>.from(values.map((x) => x.toJson())),
        //"multiple": multiple,
        //"min": min,
        //"max": max,
        //"step": step,
        //"subtype": oldSubType == null ? null : subtypeValues.reverse[oldSubType],
        //"maxlength": maxlength,
        //"rows": rows,
        //"value": value,
        //"placeholder": placeholder ?? null,
        //"description": description,
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
                        //Header                //Paragraph                            //TextArea //Text
enum OldFormFieldSubType { H1, H2, H3, H4, H5, H6, P, ADDRESS, BLOCKQUOTE, CANVAS, OUTPUT, TEXTAREA, TEXT, PASSWORD, EMAIL, COLOR, TEL }

final subtypeValues = EnumValues({
    "h1": OldFormFieldSubType.H1,
    "h2": OldFormFieldSubType.H2,
    "h3": OldFormFieldSubType.H3,
    "h4": OldFormFieldSubType.H4,
    "h5": OldFormFieldSubType.H5,
    "h6": OldFormFieldSubType.H6,
    "p": OldFormFieldSubType.P,
    "address": OldFormFieldSubType.ADDRESS,
    "blockquote": OldFormFieldSubType.BLOCKQUOTE,
    "canvas": OldFormFieldSubType.CANVAS,
    "output": OldFormFieldSubType.OUTPUT,
    "textarea": OldFormFieldSubType.TEXTAREA,
    "text": OldFormFieldSubType.TEXT,
    "password": OldFormFieldSubType.PASSWORD,
    "email": OldFormFieldSubType.EMAIL,
    "color": OldFormFieldSubType.COLOR,
    "tel": OldFormFieldSubType.TEL,
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