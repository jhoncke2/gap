import 'package:flutter/material.dart';

enum InputType{
  TextField,
  Select,
}

class FormInput{
  final int id;
  final String name;
  final InputType type;

  FormInput({
    @required this.id, 
    @required this.name, 
    @required this.type}
  );
}