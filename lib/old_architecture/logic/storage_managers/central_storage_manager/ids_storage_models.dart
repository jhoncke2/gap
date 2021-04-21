List<StorageIdProject> projectsIdsFromJson(Map<String, dynamic> jsonProjects){
  List<StorageIdProject> projects = [];
  jsonProjects.forEach((key, value) {
    projects.add(StorageIdProject.fromJson(key, value));
  });
  return projects;
}

Map<String, dynamic> projectsIdsToJson(List<StorageIdProject> projects){
  Map<String, dynamic> jsonProjects = {};
  projects.forEach((p) {
    jsonProjects[p.id.toString()] = visitsIdsToJson(p.visits);
  });
  return jsonProjects;
}

class StorageIdProject{
  int id;
  List<StorageIdVisit> visits;
  
  StorageIdProject.fromJson(String id, Map<String, dynamic> jsonVisits){
    this.id = int.parse(id);
    visits = visitsIdsFromJson(jsonVisits);
  }

  Map<String, dynamic> toJson() => visitsIdsToJson(visits);
}

List<StorageIdVisit> visitsIdsFromJson(Map<String, dynamic> jsonVisits){
  List<StorageIdVisit> visits = [];
  jsonVisits.forEach((key, value) {
    visits.add(StorageIdVisit.fromJson(key, value));
  });
  return visits;
}

Map<String, dynamic> visitsIdsToJson(List<StorageIdVisit> visits){
  Map<String, dynamic> jsonVisits = {};
  visits.forEach((v) {
    jsonVisits[v.id.toString()] = v.formsIds;
  });
  return jsonVisits;
}

class StorageIdVisit{
  int id;
  List<String> formsIds;

  StorageIdVisit.fromJson(String id, List<String> formsIds){
    this.id = int.parse(id);
    this.formsIds = formsIds;
  }
}