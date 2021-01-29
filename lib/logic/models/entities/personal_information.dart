import 'package:flutter/material.dart';
import 'dart:io';

class PersonalInformation{
  final int id;
  final String name;
  final String idDocumentType;
  final int idDocumentNumber;
  final File firm;

  PersonalInformation({
    @required this.id, 
    @required this.name,
    @required this.idDocumentType,
    @required this.idDocumentNumber, 
    @required this.firm
  });
}