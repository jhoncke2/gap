import 'package:gap/logic/storage_managers/central_storage_manager/ids_storage_models.dart';
import 'package:test/test.dart';
import './testing_data.dart';

void main(){
  _testVisitIdJson();
  _testProjectsIdJson();
}

void _testVisitIdJson(){
  test('Se testeará el formateo de visitsids', (){
    final Map<String, dynamic> jsonVisitsIds = jsonProjectsIds['1'];
    final List<StorageIdVisit> visitsIds = visitsIdsFromJson(jsonVisitsIds);
    _expectVisitsIdsList(visitsIds, jsonVisitsIds);
    expect(visitsIdsToJson(visitsIds), jsonVisitsIds);
  });
}

void _expectVisitsIdsList(List<StorageIdVisit> visitsIds, Map<String, dynamic> jsonVisitsIds){
  expect(visitsIds, isNotNull);
  expect(visitsIds.length, jsonVisitsIds.length);
  visitsIds.forEach((v) {
    expect(v.id, isNotNull);
    expect(jsonVisitsIds.containsKey('${v.id}'), true);
    expect(jsonVisitsIds['${v.id}'], v.formsIds);
  });
}

void _testProjectsIdJson(){
  test('Se testeará el formateo de projectsIds', (){
    final List<StorageIdProject> projectsIds = projectsIdsFromJson(jsonProjectsIds);
    _expectProjectsIdsList(projectsIds, jsonProjectsIds);
    expect(projectsIdsToJson(projectsIds), jsonProjectsIds);
  });
}

void _expectProjectsIdsList(List<StorageIdProject> projectsIds, Map<String, dynamic> jsonProjectsIds){
  expect(projectsIds, isNotNull);
  expect(projectsIds.length, jsonProjectsIds.length);
  projectsIds.forEach((p) {
    expect(p.id, isNotNull);
    expect(jsonProjectsIds.containsKey('${p.id}'), true);
    expect(jsonProjectsIds['${p.id}'], visitsIdsToJson(p.visits));
  });
}