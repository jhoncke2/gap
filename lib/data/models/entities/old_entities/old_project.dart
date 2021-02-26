part of '../entities.dart';

class OldProjects{
  List<OldProject> projects;

  OldProjects({
    @required this.projects
  });

  OldProjects.fromJson(List<Map<String, dynamic>> json){
    projects = [];
    json.forEach((Map<String, dynamic> projectAsJson) {
      projects.add(OldProject.fromJson(projectAsJson));
    });
  }

  List<Map<String, dynamic>> toJson() => projects.map<Map<String, dynamic>>(
    (OldProject p)=>p.toJson()
  ).toList();
}

class OldProject extends Entity{
  final String name;

  OldProject.fromJson(Map<String, dynamic> json):
    this.name = json['name'],
    super(id: json['id'])
    ;

  Map<String, dynamic> toJson() => {
    'id':this.id,
    'name':this.name
  };

}