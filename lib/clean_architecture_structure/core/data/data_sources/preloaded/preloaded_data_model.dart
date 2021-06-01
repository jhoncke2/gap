import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestreo_model.dart';

class PreloadedDataModel extends Equatable{
  final Map<String, PreloadedProjectModel> projects;
  PreloadedDataModel({
    @required this.projects
  });

  factory PreloadedDataModel.fromJson(Map<String, dynamic> json)=>
    PreloadedDataModel(projects: preloadedProjectsFromJson(json));

  @override
  List<Object> get props => [this.projects];
}

Map<String, PreloadedProjectModel> preloadedProjectsFromJson(Map<String, dynamic> json) =>
  json.map((key, value) => MapEntry(key, PreloadedProjectModel.fromJson(value)));

class PreloadedProjectModel extends Equatable{
  final Map<String, PreloadedVisitModel> visits;

  PreloadedProjectModel({
    @required this.visits
  });

  factory PreloadedProjectModel.fromJson(Map<String, dynamic> json)=>
    PreloadedProjectModel(visits: preloadedVisitsFromJson(json));

  @override
  List<Object> get props => [this.visits];
}

Map<String, PreloadedVisitModel> preloadedVisitsFromJson(Map<String, dynamic> json) =>
  json.map((key, value) => MapEntry(key, PreloadedVisitModel.fromJson(value)));

class PreloadedVisitModel extends Equatable{
  final List<FormularioModel> formularios;
  final MuestreoModel muestreo;

  PreloadedVisitModel({  
    @required this.formularios, 
    @required this.muestreo
  });

  factory PreloadedVisitModel.fromJson(Map<String, dynamic> json)=>PreloadedVisitModel(
    formularios: formulariosFromJson(json['formularios']), 
    muestreo: MuestreoModel.fromJson(json['muestreo'])
  );

  @override
  List<Object> get props => [
    this.formularios,
    this.muestreo
  ];

  Map<String, dynamic> toJson() => {
    'formularios': formulariosToJson(this.formularios),
    'muestreo': this.muestreo.toJson()
  };
}