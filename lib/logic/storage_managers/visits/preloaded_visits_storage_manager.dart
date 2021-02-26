import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class PreloadedVisitsStorageManager{
  static final String _preloadedVisitsKey = 'preloaded_visits';
  @protected
  static final _PreloadedVisitsHolder currentPreloadedVisitsHolder = _PreloadedVisitsHolder();

  static Future<void> removeVisit(int visitId, int projectId)async{
    await _updateCurrentVisitsHolderFromStorage();
    final List<OldVisit> preloadedVisitsByProjectId = await _getVisitsByProjectId(projectId);
    final List<OldVisit> restantPreloadedVisitsByProjectId = _obtainRestantVisitsByProjectId(preloadedVisitsByProjectId, visitId);
    await _executeRemoving(restantPreloadedVisitsByProjectId, projectId);
    await _updateStorageFromCurrentVisitsHolder();
  }

  static List<OldVisit> _obtainRestantVisitsByProjectId(List<OldVisit> preloadedVisitsByProjectId, int visitId){
    final List<OldVisit> restantPreloadedVisitsByProjectId = preloadedVisitsByProjectId.where(
      (OldVisit v)=>v.id != visitId
    ).toList();
    return restantPreloadedVisitsByProjectId;
  }

  static Future<void> _executeRemoving(List<OldVisit> restantPreloadedVisitsByProjectId, int projectId)async{
    if(restantPreloadedVisitsByProjectId.length == 0)
      _removeProjectIdFromVisitsByProjectIdMap(projectId);
    else
      _updateProjectIdMapWithoutRemovedVisit(restantPreloadedVisitsByProjectId, projectId);  
  }

  static void _removeProjectIdFromVisitsByProjectIdMap( int projectId){
    currentPreloadedVisitsHolder.currentData.remove(projectId.toString());
  }
  
  static void _updateProjectIdMapWithoutRemovedVisit(List<OldVisit> restantPreloadedVisitsByProjectId, int projectId){
    final List<Map<String, dynamic>> restantPrelVisitsByProjIdAsJson = OldVisits(visits: restantPreloadedVisitsByProjectId).toJson();
    currentPreloadedVisitsHolder.currentData[projectId.toString()] = restantPrelVisitsByProjIdAsJson;
  }  

  static Future<void> setVisit(OldVisit visit, int projectId)async{
    await _updateCurrentVisitsHolderFromStorage();
    final List<OldVisit> preloadedVisitsByProjectId = await _getVisitsByProjectId(projectId);
    preloadedVisitsByProjectId.add(visit);
    final List<Map<String, dynamic>> preloadedVisitsByProjectIdAsJson = OldVisits(visits: preloadedVisitsByProjectId).toJson();
    currentPreloadedVisitsHolder.currentData[projectId.toString()] = preloadedVisitsByProjectIdAsJson;
    await _updateStorageFromCurrentVisitsHolder();
  }

  static Future<List<OldVisit>> getVisitsByProjectId(int projectId)async{
    await _updateCurrentVisitsHolderFromStorage();
    final List<OldVisit> preloadedVisitsByProjectId = await _getVisitsByProjectId(projectId);
    return preloadedVisitsByProjectId;
  }
  
  static Future<List<OldVisit>> _getVisitsByProjectId(int projectId)async{
    final List<Map<String, dynamic>> preloadedVisitsByProjectIdAsJson = currentPreloadedVisitsHolder.currentData[projectId.toString()];
    final List<OldVisit> preloadedVisitsByProjectId = OldVisits.fromJson( preloadedVisitsByProjectIdAsJson??[] ).visits;
    return preloadedVisitsByProjectId;
  }

  static Future<void> _updateCurrentVisitsHolderFromStorage()async{
    //currentPreloadedVisitsHolder.currentData =  (await StorageConnectorSingleton.storageConnector.getMapResource(preloadedVisitsKey)).cast<String, List<Map<String, dynamic>>>();
    final Map<dynamic, dynamic> tempMap = (await StorageConnectorSingleton.storageConnector.getMapResource(_preloadedVisitsKey));
    currentPreloadedVisitsHolder.initFromJson(tempMap);
  }
  
  static Future<void> _updateStorageFromCurrentVisitsHolder()async{
    print(currentPreloadedVisitsHolder.currentData.runtimeType);
    await StorageConnectorSingleton.storageConnector.setMapResource(_preloadedVisitsKey, currentPreloadedVisitsHolder.toJson());
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