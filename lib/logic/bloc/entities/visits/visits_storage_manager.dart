import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class VisitsStorageManager{
  final String visitsKey = 'visits';
  final String chosenVisitKey = 'chosen_visit';
  final StorageConnector storageConnector;
  VisitsStorageManager():
    this.storageConnector = StorageConnectorSingleton.storageConnector
    ;

  VisitsStorageManager.forTesting({
    @required this.storageConnector
  });

  Future<void> setVisits(List<Visit> visits)async{
    final List<Map<String, dynamic>> visitsAsJson = _convertVisitsToJson(visits);
    await storageConnector.setListResource(visitsKey, visitsAsJson);
  }
  List<Map<String, dynamic>> _convertVisitsToJson(List<Visit> visits){
    return visits.map<Map<String, dynamic>>(
      (Visit v)=> v.toJson()
    ).toList();
  }

  Future<List<Visit>> getVisits()async{
    final List<Map<String, dynamic>> visitsAsJson = await storageConnector.getListResource(visitsKey);
    final List<Visit> visits = _convertJsonProjectsToObject(visitsAsJson);
    return visits;
  }
  List<Visit> _convertJsonProjectsToObject(List<Map<String, dynamic>> visitsAsJson){
    return visitsAsJson.map<Visit>(
      (Map<String, dynamic> jsonProject) => Visit.fromJson(jsonProject)
    ).toList();
  }

  Future<void> deleteVisits()async{
    await storageConnector.removeResource(visitsKey);
  }

  Future<void> setChosenVisit(Visit visit)async{
    final Map<String, dynamic> visitAsJson = visit.toJson();
    await storageConnector.setMapResource(chosenVisitKey, visitAsJson);
  }

  Future<Visit> getChosenVisit()async{
    final Map<String, dynamic> visitAsJson = await storageConnector.getMapResource(chosenVisitKey);
    final Visit visit = Visit.fromJson(visitAsJson);
    return visit;
  }

  Future<void> removeChosenVisit()async{
    await storageConnector.removeResource(chosenVisitKey);
  }
}