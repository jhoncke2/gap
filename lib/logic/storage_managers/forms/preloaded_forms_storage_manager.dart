import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class PreloadedFormsStorageManager{
  static final String _preloadedFormsKey = 'preloaded_forms';
  @protected
  static final _PreloadedFormsHolder currentPreloadedFormsHolder = _PreloadedFormsHolder();

  static Future<void> removePreloadedForm(int formId, int visitId)async{
    await _updateCurrentPreloadedFormsHolderFromStorage();
    final List<OldFormulario> preloadedFormsByVisitId = await _getPreloadedFormsByVisitId(visitId);
    final List<OldFormulario> restantPreloadedFormsByVisitId = _obtainRestantPreloadedFormsByVisitId(preloadedFormsByVisitId, formId);
    await _executeRemoving(restantPreloadedFormsByVisitId, visitId);
    await _updateStorageFromCurrentPreloadedFormsHolder();
  }

  static List<OldFormulario> _obtainRestantPreloadedFormsByVisitId(List<OldFormulario> preloadedFormsByVisitId, int visitId){
    final List<OldFormulario> restantPreloadedFormsByVisitId = preloadedFormsByVisitId.where(
      (OldFormulario v)=>v.id != visitId
    ).toList();
    return restantPreloadedFormsByVisitId;
  }

  static Future<void> _executeRemoving(List<OldFormulario> restantPreloadedFormsByVisitId, int visitId)async{
    if(restantPreloadedFormsByVisitId.length == 0)
      _removeFormsFromFormsByVisitIdMap(visitId);
    else
      _updateVisitIdMapWithoutRemovedForm(restantPreloadedFormsByVisitId, visitId);  
  }

  static void _removeFormsFromFormsByVisitIdMap( int visitId){
    currentPreloadedFormsHolder.currentData.remove(visitId.toString());
  }
  
  static void _updateVisitIdMapWithoutRemovedForm(List<OldFormulario> restantPreloadedFormsByVisitId, int visitId){
    final List<Map<String, dynamic>> restantPrelFormsByVisitIdAsJson = OldFormularios(formularios: restantPreloadedFormsByVisitId).toJson();
    currentPreloadedFormsHolder.currentData[visitId.toString()] = restantPrelFormsByVisitIdAsJson;
  }

  static Future<void> setPreloadedForm(OldFormulario form, int visitId)async{
    await _updateCurrentPreloadedFormsHolderFromStorage();
    final List<OldFormulario> preloadedFormsByVisitId = await _getPreloadedFormsByVisitId(visitId);
    //preloadedFormsByVisittId.add(form);
    _upgradeCurrentFormInForms(form, preloadedFormsByVisitId);
    final List<Map<String, dynamic>> preloadedFormsByVisitIdAsJson = OldFormularios(formularios: preloadedFormsByVisitId).toJson();
    currentPreloadedFormsHolder.currentData[visitId.toString()] = preloadedFormsByVisitIdAsJson;
    await _updateStorageFromCurrentPreloadedFormsHolder();
  }

  static void _upgradeCurrentFormInForms(OldFormulario form, List<OldFormulario> forms){
    final int indexOfFormInList = forms.indexWhere(
      (OldFormulario f)=>f.id == form.id
    );
    _addFormsDecidedByTheIndexOfFormInList(form, indexOfFormInList, forms);
  }

  static void _addFormsDecidedByTheIndexOfFormInList(OldFormulario form, int indexOfFormInList, List<OldFormulario> forms){
    if(indexOfFormInList != -1)
      _addFormInIndex(form, indexOfFormInList, forms);
    else
      _addFormAtLast(form, forms);
  }

  static void _addFormInIndex(OldFormulario form, int index, List<OldFormulario> forms){
    forms[index] = form;
  }

  static void _addFormAtLast(OldFormulario form, List<OldFormulario> forms){
    forms.add(form);
  }

  static Future<List<OldFormulario>> getPreloadedFormsByVisitId(int visitId)async{
    await _updateCurrentPreloadedFormsHolderFromStorage();
    final List<OldFormulario> preloadedFormsByVisitId = await _getPreloadedFormsByVisitId(visitId);
    return preloadedFormsByVisitId;
  }
  
  static Future<List<OldFormulario>> _getPreloadedFormsByVisitId(int visitId)async{
    final List<Map<String, dynamic>> preloadedFormsByVisitIdAsJson = currentPreloadedFormsHolder.currentData[visitId.toString()];
    final List<OldFormulario> preloadedFormsByVisitId = OldFormularios.fromJson( preloadedFormsByVisitIdAsJson??[] ).formularios;
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