import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class PreloadedFormsStorageManager{
  static final String _preloadedFormsKey = 'preloaded_forms';
  @protected
  static final _PreloadedFormsHolder currentPreloadedFormsHolder = _PreloadedFormsHolder();

  static Future<void> removePreloadedForm(int formId, int visitId)async{
    await _updateCurrentPreloadedFormsHolderFromStorage();
    final List<Formulario> preloadedFormsByVisitId = await _getPreloadedFormsByVisitId(visitId);
    final List<Formulario> restantPreloadedFormsByVisitId = _obtainRestantPreloadedFormsByVisitId(preloadedFormsByVisitId, formId);
    await _executeRemoving(restantPreloadedFormsByVisitId, visitId);
    await _updateStorageFromCurrentPreloadedFormsHolder();
  }

  static List<Formulario> _obtainRestantPreloadedFormsByVisitId(List<Formulario> preloadedFormsByVisitId, int visitId){
    final List<Formulario> restantPreloadedFormsByVisitId = preloadedFormsByVisitId.where(
      (Formulario v)=>v.id != visitId
    ).toList();
    return restantPreloadedFormsByVisitId;
  }

  static Future<void> _executeRemoving(List<Formulario> restantPreloadedFormsByVisitId, int visitId)async{
    if(restantPreloadedFormsByVisitId.length == 0)
      _removeFormsFromFormsByVisitIdMap(visitId);
    else
      _updateVisitIdMapWithoutRemovedForm(restantPreloadedFormsByVisitId, visitId);  
  }

  static void _removeFormsFromFormsByVisitIdMap( int visitId){
    currentPreloadedFormsHolder.currentData.remove(visitId.toString());
  }
  
  static void _updateVisitIdMapWithoutRemovedForm(List<Formulario> restantPreloadedFormsByVisitId, int visitId){
    final List<Map<String, dynamic>> restantPrelFormsByVisitIdAsJson = Formularios(formularios: restantPreloadedFormsByVisitId).toJson();
    currentPreloadedFormsHolder.currentData[visitId.toString()] = restantPrelFormsByVisitIdAsJson;
  }

  static Future<void> setPreloadedForm(Formulario form, int visitId)async{
    await _updateCurrentPreloadedFormsHolderFromStorage();
    final List<Formulario> preloadedFormsByVisittId = await _getPreloadedFormsByVisitId(visitId);
    preloadedFormsByVisittId.add(form);
    final List<Map<String, dynamic>> preloadedFormsByVisitIdAsJson = Formularios(formularios: preloadedFormsByVisittId).toJson();
    currentPreloadedFormsHolder.currentData[visitId.toString()] = preloadedFormsByVisitIdAsJson;
    await _updateStorageFromCurrentPreloadedFormsHolder();
  }

  static Future<List<Formulario>> getPreloadedFormsByVisitId(int visitId)async{
    await _updateCurrentPreloadedFormsHolderFromStorage();
    final List<Formulario> preloadedFormsByVisitId = await _getPreloadedFormsByVisitId(visitId);
    return preloadedFormsByVisitId;
  }
  
  static Future<List<Formulario>> _getPreloadedFormsByVisitId(int visitId)async{
    final List<Map<String, dynamic>> preloadedFormsByVisitIdAsJson = currentPreloadedFormsHolder.currentData[visitId.toString()];
    final List<Formulario> preloadedFormsByVisitId = Formularios.fromJson( preloadedFormsByVisitIdAsJson??[] ).formularios;
    return preloadedFormsByVisitId;
  }

  static Future<void> _updateCurrentPreloadedFormsHolderFromStorage()async{
    //currentPreloadedVisitsHolder.currentData =  (await StorageConnectorSingleton.storageConnector.getMapResource(preloadedVisitsKey)).cast<String, List<Map<String, dynamic>>>();
    final Map<dynamic, dynamic> tempMap = (await StorageConnectorSingleton.storageConnector.getMapResource(_preloadedFormsKey));
    currentPreloadedFormsHolder.initFromJson(tempMap);
  }
  
  static Future<void> _updateStorageFromCurrentPreloadedFormsHolder()async{
    print(currentPreloadedFormsHolder.currentData.runtimeType);
    await StorageConnectorSingleton.storageConnector.setMapResource(_preloadedFormsKey, currentPreloadedFormsHolder.toJson());
  }

  
}

class _PreloadedFormsHolder{
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