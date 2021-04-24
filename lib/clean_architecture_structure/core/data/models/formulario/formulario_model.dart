import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'custom_position.dart';
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
    CustomPositionModel initialPosition, 
    CustomPositionModel finalPosition, 
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
    initialPosition: json['initial_position'] == null? null : CustomPositionModel.fromJson(json['initial_position']),
    finalPosition: json['final_position'] == null? null: CustomPositionModel.fromJson(json['final_position'])
  );

  static int _getStepIndexFromJson(Map<String, dynamic> json){
    return (json['completo'])? stepsInOrder.length-1 : (json['form_step_index'] == null)? 1 : json['form_step_index'];
  }

  FormularioModel copyWith({
    int id, 
    bool completo, 
    DateTime initialDate, 
    List<FirmerModel> firmers, 
    List<CustomFormField> campos, 
    int formStepIndex, 
    CustomPositionModel initialPosition, 
    CustomPositionModel finalPosition, 
    String nombre
  })=>FormularioModel(
    id: id??this.id,
    completo: completo??this.completo,
    initialDate: initialDate??this.initialDate,
    firmers: firmers??this.firmers,
    campos: campos??this.campos,
    formStepIndex: formStepIndex??this.formStepIndex,
    initialPosition: initialPosition??this.initialPosition,
    finalPosition: finalPosition??this.finalPosition,
    nombre: nombre??this.name
  );

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> json = {
      'formulario_pivot_id' : id,
      'nombre' : name,
      'completo' : completo,
      'firmers' : firmersToJson(firmers??[]),
      'campos' : customFormFieldsToJson(campos),
      'form_step_index': _getIndexForJson(),
      'initial_position': initialPosition == null? null : (initialPosition as CustomPositionModel).toJson(),
      'final_position':finalPosition == null? null : (finalPosition as CustomPositionModel).toJson()
    };
    json.removeWhere((key, value) => value == null);
    return json;
  }

  int _getIndexForJson(){
    return (stepsInOrder[formStepIndex] == FormStep.OnFirstFirmerFirm)? formStepIndex-1 : formStepIndex;
  }
}