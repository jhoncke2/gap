import 'dart:io';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Firmer extends Equatable{
  int id;
  String name;
  String identifDocumentType;
  int identifDocumentNumber;
  String cargo;
  File firm;

  Firmer({
    this.id, 
    this.name,
    this.identifDocumentType,
    this.identifDocumentNumber,
    this.cargo,
    this.firm
  });

  Firmer clone() => Firmer(
    id: this.id,
    name: this.name,
    identifDocumentType: this.identifDocumentType,
    identifDocumentNumber: this.identifDocumentNumber,
    cargo: this.cargo,
    firm: this.firm
  );

  @override
  List<Object> get props => [id, name, identifDocumentType, identifDocumentNumber, this.cargo, firm.path];
}