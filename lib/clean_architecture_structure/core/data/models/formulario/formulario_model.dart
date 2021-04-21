
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'firmer_model.dart';

List<FormularioModel> formulariosFromJson(List<Map<String, dynamic>> jsonData) => List<FormularioModel>.from(jsonData.map((x) => FormularioModel.fromJson(x)));

List<Map<String, dynamic>> formulariosToJson(List<FormularioModel> data) => List<Map<String, dynamic>>.from(data.map((x) => x.toJson()));

// ignore: must_be_immutable
class FormularioModel extends Formulario{
  FormularioModel({
    int id, 
    bool completo, 
    DateTime initialDate, 
    List<FirmerModel> firmers, 
    List<CustomFormField> campos, 
    int formStepIndex, 
    Position initialPosition, 
    Position finalPosition, 
    String nombre
  }) : super(
    id: id, 
    completo: completo, 
    initialDate: initialDate, 
    firmers: firmers, 
    campos: campos, 
    formStepIndex: formStepIndex, 
    initialPosition: initialPosition, 
    finalPosition: finalPosition, 
    nombre: nombre
  );

  factory FormularioModel.fromJson(Map<String, dynamic> json) => FormularioModel(
    id: json["formulario_pivot_id"],
    completo: json["completo"],
    nombre: json["nombre"],
    campos: customFormFieldsFromJson(json['campos']),
    formStepIndex: _getStepIndexFromJson(json),
    initialDate: DateTime.now(),
    firmers: firmersFromJson((json['firmers']??[]).cast<Map<String, dynamic>>()),
    initialPosition: json['initial_position'] == null? null : _positionFromJson(json['initial_position']),
    finalPosition: json['final_position'] == null? null: _positionFromJson(json['final_position'])
  );

  static int _getStepIndexFromJson(Map<String, dynamic> json){
    //if(json['form_step_index'] == 'on_form')
    //  json['form_step_index'] = 'on_form_filling_out';
    return (json['completo'])? stepsInOrder.length-1 : (json['form_step_index'] == null)? 1 : json['form_step_index'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = {
      'formulario_pivot_id' : id,
      'nombre' : name,
      'completo' : completo,
      'firmers' : firmersToJson(firmers??[]),
      'campos' : customFormFieldsToJson(campos),
      //'form_step_index' : formStepValues.reverse[ stepsInOrder[_getIndexForJson()] ],
      'form_step_index': _getIndexForJson(),
      'initial_position' : initialPosition == null? null : _getPositionToJson(initialPosition),
      'final_position' : finalPosition == null? null : _getPositionToJson(finalPosition)
    };
    json.removeWhere((key, value) => value == null);
    return json;
  }

  int _getIndexForJson(){
    return (stepsInOrder[formStepIndex] == FormStep.OnFirstFirmerFirm)? formStepIndex-1 : formStepIndex;
  }

  static Map<String, dynamic> _getPositionToJson(Position p)=>{
    'latitud':p.latitude,
    'longitud':p.longitude
  };

  static Position _positionFromJson(Map<String, dynamic> jsonP)=>Position(
    latitude: (jsonP['latitud'] as num).toDouble(),
    longitude: (jsonP['longitud'] as num).toDouble()
  );
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