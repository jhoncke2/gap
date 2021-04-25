import 'package:flutter/material.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';

abstract class StaticFormFieldOld extends CustomFormFieldOld{
  FormFieldSubTypeOld subType;

  StaticFormFieldOld.fromJson({
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

class HeaderFormFieldOld extends StaticFormFieldOld{
  HeaderFormFieldOld.fromJson(Map<String, dynamic> json):
    super.fromJson(
      json: json,
      subType: HeaderSubTypeOld.fromValue(json['subtype'])
    );
}

class ParagraphFormFieldOld extends StaticFormFieldOld{
  ParagraphFormFieldOld.fromJson(Map<String, dynamic> json):
    super.fromJson(
      json: json,
      subType: ParagraphSubtypeOld.fromValue(json['subtype'])
    );
}

class HeaderSubTypeOld extends FormFieldSubTypeOld{
  static final List<HeaderSubTypeOld> subtypes = [H1, H2, H3, H4, H5, H6];
  HeaderSubTypeOld(String value) : super(value);

  static HeaderSubTypeOld H1 = HeaderSubTypeOld('h1');  
  static HeaderSubTypeOld H2 = HeaderSubTypeOld('h2');
  static HeaderSubTypeOld H3 = HeaderSubTypeOld('h3');
  static HeaderSubTypeOld H4 = HeaderSubTypeOld('h4');
  static HeaderSubTypeOld H5 = HeaderSubTypeOld('h5');
  static HeaderSubTypeOld H6 = HeaderSubTypeOld('h6');

  factory HeaderSubTypeOld.fromValue(String value){
    return FormFieldSubTypeOld.getSubTypeFromValue(value, subtypes);
  }
}

class ParagraphSubtypeOld extends FormFieldSubTypeOld{
  static final List<ParagraphSubtypeOld> subtypes = [P, ADDRESS, BLOCKQUOTE, CANVAS, OUTPUT];

  ParagraphSubtypeOld(String value) : super(value);

  static ParagraphSubtypeOld P = ParagraphSubtypeOld('p');
  static ParagraphSubtypeOld ADDRESS = ParagraphSubtypeOld('address');
  static ParagraphSubtypeOld BLOCKQUOTE = ParagraphSubtypeOld('blockquote');
  static ParagraphSubtypeOld CANVAS = ParagraphSubtypeOld('canvas');
  static ParagraphSubtypeOld OUTPUT = ParagraphSubtypeOld('output');

  factory ParagraphSubtypeOld.fromValue(String value){
    return FormFieldSubTypeOld.getSubTypeFromValue(value, subtypes);
  }
}