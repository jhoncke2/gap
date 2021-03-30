import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/entities.dart';

abstract class StaticFormField extends CustomFormField{
  FormFieldSubType subType;

  StaticFormField.fromJson({
    Map<String, dynamic> json,
    @required this.subType
  }):
  super(
    type: typeValues.map[json['type']],
    label: json['label']
  );

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = super.toJson();
    json['subtype'] = subType.value;
    return json;
  }
}

class HeaderFormField extends StaticFormField{
  HeaderFormField.fromJson(Map<String, dynamic> json):
    super.fromJson(
      json: json,
      subType: HeaderSubType.fromValue(json['subtype'])
    );
}

class ParagraphFormField extends StaticFormField{
  ParagraphFormField.fromJson(Map<String, dynamic> json):
    super.fromJson(
      json: json,
      subType: ParagraphSubtype.fromValue(json['subtype'])
    );
}

class HeaderSubType extends FormFieldSubType{
  static final List<HeaderSubType> subtypes = [H1, H2, H3, H4, H5, H6];
  HeaderSubType(String value) : super(value);

  static HeaderSubType H1 = HeaderSubType('h1');  
  static HeaderSubType H2 = HeaderSubType('h2');
  static HeaderSubType H3 = HeaderSubType('h3');
  static HeaderSubType H4 = HeaderSubType('h4');
  static HeaderSubType H5 = HeaderSubType('h5');
  static HeaderSubType H6 = HeaderSubType('h6');

  factory HeaderSubType.fromValue(String value){
    return FormFieldSubType.getSubTypeFromValue(value, subtypes);
  }
}

class ParagraphSubtype extends FormFieldSubType{
  static final List<ParagraphSubtype> subtypes = [P, ADDRESS, BLOCKQUOTE, CANVAS, OUTPUT];

  ParagraphSubtype(String value) : super(value);

  static ParagraphSubtype P = ParagraphSubtype('p');
  static ParagraphSubtype ADDRESS = ParagraphSubtype('address');
  static ParagraphSubtype BLOCKQUOTE = ParagraphSubtype('blockquote');
  static ParagraphSubtype CANVAS = ParagraphSubtype('canvas');
  static ParagraphSubtype OUTPUT = ParagraphSubtype('output');

  factory ParagraphSubtype.fromValue(String value){
    return FormFieldSubType.getSubTypeFromValue(value, subtypes);
  }
}