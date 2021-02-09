import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class ProjectsStorageManager{
  final String projectsKey = 'projects';
  final String chosenProjectKey = 'chosen_project';
  final StorageConnector storageConnector;
  ProjectsStorageManager():
    this.storageConnector = StorageConnectorSingleton.storageConnector
    ;

  ProjectsStorageManager.forTesting({
    @required this.storageConnector
  });
  
  Future<void> setProjects(List<Project> projects)async{
    final List<Map<String, dynamic>> projectsAsJson = _convertProjectsToJson(projects);
    await storageConnector.setListResource(projectsKey, projectsAsJson);
  }

  List<Map<String, dynamic>> _convertProjectsToJson(List<Project> projects){
    return projects.map<Map<String, dynamic>>(
      (Project p)=> p.toJson()
    ).toList();
  }

  Future<List<Project>> getProjects()async{
    final List<Map<String, dynamic>> projectsAsJson = await storageConnector.getListResource(projectsKey);
    final List<Project> projects = _convertJsonProjectsToObject(projectsAsJson);
    return projects;
  }

  List<Project> _convertJsonProjectsToObject(List<Map<String, dynamic>> projectsAsJson){
    return projectsAsJson.map<Project>(
      (Map<String, dynamic> jsonProject) => Project.fromJson(jsonProject)
    ).toList();
  }

  Future<void> removeProjects()async{
    await storageConnector.removeResource(projectsKey);
  }
  
  Future<void> setChosenProject(Project project)async{
    final Map<String, dynamic> projectAsMap = project.toJson();
    await storageConnector.setMapResource(chosenProjectKey, projectAsMap);
  }

  Future<Project> getChosenProject()async{
    final Map<String, dynamic> chosenProjectAsMap = await storageConnector.getMapResource(chosenProjectKey);
    final Project chosenProject = Project.fromJson(chosenProjectAsMap);
    return chosenProject;
  }

  Future<void> removeChosenProject()async{
    await storageConnector.removeResource(chosenProjectKey);
  }

}