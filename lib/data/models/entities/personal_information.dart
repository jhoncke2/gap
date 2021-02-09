part of 'entities.dart';

class PersonalInformation{
  int id;
  String name;
  String identifDocumentType;
  int identifDocumentNumber;
  File firm;

  PersonalInformation({
    this.id, 
    this.name,
    this.identifDocumentType,
    this.identifDocumentNumber, 
    this.firm
  });
}