import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class VisitsStorageManager{
  static final String visitsKey = 'visits';
  static final String chosenVisitKey = 'chosen_visit';
  static final String preloadedVisitsKey = 'preloaded_visits';

  static Future<void> setVisits(List<Visit> visits)async{
    final List<Map<String, dynamic>> visitsAsJson = _convertVisitsToJson(visits);
    await StorageConnectorSingleton.storageConnector.setListResource(visitsKey, visitsAsJson);
  }
  
  static List<Map<String, dynamic>> _convertVisitsToJson(List<Visit> visits){
    return visits.map<Map<String, dynamic>>(
      (Visit v)=> v.toJson()
    ).toList();
  }

  static Future<List<Visit>> getVisits()async{
    final List<Map<String, dynamic>> visitsAsJson = await StorageConnectorSingleton.storageConnector.getListResource(visitsKey);
    final List<Visit> visits = _convertJsonVisitsToObject(visitsAsJson);
    return visits;
  }

  static List<Visit> _convertJsonVisitsToObject(List<Map<String, dynamic>> visitsAsJson){
    return visitsAsJson.map<Visit>(
      (Map<String, dynamic> jsonProject) => Visit.fromJson(jsonProject)
    ).toList();
  }

  static Future<void> removeVisits()async{
    await StorageConnectorSingleton.storageConnector.removeResource(visitsKey);
  }

  static Future<void> setChosenVisit(Visit visit)async{
    final Map<String, dynamic> visitAsJson = visit.toJson();
    await StorageConnectorSingleton.storageConnector.setMapResource(chosenVisitKey, visitAsJson);
  }

  static Future<Visit> getChosenVisit()async{
    final Map<String, dynamic> visitAsJson = await StorageConnectorSingleton.storageConnector.getMapResource(chosenVisitKey);
    final Visit visit = Visit.fromJson(visitAsJson);
    return visit;
  }

  static Future<void> removeChosenVisit()async{
    await StorageConnectorSingleton.storageConnector.removeResource(chosenVisitKey);
  }
}