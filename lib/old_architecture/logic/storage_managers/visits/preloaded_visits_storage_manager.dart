import 'package:flutter/material.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/native_connectors/storage_connector.dart';

class PreloadedVisitsStorageManager{
  static final String _preloadedVisitsKey = 'preloaded_visits';
  @protected
  static final _PreloadedVisitsHolder currentPreloadedVisitsHolder = _PreloadedVisitsHolder();

  static Future<void> removeVisit(int visitId, int projectId)async{
    await _updateCurrentVisitsHolderFromStorage();
    final List<VisitOld> preloadedVisitsByProjectId = await _getVisitsByProjectId(projectId);
    final List<VisitOld> restantPreloadedVisitsByProjectId = _obtainRestantVisitsByProjectId(preloadedVisitsByProjectId, visitId);
    await _executeRemoving(restantPreloadedVisitsByProjectId, projectId);
    await _updateStorageFromCurrentVisitsHolder();
  }

  static List<VisitOld> _obtainRestantVisitsByProjectId(List<VisitOld> preloadedVisitsByProjectId, int visitId){
    final List<VisitOld> restantPreloadedVisitsByProjectId = preloadedVisitsByProjectId.where(
      (VisitOld v)=>v.id != visitId
    ).toList();
    return restantPreloadedVisitsByProjectId;
  }

  static Future<void> _executeRemoving(List<VisitOld> restantPreloadedVisitsByProjectId, int projectId)async{
    if(restantPreloadedVisitsByProjectId.length == 0)
      _removeProjectIdFromVisitsByProjectIdMap(projectId);
    else
      _updateProjectIdMapWithoutRemovedVisit(restantPreloadedVisitsByProjectId, projectId);  
  }

  static void _removeProjectIdFromVisitsByProjectIdMap( int projectId){
    currentPreloadedVisitsHolder.currentData.remove(projectId.toString());
  }
  
  static void _updateProjectIdMapWithoutRemovedVisit(List<VisitOld> restantPreloadedVisitsByProjectId, int projectId){
    final List<Map<String, dynamic>> restantPrelVisitsByProjIdAsJson =  visitsToStorageJson(restantPreloadedVisitsByProjectId);//   Visits(visits: restantPreloadedVisitsByProjectId).toJson();
    currentPreloadedVisitsHolder.currentData[projectId.toString()] = restantPrelVisitsByProjIdAsJson;
  }  

  static Future<void> setVisit(VisitOld visit, int projectId)async{
    await _updateCurrentVisitsHolderFromStorage();
    final List<VisitOld> preloadedVisitsByProjectId = await _getVisitsByProjectId(projectId);
    _addVisitToVisits(visit, preloadedVisitsByProjectId);
    final List<Map<String, dynamic>> preloadedVisitsByProjectIdAsJson =  visitsToStorageJson(preloadedVisitsByProjectId); //   Visits(visits: preloadedVisitsByProjectId).toJson();
    currentPreloadedVisitsHolder.currentData[projectId.toString()] = preloadedVisitsByProjectIdAsJson;
    await _updateStorageFromCurrentVisitsHolder();
  }

  static void _addVisitToVisits(VisitOld visit, List<VisitOld> visits){
    final int visitIndex = visits.indexWhere((element) => element.id == visit.id);
    _addVisitToVisitsByItsIndex(visit, visits, visitIndex);
  }

  static void _addVisitToVisitsByItsIndex(VisitOld visit, List<VisitOld> visits, int index){
    if(index > -1)
      visits[index] = visit;
    else
      visits.add(visit);
  }

  static Future<List<VisitOld>> getVisitsByProjectId(int projectId)async{
    await _updateCurrentVisitsHolderFromStorage();
    final List<VisitOld> preloadedVisitsByProjectId = await _getVisitsByProjectId(projectId);
    return preloadedVisitsByProjectId;
  }
  
  static Future<List<VisitOld>> _getVisitsByProjectId(int projectId)async{
    final List<Map<String, dynamic>> preloadedVisitsByProjectIdAsJson = currentPreloadedVisitsHolder.currentData[projectId.toString()];
    final List<VisitOld> preloadedVisitsByProjectId =  visitsFromStorageJson(preloadedVisitsByProjectIdAsJson);  // Visits.fromJson( preloadedVisitsByProjectIdAsJson??[] ).visits;
    return preloadedVisitsByProjectId;
  }

  static Future<void> _updateCurrentVisitsHolderFromStorage()async{
    //currentPreloadedVisitsHolder.currentData =  (await StorageConnectorSingleton.storageConnector.getMapResource(preloadedVisitsKey)).cast<String, List<Map<String, dynamic>>>();
    final Map<dynamic, dynamic> tempMap = (await StorageConnectorOldSingleton.storageConnector.getMapResource(_preloadedVisitsKey));
    currentPreloadedVisitsHolder.initFromJson(tempMap);
  }
  
  static Future<void> _updateStorageFromCurrentVisitsHolder()async{
    print(currentPreloadedVisitsHolder.currentData.runtimeType);
    await StorageConnectorOldSingleton.storageConnector.setMapResource(_preloadedVisitsKey, currentPreloadedVisitsHolder.toJson());
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