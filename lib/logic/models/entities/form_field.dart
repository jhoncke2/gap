import 'package:flutter/material.dart';

enum InputType{
  TextField,
  Select,
}

class FormFields{
  List<FormField> formsFields;
  FormFields.fromJson(List<Map<String, dynamic>> fields){
    this.formsFields = fields.map<FormField>(
      (Map<String, dynamic> field) => FormField.fromJson(field)
    ).toList();
  }
}

class FormField{
  int id;
  String name;
  InputType type;
  bool isFilled;
  String currentValue;

  FormField({
    @required this.id, 
    @required this.name, 
    @required this.type
  }):
    this.isFilled = false
    ;

  FormField.fromJson(Map<String, dynamic> json):
    this.id = json['id'],
    this.name = json['name']
  {
    _defineType(json['type']);
    this.isFilled = false;
  }
  
  void _defineType(String type){
    switch(type){
      case 'input':
        this.type = InputType.TextField;
        break;
      case 'select':
        this.type = InputType.Select;
        break;
    }
  }
}