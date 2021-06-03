import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestreo_model.dart';

class PreloadedDataModel extends Equatable{
  final Map<String, PreloadedProjectModel> projects;
  PreloadedDataModel({
    @required this.projects
  });

  factory PreloadedDataModel.fromJson(Map<String, dynamic> json) =>
    PreloadedDataModel(projects: preloadedProjectsFromJson(json));
  
  Map<String, dynamic> toJson() => preloadedProjectsToJson(this.projects);

  PreloadedVisitModel getVisitData(int projectId, int visitId){
    PreloadedProjectModel project = projects['$projectId'];
    if(project != null)
      return project.visits['$visitId'];
    return null;
  }

  void setVisitData(int projectId, int visitId, List<FormularioModel> formularios, MuestreoModel muestreo){
    PreloadedProjectModel project = projects['$projectId'];
    if(project == null){
      projects['$projectId'] = PreloadedProjectModel(visits: {
        '$visitId': PreloadedVisitModel(formularios: formularios, muestreo: muestreo)
      });
    }else if(project.visits['$visitId'] == null){
      project.visits['$visitId'] = PreloadedVisitModel(formularios: formularios, muestreo: muestreo);
    }
  }

  @override
  List<Object> get props => [this.projects];
}

Map<String, PreloadedProjectModel> preloadedProjectsFromJson(Map<String, dynamic> json) =>
  json.map((key, value) => MapEntry(key, PreloadedProjectModel.fromJson(value)));

Map<String, Map> preloadedProjectsToJson(Map<String, PreloadedProjectModel> projs) =>
  projs.map((key, p) => MapEntry(key, p.toJson()));

class PreloadedProjectModel extends Equatable{
  final Map<String, PreloadedVisitModel> visits;

  PreloadedProjectModel({
    @required this.visits
  });

  factory PreloadedProjectModel.fromJson(Map<String, dynamic> json)=>
    PreloadedProjectModel(visits: preloadedVisitsFromJson(json));

  Map<String, dynamic> toJson() => preloadedVisitsToJson(this.visits);

  @override
  List<Object> get props => [this.visits];
}

Map<String, PreloadedVisitModel> preloadedVisitsFromJson(Map<String, dynamic> json) =>
  json.map((key, value) => MapEntry(key, PreloadedVisitModel.fromJson(value)));

Map<String, Map> preloadedVisitsToJson(Map<String, PreloadedVisitModel> prelVisits) => 
  prelVisits.map((key, v) => MapEntry(key, v.toJson()));

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