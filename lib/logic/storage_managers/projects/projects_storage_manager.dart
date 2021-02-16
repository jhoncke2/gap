import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class ProjectsStorageManager{
  static final String projectsKey = 'projects';
  static final String chosenProjectKey = 'chosen_project';
  static final String projectsWithPreloadedVisitsKey = 'projects_with_preloaded_visits';
  
  static Future<void> setProjects(List<Project> projects)async{
    final List<Map<String, dynamic>> projectsAsJson = _convertProjectsToJson(projects);
    await StorageConnectorSingleton.storageConnector.setListResource(projectsKey, projectsAsJson);
  }

  static List<Map<String, dynamic>> _convertProjectsToJson(List<Project> projects){
    return projects.map<Map<String, dynamic>>(
      (Project p)=> p.toJson()
    ).toList();
  }

  static Future<List<Project>> getProjects()async{
    return await _getListOfProjects(projectsKey);
  }

  static Future<void> removeProjects()async{
    await StorageConnectorSingleton.storageConnector.removeResource(projectsKey);
  }
  
  static Future<void> setChosenProject(Project project)async{
    final Map<String, dynamic> projectAsMap = project.toJson();
    await StorageConnectorSingleton.storageConnector.setMapResource(chosenProjectKey, projectAsMap);
  }

  static Future<Project> getChosenProject()async{
    final Map<String, dynamic> chosenProjectAsMap = await StorageConnectorSingleton.storageConnector.getMapResource(chosenProjectKey);
    final Project chosenProject = Project.fromJson(chosenProjectAsMap);
    return chosenProject;
  }

  static Future<void> removeChosenProject()async{
    await StorageConnectorSingleton.storageConnector.removeResource(chosenProjectKey);
  }

  // * * * * * * * * * Preloaded data

  static Future<void> removeProjectWithPreloadedVisits(int removedProjectId)async{
    final List<Project> projects = await getProjectsWithPreloadedVisits();
    final List<Project> restantProjects = projects.where(
      (Project p) => p.id != removedProjectId
    ).toList();
    await StorageConnectorSingleton.storageConnector.setListResource(projectsWithPreloadedVisitsKey, Projects(projects: restantProjects).toJson());
  }

  static Future<void> setToProjectWithPreloadedVisits(Project project)async{
    final List<Project> projectsWithPreloadedVisits = await getProjectsWithPreloadedVisits();
    projectsWithPreloadedVisits.add(project);
    await StorageConnectorSingleton.storageConnector.setListResource(projectsWithPreloadedVisitsKey, Projects(projects: projectsWithPreloadedVisits).toJson());
  }

  static Future<List<Project>> getProjectsWithPreloadedVisits()async{
    return await _getListOfProjects(projectsWithPreloadedVisitsKey);
  }

  static Future<List<Project>> _getListOfProjects(String key)async{
    final List<Map<String, dynamic>> projectsAsJson = await StorageConnectorSingleton.storageConnector.getListResource(key);
    final List<Project> projects = Projects.fromJson(projectsAsJson).projects;
    return projects;
  }
}