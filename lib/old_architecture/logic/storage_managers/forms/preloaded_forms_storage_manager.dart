import 'package:flutter/material.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/native_connectors/storage_connector.dart';

class PreloadedFormsStorageManager{
  static final String _preloadedFormsKey = 'preloaded_forms_old';
  @protected
  static final _PreloadedFormsHolder currentPreloadedFormsHolder = _PreloadedFormsHolder();

  static Future<void> removePreloadedForm(int formId, int visitId)async{
    await _updateCurrentPreloadedFormsHolderFromStorage();
    final List<FormularioOld> preloadedFormsByVisitId = await _getPreloadedFormsByVisitId(visitId);
    final List<FormularioOld> restantPreloadedFormsByVisitId = _obtainRestantPreloadedFormsByVisitId(preloadedFormsByVisitId, formId);
    await _executeRemoving(restantPreloadedFormsByVisitId, visitId);
    await _updateStorageFromCurrentPreloadedFormsHolder();
  }

  static List<FormularioOld> _obtainRestantPreloadedFormsByVisitId(List<FormularioOld> preloadedFormsByVisitId, int visitId){
    final List<FormularioOld> restantPreloadedFormsByVisitId = preloadedFormsByVisitId.where(
      (FormularioOld v)=>v.id != visitId
    ).toList();
    return restantPreloadedFormsByVisitId;
  }

  static Future<void> _executeRemoving(List<FormularioOld> restantPreloadedFormsByVisitId, int visitId)async{
    if(restantPreloadedFormsByVisitId.length == 0)
      _removeFormsFromFormsByVisitIdMap(visitId);
    else
      _updateVisitIdMapWithoutRemovedForm(restantPreloadedFormsByVisitId, visitId);  
  }

  static void _removeFormsFromFormsByVisitIdMap( int visitId){
    currentPreloadedFormsHolder.currentData.remove(visitId.toString());
  }
  
  static void _updateVisitIdMapWithoutRemovedForm(List<FormularioOld> restantPreloadedFormsByVisitId, int visitId){
    final List<Map<String, dynamic>> restantPrelFormsByVisitIdAsJson = formulariosToJsonOld(restantPreloadedFormsByVisitId);
    currentPreloadedFormsHolder.currentData[visitId.toString()] = restantPrelFormsByVisitIdAsJson;
  }

  static Future<void> setPreloadedForm(FormularioOld form, int visitId)async{
    await _updateCurrentPreloadedFormsHolderFromStorage();
    final List<FormularioOld> preloadedFormsByVisitId = await _getPreloadedFormsByVisitId(visitId);
    //preloadedFormsByVisittId.add(form);
    _upgradeCurrentFormInForms(form, preloadedFormsByVisitId);
    final List<Map<String, dynamic>> preloadedFormsByVisitIdAsJson = formulariosToJsonOld(preloadedFormsByVisitId);
    currentPreloadedFormsHolder.currentData[visitId.toString()] = preloadedFormsByVisitIdAsJson;
    await _updateStorageFromCurrentPreloadedFormsHolder();
  }

  static void _upgradeCurrentFormInForms(FormularioOld form, List<FormularioOld> forms){
    final int indexOfFormInList = forms.indexWhere( (FormularioOld f)=>f.id == form.id );
    _addFormsDecidedByTheIndexOfFormInList(form, indexOfFormInList, forms);
  }

  static void _addFormsDecidedByTheIndexOfFormInList(FormularioOld form, int indexOfFormInList, List<FormularioOld> forms){
    if(indexOfFormInList != -1)
      _addFormAtIndex(form, indexOfFormInList, forms);
    else
      _addFormAtLast(form, forms);
  }

  static void _addFormAtIndex(FormularioOld form, int index, List<FormularioOld> forms){
    forms[index] = form;
  }

  static void _addFormAtLast(FormularioOld form, List<FormularioOld> forms){
    forms.add(form);
  }

  static Future<List<FormularioOld>> getPreloadedFormsByVisitId(int visitId)async{
    await _updateCurrentPreloadedFormsHolderFromStorage();
    final List<FormularioOld> preloadedFormsByVisitId = await _getPreloadedFormsByVisitId(visitId);
    return preloadedFormsByVisitId;
  }
  
  static Future<List<FormularioOld>> _getPreloadedFormsByVisitId(int visitId)async{
    final List<Map<String, dynamic>> preloadedFormsByVisitIdAsJson = currentPreloadedFormsHolder.currentData[visitId.toString()];
    final List<FormularioOld> preloadedFormsByVisitId = formulariosFromJsonOld( preloadedFormsByVisitIdAsJson??[] );
    return preloadedFormsByVisitId;
  }

  static Future<void> _updateCurrentPreloadedFormsHolderFromStorage()async{
    final Map<dynamic, dynamic> tempMap = (await StorageConnectorOldSingleton.storageConnector.getMapResource(_preloadedFormsKey));
    currentPreloadedFormsHolder.initFromJson(tempMap);
  }
  
  static Future<void> _updateStorageFromCurrentPreloadedFormsHolder()async{
    print(currentPreloadedFormsHolder.currentData.runtimeType);
    await StorageConnectorOldSingleton.storageConnector.setMapResource(_preloadedFormsKey, currentPreloadedFormsHolder.toJson());
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