import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class ProjectsStorageManager{
  static final String _projectsKey = 'projects';
  static final String _chosenProjectKey = 'chosen_project';
  static final String _projectsWithPreloadedVisitsKey = 'projects_with_preloaded_visits';
  
  static Future<void> setProjects(List<OldProject> projects)async{
    final List<Map<String, dynamic>> projectsAsJson = _convertProjectsToJson(projects);
    await StorageConnectorSingleton.storageConnector.setListResource(_projectsKey, projectsAsJson);
  }

  static List<Map<String, dynamic>> _convertProjectsToJson(List<OldProject> projects){
    return projects.map<Map<String, dynamic>>(
      (OldProject p)=> p.toJson()
    ).toList();
  }

  static Future<List<OldProject>> getProjects()async{
    return await _getListOfProjects(_projectsKey);
  }

  static Future<void> removeProjects()async{
    await StorageConnectorSingleton.storageConnector.removeResource(_projectsKey);
  }
  
  static Future<void> setChosenProject(OldProject project)async{
    final Map<String, dynamic> projectAsMap = project.toJson();
    await StorageConnectorSingleton.storageConnector.setMapResource(_chosenProjectKey, projectAsMap);
  }

  static Future<OldProject> getChosenProject()async{
    final Map<String, dynamic> chosenProjectAsMap = await StorageConnectorSingleton.storageConnector.getMapResource(_chosenProjectKey);
    final OldProject chosenProject = OldProject.fromJson(chosenProjectAsMap);
    return chosenProject;
  }

  static Future<void> removeChosenProject()async{
    await StorageConnectorSingleton.storageConnector.removeResource(_chosenProjectKey);
  }

  // * * * * * * * * * Preloaded data

  static Future<void> removeProjectWithPreloadedVisits(int removedProjectId)async{
    final List<OldProject> projects = await getProjectsWithPreloadedVisits();
    final List<OldProject> restantProjects = projects.where(
      (OldProject p) => p.id != removedProjectId
    ).toList();
    await StorageConnectorSingleton.storageConnector.setListResource(_projectsWithPreloadedVisitsKey, OldProjects(projects: restantProjects).toJson());
  }

  static Future<void> setProjectWithPreloadedVisits(OldProject project)async{
    final List<OldProject> projectsWithPreloadedVisits = await getProjectsWithPreloadedVisits();
    _addProjectToProjectsIfDoesntExists(projectsWithPreloadedVisits, project);
    await StorageConnectorSingleton.storageConnector.setListResource(_projectsWithPreloadedVisitsKey, OldProjects(projects: projectsWithPreloadedVisits).toJson());
  }

  static void _addProjectToProjectsIfDoesntExists(List<OldProject> projects, OldProject project){
    if(!_projectsContainProject(projects, project))
      projects.add(project);
  }

  static bool _projectsContainProject(List<OldProject> projects, OldProject project){
    final List<OldProject> projectsWithSameId = projects.where((OldProject p) => p.id == project.id).toList();
    return (projectsWithSameId != null && projectsWithSameId.length > 0);
  }

  static Future<List<OldProject>> getProjectsWithPreloadedVisits()async{
    return await _getListOfProjects(_projectsWithPreloadedVisitsKey);
  }

  static Future<List<OldProject>> _getListOfProjects(String key)async{
    final List<Map<String, dynamic>> projectsAsJson = await StorageConnectorSingleton.storageConnector.getListResource(key);
    final List<OldProject> projects = OldProjects.fromJson(projectsAsJson).projects;
    return projects;
  }
}