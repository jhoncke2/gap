import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/native_connectors/storage_connector.dart';

class VisitsStorageManager{
  static final String _visitsKey = 'visits';
  static final String _chosenVisitKey = 'chosen_visit';

  static Future<void> setVisits(List<VisitOld> visits)async{
    final List<Map<String, dynamic>> visitsAsJson = _convertVisitsToJson(visits);
    await StorageConnectorOldSingleton.storageConnector.setListResource(_visitsKey, visitsAsJson);
  }
  
  static List<Map<String, dynamic>> _convertVisitsToJson(List<VisitOld> visits){
    return visits.map<Map<String, dynamic>>(
      (VisitOld v)=> v.toJson()
    ).toList();
  }

  static Future<List<VisitOld>> getVisits()async{
    final List<Map<String, dynamic>> visitsAsJson = await StorageConnectorOldSingleton.storageConnector.getListResource(_visitsKey);
    final List<VisitOld> visits = _convertJsonVisitsToObject(visitsAsJson);
    return visits;
  }

  static List<VisitOld> _convertJsonVisitsToObject(List<Map<String, dynamic>> visitsAsJson){
    return visitsAsJson.map<VisitOld>(
      (Map<String, dynamic> jsonProject) => VisitOld.fromJson(jsonProject)
    ).toList();
  }

  static Future<void> removeVisits()async{
    await StorageConnectorOldSingleton.storageConnector.removeResource(_visitsKey);
  }

  static Future<void> setChosenVisit(VisitOld visit)async{
    final Map<String, dynamic> visitAsJson = visit.toJson();
    await StorageConnectorOldSingleton.storageConnector.setMapResource(_chosenVisitKey, visitAsJson);
  }

  static Future<VisitOld> getChosenVisit()async{
    final Map<String, dynamic> visitAsJson = await StorageConnectorOldSingleton.storageConnector.getMapResource(_chosenVisitKey);
    final VisitOld visit = VisitOld.fromJson(visitAsJson);
    return visit;
  } 

  static Future<void> removeChosenVisit()async{
    await StorageConnectorOldSingleton.storageConnector.removeResource(_chosenVisitKey);
  }
}