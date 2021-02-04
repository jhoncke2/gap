import 'package:gap/logic/helpers/storage_saver.dart';
import 'package:gap/logic/models/entities/project.dart';

class ProjectsStorageManager{
  final StorageSaver storageSaver = StorageSaverSingleton.storageSaver;
  
  Future<void> setProjects(List<Project> projects)async{
    final List<Map<String, dynamic>> projectsAsJson = _convertProjectsToJson(projects);
    await storageSaver.setListResource(storageSaver.projectsKey, projectsAsJson);
  }

  List<Map<String, dynamic>> _convertProjectsToJson(List<Project> projects){
    return projects.map<Map<String, dynamic>>(
      (Project p)=> p.toJson()
    ).toList();
  }

  Future<List<Project>> getProjects()async{
    final List<Map<String, dynamic>> projectsAsJson = await storageSaver.getListResource(storageSaver.projectsKey);
    final List<Project> projects = _convertJsonProjectsToProjects(projectsAsJson);
    return projects;
  }

  List<Project> _convertJsonProjectsToProjects(List<Map<String, dynamic>> projectsAsJson){
    return projectsAsJson.map<Project>(
      (Map<String, dynamic> jsonProject) => Project.fromJson(jsonProject)
    ).toList();
  }

  Future<void> deleteProjects()async{
    await storageSaver.delete(storageSaver.projectsKey);
  }

  //TODO: Implementar métodos de chosenProject

}