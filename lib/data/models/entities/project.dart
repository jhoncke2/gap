// To parse this JSON data, do
//
//     final project = projectFromJson(jsonString);

part of 'entities.dart';

List<Project> projectsFromJson(List<Map> jsonData) => List<Project>.from(jsonData.map((x) => Project.fromJson(x)));

String projectsToJson(List<Project> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Project {
    Project({
        this.id,
        this.nombre,
        this.visits,
    });

    int id;
    String nombre;
    List<Visit> visits;

    factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["id"],
        nombre: json["nombre"],
        visits: json["visitas"] != [] ? visitsFromJson(json["visitas"]) : [],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "visitas": visits,
    };
}

class VisitasClass {
    VisitasClass();

    factory VisitasClass.fromJson(Map<String, dynamic> json) => VisitasClass(
    );

    Map<String, dynamic> toJson() => {
    };
}
