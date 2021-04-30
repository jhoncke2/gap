import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';

abstract class VisitsLocalDataSource{
  Future<void> setVisits(List<VisitModel> visits, int projectId);
  Future<List<VisitModel>> getVisits(int projectId);
  Future<void> setChosenVisit(VisitModel visit);
  Future<VisitModel> getChosenVisit(int tChosenProjectId);
  Future<void> deleteAll();
}

class VisitsLocalDataSourceImpl implements VisitsLocalDataSource{
  static const BASE_VISITS_STORAGE_KEY = 'visits_of';
  static const CHOSEN_VISIT_STORAGE_KEY = 'chosen_visit';
  
  final StorageConnector storageConnector;

  VisitsLocalDataSourceImpl({
    @required this.storageConnector
  });

  @override
  Future<void> setVisits(List<VisitModel> visits, int projectId)async{
    final List<Map<String, dynamic>> jsonVisits = visitsToStorageJson(visits);
    await storageConnector.setList(jsonVisits, '${BASE_VISITS_STORAGE_KEY}_$projectId');
  }

  @override
  Future<List<VisitModel>> getVisits(int projectId)async{
    final List<Map<String, dynamic>> jsonVisits = await storageConnector.getList('${BASE_VISITS_STORAGE_KEY}_$projectId');
    return visitsFromStorageJson(jsonVisits);
  }

  @override
  Future<void> setChosenVisit(VisitModel visit)async{
    await storageConnector.setString('${visit.id}', CHOSEN_VISIT_STORAGE_KEY);
  }

  @override
  Future<VisitModel> getChosenVisit(int tChosenProjectId)async{
    final String stringChosenVisitId = await storageConnector.getString(CHOSEN_VISIT_STORAGE_KEY);
    final int chosenVisitId = int.parse(stringChosenVisitId);
    final List<Map<String, dynamic>> jsonVisits = await storageConnector.getList('${BASE_VISITS_STORAGE_KEY}_$tChosenProjectId');
    final Map<String, dynamic> jsonChosenVisit = jsonVisits.singleWhere((v) => v['id'] == chosenVisitId);
    return VisitModel.fromJson(jsonChosenVisit);
  }

  Future<void> deleteAll()async{
    await storageConnector.remove(CHOSEN_VISIT_STORAGE_KEY);
    await storageConnector.remove(BASE_VISITS_STORAGE_KEY);
  }
}