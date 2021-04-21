import 'dart:io';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Firmer extends Equatable{
  int id;
  String name;
  String identifDocumentType;
  int identifDocumentNumber;
  File firm;

  Firmer({
    this.id, 
    this.name,
    this.identifDocumentType,
    this.identifDocumentNumber, 
    this.firm
  });

  Firmer clone() => Firmer(
    id: this.id,
    name: this.name,
    identifDocumentType: this.identifDocumentType,
    identifDocumentNumber: this.identifDocumentNumber,
    firm: this.firm
  );

  @override
  List<Object> get props => [id, name, identifDocumentType, identifDocumentNumber, firm.path];
}