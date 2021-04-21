import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/project.dart';


List<Map<String, dynamic>> projectsToJson(List<ProjectModel> projects) => 
  projects.map(
    (p)=>p.toStorageJson()
  ).toList();

List<ProjectModel> projectsFromJson(List<Map<String, dynamic>> jsonProjects) => 
  jsonProjects.map(
    (jP)=>ProjectModel.fromJson(jP)
  ).toList();

List<ProjectModel> projectsFromRemoteJson(dynamic jsonData){
  List<ProjectModel> projects = [];
  if(jsonData is Map){
    (jsonData.cast<String, Map>()).forEach((key, value){
      projects.add(ProjectModel.fromJson((value.cast<String, dynamic>())));
    });
  }else
    projects = List<ProjectModel>.from(jsonData.map((x) => ProjectModel.fromJson(x)));
  return projects;
} 

class ProjectModel extends Project{
  ProjectModel({
    @required int id,
    @required String nombre
  }):super(
    id: id,
    nombre: nombre,
    visits: []
  );

  factory ProjectModel.fromJson(Map<String, dynamic> json){
    return ProjectModel(
      id: json['id'], 
      nombre: json['nombre'], 
    );
  }

  Map<String, dynamic> toStorageJson()=>{
    'id':this.id,
    'nombre':this.nombre
  };
}