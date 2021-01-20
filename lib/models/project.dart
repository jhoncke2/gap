class Project{
  final int id;
  final String name;

  Project.fromJson(Map<String, dynamic> json):
    this.id = json['id'],
    this.name = json['name']
    ;

}