part of 'entities.dart';


List<Project> projectsFromJson(dynamic jsonData){
  List<Project> projects = [];
  if(jsonData is Map){
    (jsonData.cast<String, Map>()).forEach((key, value){
      projects.add(Project.fromJson((value.cast<String, dynamic>())));
    });
  }else
    projects = List<Project>.from(jsonData.map((x) => Project.fromJson(x)));
  return projects;
} 

List<Map<String, dynamic>> projectsToJson(List<Project> data) => List<Map<String, dynamic>>.from(data.map((x) => x.toJson()));

class Project extends Entity{
  int id;
  String nombre;
  List<Visit> visits;

  Project({
    this.id,
    this.nombre,
    this.visits,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
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