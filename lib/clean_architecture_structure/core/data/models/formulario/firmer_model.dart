// ignore: must_be_immutable
import 'dart:io';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/firmer.dart';

// ignore: must_be_immutable
class FirmerModel extends Firmer{

  FirmerModel({
    int id,
    String name,
    String identifDocumentType,
    int identifDocumentNumber,
    String cargo,
    File firm
  }):super(
    id: id,
    name: name,
    identifDocumentType: identifDocumentType,
    identifDocumentNumber: identifDocumentNumber,
    cargo: cargo,
    firm: firm
  );

  FirmerModel.fromStorageJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    identifDocumentType = json['identif_document_type'];
    identifDocumentNumber = json['identif_document_number'];
    cargo = json['cargo'];
    _convertFirmToFile(json['firm']);
  }

  void _convertFirmToFile(String firmAsString){
    try{
      firm = File(firmAsString);
    }catch(err){
      firm = File('assets/logos/logo_con_fondo.png');
    }
  }
  
  Map<String, dynamic> toStorageJson() => {
    'id':id,    
    'name':name,
    'identif_document_type':identifDocumentType,
    'identif_document_number':identifDocumentNumber,
    'cargo': cargo,
    //TODO: Convertir a data que se pueda desconvertir más tarde
    'firm':firm.path    
  };

  Map<String, String> toServiceJson(){
    Map<String, String> json = {};
    json['nombre'] = name;
    if(identifDocumentNumber != null){
      json['tipo_dc'] = identifDocumentType;      
      json['cc'] = identifDocumentNumber.toString();
    }else
      json['cargo'] = cargo;
    return json;
  }
}

List<FirmerModel> firmersFromJson(List<Map<String, dynamic>> json){
  if(json == null)
    return [];
  final List<FirmerModel> firmers = json.map(
    (Map<String, dynamic> item)=>FirmerModel.fromStorageJson(item)
  ).toList();
  return firmers;
}

List<Map<String, dynamic>> firmersToJson(List<FirmerModel> firmers){
  final List<Map<String, dynamic>> jsonFirmers = firmers.map(
    (FirmerModel fi) => fi.toStorageJson()
  ).toList();
  return jsonFirmers;
}