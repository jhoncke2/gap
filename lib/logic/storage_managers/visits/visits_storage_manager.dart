import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class VisitsStorageManager{
  static final String _visitsKey = 'visits';
  static final String _chosenVisitKey = 'chosen_visit';

  static Future<void> setVisits(List<OldVisit> visits)async{
    final List<Map<String, dynamic>> visitsAsJson = _convertVisitsToJson(visits);
    await StorageConnectorSingleton.storageConnector.setListResource(_visitsKey, visitsAsJson);
  }
  
  static List<Map<String, dynamic>> _convertVisitsToJson(List<OldVisit> visits){
    return visits.map<Map<String, dynamic>>(
      (OldVisit v)=> v.toJson()
    ).toList();
  }

  static Future<List<OldVisit>> getVisits()async{
    final List<Map<String, dynamic>> visitsAsJson = await StorageConnectorSingleton.storageConnector.getListResource(_visitsKey);
    final List<OldVisit> visits = _convertJsonVisitsToObject(visitsAsJson);
    return visits;
  }

  static List<OldVisit> _convertJsonVisitsToObject(List<Map<String, dynamic>> visitsAsJson){
    return visitsAsJson.map<OldVisit>(
      (Map<String, dynamic> jsonProject) => OldVisit.fromJson(jsonProject)
    ).toList();
  }

  static Future<void> removeVisits()async{
    await StorageConnectorSingleton.storageConnector.removeResource(_visitsKey);
  }

  static Future<void> setChosenVisit(OldVisit visit)async{
    final Map<String, dynamic> visitAsJson = visit.toJson();
    await StorageConnectorSingleton.storageConnector.setMapResource(_chosenVisitKey, visitAsJson);
  }

  static Future<OldVisit> getChosenVisit()async{
    final Map<String, dynamic> visitAsJson = await StorageConnectorSingleton.storageConnector.getMapResource(_chosenVisitKey);
    final OldVisit visit = OldVisit.fromJson(visitAsJson);
    return visit;
  }

  static Future<void> removeChosenVisit()async{
    await StorageConnectorSingleton.storageConnector.removeResource(_chosenVisitKey);
  }
}