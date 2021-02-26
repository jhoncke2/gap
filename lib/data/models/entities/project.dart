part of 'entities.dart';


List<Project> projectsFromJson(List<Map> jsonData) => List<Project>.from(jsonData.map((x) => Project.fromJson(x)));

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