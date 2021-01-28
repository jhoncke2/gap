import 'package:flutter/material.dart';
import 'dart:io';

class PersonalInformation{
  final int id;
  final String name;
  final int cc;
  final File firm;

  PersonalInformation({
    @required this.id, 
    @required this.name, 
    @required this.cc, 
    @required this.firm
  });
}