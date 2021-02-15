import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class PreloadedVisitsStorageManager{
  static final String preloadedVisitsKey = 'preloaded_visits';
  @protected
  static final _PreloadedVisitsHolder currentPreloadedVisitsHolder = _PreloadedVisitsHolder();

  static Future<void> removePreloadedVisit(int visitId, int projectId)async{
    await _updateCurrentPreloadedVisitsHolderFromStorage();
    final List<Visit> preloadedVisitsByProjectId = await _getPreloadedVisitsByProjectId(projectId);
    final List<Visit> restantPreloadedVisitsByProjectId = _obtainRestantPreloadedVisitsByProjectId(preloadedVisitsByProjectId, visitId);
    await _executeRemoving(restantPreloadedVisitsByProjectId, projectId);
    await _updateStorageFromCurrentPreloadedVisitsHolder();
  }

  static List<Visit> _obtainRestantPreloadedVisitsByProjectId(List<Visit> preloadedVisitsByProjectId, int visitId){
    final List<Visit> restantPreloadedVisitsByProjectId = preloadedVisitsByProjectId.where(
      (Visit v)=>v.id != visitId
    ).toList();
    return restantPreloadedVisitsByProjectId;
  }

  static Future<void> _executeRemoving(List<Visit> restantPreloadedVisitsByProjectId, int projectId)async{
    if(restantPreloadedVisitsByProjectId.length == 0)
      _removeProjectIdFromVisitsByProjectIdMap(projectId);
    else
      _updateProjectIdMapWithoutRemovedVisit(restantPreloadedVisitsByProjectId, projectId);  
  }

  static void _removeProjectIdFromVisitsByProjectIdMap( int projectId){
    currentPreloadedVisitsHolder.currentData.remove(projectId.toString());
  }
  
  static void _updateProjectIdMapWithoutRemovedVisit(List<Visit> restantPreloadedVisitsByProjectId, int projectId){
    final List<Map<String, dynamic>> restantPrelVisitsByProjIdAsJson = Visits(visits: restantPreloadedVisitsByProjectId).toJson();
    currentPreloadedVisitsHolder.currentData[projectId.toString()] = restantPrelVisitsByProjIdAsJson;
  }

  

  static Future<void> setPreloadedVisit(Visit visit, int projectId)async{
    await _updateCurrentPreloadedVisitsHolderFromStorage();
    final List<Visit> preloadedVisitsByProjectId = await _getPreloadedVisitsByProjectId(projectId);
    preloadedVisitsByProjectId.add(visit);
    final List<Map<String, dynamic>> preloadedVisitsByProjectIdAsJson = Visits(visits: preloadedVisitsByProjectId).toJson();
    currentPreloadedVisitsHolder.currentData[projectId.toString()] = preloadedVisitsByProjectIdAsJson;
    await _updateStorageFromCurrentPreloadedVisitsHolder();
  }

  static Future<List<Visit>> getPreloadedVisitsByProjectId(int projectId)async{
    await _updateCurrentPreloadedVisitsHolderFromStorage();
    final List<Visit> preloadedVisitsByProjectId = await _getPreloadedVisitsByProjectId(projectId);
    return preloadedVisitsByProjectId;
  }
  
  static Future<List<Visit>> _getPreloadedVisitsByProjectId(int projectId)async{
    final List<Map<String, dynamic>> preloadedVisitsByProjectIdAsJson = currentPreloadedVisitsHolder.currentData[projectId.toString()];
    final List<Visit> preloadedVisitsByProjectId = Visits.fromJson( preloadedVisitsByProjectIdAsJson??[] ).visits;
    return preloadedVisitsByProjectId;
  }

  static Future<void> _updateCurrentPreloadedVisitsHolderFromStorage()async{
    //currentPreloadedVisitsHolder.currentData =  (await StorageConnectorSingleton.storageConnector.getMapResource(preloadedVisitsKey)).cast<String, List<Map<String, dynamic>>>();
    final Map<dynamic, dynamic> tempMap = (await StorageConnectorSingleton.storageConnector.getMapResource(preloadedVisitsKey));
    currentPreloadedVisitsHolder.initFromJson(tempMap);
  }
  
  static Future<void> _updateStorageFromCurrentPreloadedVisitsHolder()async{
    print(currentPreloadedVisitsHolder.currentData.runtimeType);
    await StorageConnectorSingleton.storageConnector.setMapResource(preloadedVisitsKey, currentPreloadedVisitsHolder.toJson());
  }

  
}

class _PreloadedVisitsHolder{
  Map<String, List<Map<String, dynamic>>> currentData;

  void initFromJson(Map<dynamic, dynamic> json){
    final Map<String, List> jsonWithList = json.cast<String, List>();
    currentData = {};
    jsonWithList.forEach((key, value) {
      currentData[key] = List.from(value);
    });
  }

  Map<dynamic, dynamic> toJson(){
    final Map<dynamic, dynamic> returnedData = currentData;
    return returnedData;
  }
}