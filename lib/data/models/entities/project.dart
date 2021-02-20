part of 'entities.dart';

class Projects{
  List<Project> projects;

  Projects({
    @required this.projects
  });

  Projects.fromJson(List<Map<String, dynamic>> json){
    projects = [];
    json.forEach((Map<String, dynamic> projectAsJson) {
      projects.add(Project.fromJson(projectAsJson));
    });
  }

  List<Map<String, dynamic>> toJson() => projects.map<Map<String, dynamic>>(
    (Project p)=>p.toJson()
  ).toList();
}

class Project extends Entity{
  final String name;

  Project.fromJson(Map<String, dynamic> json):
    this.name = json['name'],
    super(id: json['id'])
    ;

  Map<String, dynamic> toJson() => {
    'id':this.id,
    'name':this.name
  };

}