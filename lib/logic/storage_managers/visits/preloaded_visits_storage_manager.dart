import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class PreloadedVisitsStorageManager{
  static final String _preloadedVisitsKey = 'preloaded_visits';
  @protected
  static final _PreloadedVisitsHolder currentPreloadedVisitsHolder = _PreloadedVisitsHolder();

  static Future<void> removeVisit(int visitId, int projectId)async{
    await _updateCurrentVisitsHolderFromStorage();
    final List<Visit> preloadedVisitsByProjectId = await _getVisitsByProjectId(projectId);
    final List<Visit> restantPreloadedVisitsByProjectId = _obtainRestantVisitsByProjectId(preloadedVisitsByProjectId, visitId);
    await _executeRemoving(restantPreloadedVisitsByProjectId, projectId);
    await _updateStorageFromCurrentVisitsHolder();
  }

  static List<Visit> _obtainRestantVisitsByProjectId(List<Visit> preloadedVisitsByProjectId, int visitId){
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
    final List<Map<String, dynamic>> restantPrelVisitsByProjIdAsJson =  visitsToStorageJson(restantPreloadedVisitsByProjectId);//   Visits(visits: restantPreloadedVisitsByProjectId).toJson();
    currentPreloadedVisitsHolder.currentData[projectId.toString()] = restantPrelVisitsByProjIdAsJson;
  }  

  static Future<void> setVisit(Visit visit, int projectId)async{
    await _updateCurrentVisitsHolderFromStorage();
    final List<Visit> preloadedVisitsByProjectId = await _getVisitsByProjectId(projectId);
    _addVisitToVisits(visit, preloadedVisitsByProjectId);
    final List<Map<String, dynamic>> preloadedVisitsByProjectIdAsJson =  visitsToStorageJson(preloadedVisitsByProjectId); //   Visits(visits: preloadedVisitsByProjectId).toJson();
    currentPreloadedVisitsHolder.currentData[projectId.toString()] = preloadedVisitsByProjectIdAsJson;
    await _updateStorageFromCurrentVisitsHolder();
  }

  static void _addVisitToVisits(Visit visit, List<Visit> visits){
    final int visitIndex = visits.indexWhere((element) => element.id == visit.id);
    _addVisitToVisitsByItsIndex(visit, visits, visitIndex);
  }

  static void _addVisitToVisitsByItsIndex(Visit visit, List<Visit> visits, int index){
    if(index > -1)
      visits[index] = visit;
    else
      visits.add(visit);
  }

  static Future<List<Visit>> getVisitsByProjectId(int projectId)async{
    await _updateCurrentVisitsHolderFromStorage();
    final List<Visit> preloadedVisitsByProjectId = await _getVisitsByProjectId(projectId);
    return preloadedVisitsByProjectId;
  }
  
  static Future<List<Visit>> _getVisitsByProjectId(int projectId)async{
    final List<Map<String, dynamic>> preloadedVisitsByProjectIdAsJson = currentPreloadedVisitsHolder.currentData[projectId.toString()];
    final List<Visit> preloadedVisitsByProjectId =  visitsFromStorageJson(preloadedVisitsByProjectIdAsJson);  // Visits.fromJson( preloadedVisitsByProjectIdAsJson??[] ).visits;
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