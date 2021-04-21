part of 'entities.dart';


List<ProjectOld> projectsFromJson(dynamic jsonData){
  List<ProjectOld> projects = [];
  if(jsonData is Map){
    (jsonData.cast<String, Map>()).forEach((key, value){
      projects.add(ProjectOld.fromJson((value.cast<String, dynamic>())));
    });
  }else
    projects = List<ProjectOld>.from(jsonData.map((x) => ProjectOld.fromJson(x)));
  return projects;
} 

List<Map<String, dynamic>> projectsToJson(List<ProjectOld> data) => List<Map<String, dynamic>>.from(data.map((x) => x.toJson()));

class ProjectOld extends Entity{
  int id;
  String nombre;
  List<VisitOld> visits;

  ProjectOld({
    this.id,
    this.nombre,
    this.visits,
  });

  factory ProjectOld.fromJson(Map<String, dynamic> json) => ProjectOld(
    id: json["id"],
    nombre: json["nombre"],
    visits: json["visitas"] != [] ? visitsFromJson(json["visitas"]) : [],
  );
    
  Map<String, dynamic> toJson() => {
    'id':this.id,
    'nombre':this.nombre,
    'visitas':visitsToJson(visits)
  };

}