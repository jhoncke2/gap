import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class ProjectsStorageManager{
  static final String _projectsKey = 'projects';
  static final String _chosenProjectKey = 'chosen_project';
  static final String _projectsWithPreloadedVisitsKey = 'projects_with_preloaded_visits';
  
  static Future<void> setProjects(List<Project> projects)async{
    final List<Map<String, dynamic>> projectsAsJson = _convertProjectsToJson(projects);
    await StorageConnectorSingleton.storageConnector.setListResource(_projectsKey, projectsAsJson);
  }

  static List<Map<String, dynamic>> _convertProjectsToJson(List<Project> projects){
    return projects.map<Map<String, dynamic>>(
      (Project p)=> p.toJson()
    ).toList();
  }

  static Future<List<Project>> getProjects()async{
    return await _getListOfProjects(_projectsKey);
  }

  static Future<void> removeProjects()async{
    await StorageConnectorSingleton.storageConnector.removeResource(_projectsKey);
  }
  
  static Future<void> setChosenProject(Project project)async{
    final Map<String, dynamic> projectAsMap = project.toJson();
    await StorageConnectorSingleton.storageConnector.setMapResource(_chosenProjectKey, projectAsMap);
  }

  static Future<Project> getChosenProject()async{
    final Map<String, dynamic> chosenProjectAsMap = await StorageConnectorSingleton.storageConnector.getMapResource(_chosenProjectKey);
    final Project chosenProject = Project.fromJson(chosenProjectAsMap);
    return chosenProject;
  }

  static Future<void> removeChosenProject()async{
    await StorageConnectorSingleton.storageConnector.removeResource(_chosenProjectKey);
  }

  // * * * * * * * * * Preloaded data

  static Future<void> removeProjectWithPreloadedVisits(int removedProjectId)async{
    final List<Project> projects = await getProjectsWithPreloadedVisits();
    final List<Project> restantProjects = projects.where(
      (Project p) => p.id != removedProjectId
    ).toList();
    await StorageConnectorSingleton.storageConnector.setListResource(_projectsWithPreloadedVisitsKey, projectsToJson(restantProjects));
  }

  static Future<void> setProjectWithPreloadedVisits(Project project)async{
    final List<Project> projectsWithPreloadedVisits = await getProjectsWithPreloadedVisits();
    _addProjectToProjectsIfDoesntExists(projectsWithPreloadedVisits, project);
    await StorageConnectorSingleton.storageConnector.setListResource(_projectsWithPreloadedVisitsKey, projectsToJson(projectsWithPreloadedVisits));
  }

  static void _addProjectToProjectsIfDoesntExists(List<Project> projects, Project project){
    if(!_projectsContainProject(projects, project))
      projects.add(project);
  }

  static bool _projectsContainProject(List<Project> projects, Project project){
    final List<Project> projectsWithSameId = projects.where((Project p) => p.id == project.id).toList();
    return (projectsWithSameId != null && projectsWithSameId.length > 0);
  }

  static Future<List<Project>> getProjectsWithPreloadedVisits()async{
    return await _getListOfProjects(_projectsWithPreloadedVisitsKey);
  }

  static Future<List<Project>> _getListOfProjects(String key)async{
    final List<Map<String, dynamic>> projectsAsJson = await StorageConnectorSingleton.storageConnector.getListResource(key);
    final List<Project> projects = projectsFromJson(projectsAsJson);
    //final List<Project> projects = Projects.fromJson(projectsAsJson).projects;
    return projects;
  }
}