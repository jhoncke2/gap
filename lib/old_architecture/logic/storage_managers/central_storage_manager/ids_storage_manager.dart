import 'package:flutter/material.dart';
import 'package:gap/old_architecture/logic/storage_managers/central_storage_manager/ids_storage_models.dart';
import 'package:gap/old_architecture/native_connectors/storage_connector.dart';

class IdsStorageManager{

  @protected
  static final String idsDataKey = 'ids_data';

  static Future addProjectId(int id)async{
    final List<StorageIdProject> projectsIdsTree = await _getProjectsIdsFromStorage();
    _addProjectIdInfoToProjectsIfExists(id.toString(), projectsIdsTree);
    await StorageConnectorOldSingleton.storageConnector.setMapResource(idsDataKey, projectsIdsToJson(projectsIdsTree));
  }

  static Future<List<StorageIdProject>> _getProjectsIdsFromStorage()async{
    final Map<String, dynamic> jsonProjects = await StorageConnectorOldSingleton.storageConnector.getMapResource(idsDataKey);
    return projectsIdsFromJson(jsonProjects);
  }

  static void _addProjectIdInfoToProjectsIfExists(String id, List<StorageIdProject> projectsIds){
    final indexOfId = projectsIds.indexWhere((element) => element.id == int.parse(id));
    if(indexOfId == -1)
      projectsIds.add(StorageIdProject.fromJson(id, {}));
  }

  static Future addVisitIdToProject(int visitId, int projectId)async{
    final List<StorageIdProject> idProjects = await _getProjectsIdsFromStorage();
    final StorageIdProject project = idProjects.singleWhere((p) => p.id == projectId);
    _addVisitIdToProjectIfVisitDoesntExists(visitId.toString(), project);
    await _updateProjectsIdsInStorage( idProjects);
  }

  static void _addVisitIdToProjectIfVisitDoesntExists(String visitId, StorageIdProject project){
    final indexOfId = project.visits.indexWhere((v) => v.id == int.parse(visitId));
    if(indexOfId == -1)
      project.visits.add(StorageIdVisit.fromJson(visitId, []));
  }

  static Future _updateProjectsIdsInStorage(List<StorageIdProject> idProjects)async{
    await StorageConnectorOldSingleton.storageConnector.setMapResource(idsDataKey, projectsIdsToJson(idProjects));
  }
}