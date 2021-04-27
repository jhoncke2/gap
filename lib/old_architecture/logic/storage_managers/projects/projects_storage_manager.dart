import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/native_connectors/storage_connector.dart';

class ProjectsStorageManager{
  static final String _projectsKey = 'projects_old';
  static final String _chosenProjectKey = 'chosen_project_old';
  static final String _projectsWithPreloadedVisitsKey = 'projects_with_preloaded_visits_old';
  
  static Future<void> setProjects(List<ProjectOld> projects)async{
    final List<Map<String, dynamic>> projectsAsJson = projectsToJson(projects);
    await StorageConnectorOldSingleton.storageConnector.setListResource(_projectsKey, projectsAsJson);
  }

  static Future<List<ProjectOld>> getProjects()async{
    return await _getListOfProjects(_projectsKey);
  }

  static Future<void> removeProjects()async{
    await StorageConnectorOldSingleton.storageConnector.removeResource(_projectsKey);
  }
  
  static Future<void> setChosenProject(ProjectOld project)async{
    final Map<String, dynamic> projectAsMap = project.toJson();
    await StorageConnectorOldSingleton.storageConnector.setMapResource(_chosenProjectKey, projectAsMap);
  }

  static Future<ProjectOld> getChosenProject()async{
    final Map<String, dynamic> chosenProjectAsMap = await StorageConnectorOldSingleton.storageConnector.getMapResource(_chosenProjectKey);
    final ProjectOld chosenProject = ProjectOld.fromJson(chosenProjectAsMap);
    return chosenProject;
  }
  
  static Future<void> removeChosenProject()async{
    await StorageConnectorOldSingleton.storageConnector.removeResource(_chosenProjectKey);
  }

  // * * * * * * * * * Preloaded data

  static Future<void> removeProjectWithPreloadedVisits(int removedProjectId)async{
    final List<ProjectOld> projects = await getProjectsWithPreloadedVisits();
    final List<ProjectOld> restantProjects = projects.where(
      (ProjectOld p) => p.id != removedProjectId
    ).toList();
    await StorageConnectorOldSingleton.storageConnector.setListResource(_projectsWithPreloadedVisitsKey, projectsToJson(restantProjects));
  }

  static Future<void> setProjectWithPreloadedVisits(ProjectOld project)async{
    final List<ProjectOld> projectsWithPreloadedVisits = await getProjectsWithPreloadedVisits();
    _addProjectToProjectsIfDoesntExists(projectsWithPreloadedVisits, project);
    await StorageConnectorOldSingleton.storageConnector.setListResource(_projectsWithPreloadedVisitsKey, projectsToJson(projectsWithPreloadedVisits));
  }

  static void _addProjectToProjectsIfDoesntExists(List<ProjectOld> projects, ProjectOld project){
    if(!_projectsContainProject(projects, project))
      projects.add(project);
  }

  static bool _projectsContainProject(List<ProjectOld> projects, ProjectOld project){
    final List<ProjectOld> projectsWithSameId = projects.where((ProjectOld p) => p.id == project.id).toList();
    return (projectsWithSameId != null && projectsWithSameId.length > 0);
  }

  static Future<List<ProjectOld>> getProjectsWithPreloadedVisits()async{
    return await _getListOfProjects(_projectsWithPreloadedVisitsKey);
  }

  static Future<List<ProjectOld>> _getListOfProjects(String key)async{
    final List<Map<String, dynamic>> projectsAsJson = await StorageConnectorOldSingleton.storageConnector.getListResource(key);
    final List<ProjectOld> projects = projectsFromJson(projectsAsJson);
    //final List<Project> projects = Projects.fromJson(projectsAsJson).projects;
    return projects;
  }
}