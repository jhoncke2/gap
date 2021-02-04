import 'package:flutter_test/flutter_test.dart';
import 'package:gap/logic/models/entities/project.dart';
import 'package:gap/logic/fake_data/projects.dart' as fakeProjects;
import 'package:gap/logic/fake_data/visits.dart' as fakeVisits;
import 'package:gap/logic/models/entities/visit.dart';
import '../../mock/mock_storage_saver.dart';
import 'storage_saver_tests_old_descriptions.dart' as descriptions;

final String _fakeAuthToken = 'ThisIsAnFakeAuthorizationToken';

final MockStorageSaver storageSaver = MockStorageSaver();

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  group(descriptions.authTokenGroupDescription, (){
    _testSetAuthToken();
    _testGetAuthToken();
    _testRemoveAuthToken();    
  });

  group(descriptions.projectsGroupDescription, (){
    _testSetProjects();
    _testGetProjects();
    _testRemoveProjects();
  });

  group(descriptions.chosenprojectGroupDescription, (){
    _testSetChosenProject();
    _testGetChosenProject();
    _testRemoveChosenProject();
  });

  group(descriptions.visitsGroupDescription, (){
    _testSetVisits();
    _testGetVisits();
    _testRemoveVisits();
  });

  group(descriptions.chosenVisitGroupDescription, (){
    _testSetChosenVisit();
    _testGetChosenVisit();
    _testRemoveChosenVisit();
  });
}

/***********************************************************
 * * * * * * * * * *  Auth  Token  * * * * * * * * * *
 ***********************************************************/

void _testSetAuthToken(){
  test(descriptions.testSetAuthTokenDescription, ()async{
    try{
      await _tryTestSetAuthToken();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestSetAuthToken()async{
  await storageSaver.setAuthToken(_fakeAuthToken);
  _verifyStorageElementIsNoNull('auth_token');
  expect(storageSaver.storage['auth_token'], _fakeAuthToken, reason: 'El auth token en el storageSaver debe ser igual al creado en este test');
}

void _testGetAuthToken(){
  test(descriptions.testGetAuthTokenDescription, ()async{
    try{
      await _tryTestGetAuthToken();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestGetAuthToken()async{
  final String authToken = await storageSaver.getAuthToken();
  expect(authToken, isNotNull, reason: 'El auth token en el storageSaver no debe ser null');
  expect(authToken, _fakeAuthToken, reason: 'El auth token en el storageSaver debe ser igual al creado en este test');
}

void _testRemoveAuthToken(){
  test(descriptions.testRemoveAuthTokenDescription, ()async{
    try{
      await _tryTestRemoveAuthToken();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestRemoveAuthToken()async{
  await storageSaver.deleteAuthToken();
  _verifYRemovedElement('auth_token');
}

void _testSetProjects(){
  test(descriptions.testSetProjectsDescription, ()async{
    try{
      await _tryTestSetProjects();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

/***********************************************************
 * * * * * * * * * *  Projects  * * * * * * * * * *
 ***********************************************************/

Future<void> _tryTestSetProjects()async{
  final List<Project> projects = fakeProjects.projects;
  final List<Map<String, dynamic>> projectsAsJson = _convertProjectsToJson(projects);
  await storageSaver.setProjects(projectsAsJson);
  _verifyStorageElementIsNoNull('projects');
}

List<Map<String, dynamic>> _convertProjectsToJson(List<Project> projects){
  final List<Map<String, dynamic>> projectsAsJson = projects.map<Map<String, dynamic>>(
    (Project p)=>p.toJson()
  ).toList();
  return projectsAsJson;
}

void _testGetProjects(){
  test(descriptions.testGetProjectsDescription, ()async{
    try{
      await _tryTestGetProjects();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestGetProjects()async{
  final List<Map<String, dynamic>> projectsAsJson = await storageSaver.getProjects();
  final List<Project> projects = _convertJsonProjectsToProjects(projectsAsJson);
  _verifyStorageGetReturnedElements(projects, fakeProjects.projects, _compararParDeProjects, 'projects');
}

List<Project> _convertJsonProjectsToProjects(List<Map<String, dynamic>> projectsAsJson){
  final List<Project> projects = projectsAsJson.map<Project>(
    (Map<String, dynamic> p)=>Project.fromJson(p)
  ).toList();
  return projects;
}

void _compararParDeProjects(Project p1, Project p2){
  expect(p1.id, p2.id, reason: 'El id del current project del storageSaver debe ser el mismo que el de los fakeProjects');
  expect(p1.name, p2.name, reason: 'El name del current project del storageSaver debe ser el mismo que el de los fakeProjects');
}

void _testRemoveProjects(){
  test(descriptions.testRemoveProjectsDescription, ()async{
    try{
      await _tryTestRemoveProjects();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestRemoveProjects()async{
  await storageSaver.deleteProjects();
  _verifYRemovedElement('projects');
}

/***********************************************************
 * * * * * * * * * *  Chosen Project  * * * * * * * * * *
 ***********************************************************/

void _testSetChosenProject(){
  test(descriptions.testSetChosenProjectDescription, ()async{
    try{
      await _tryTestSetChosenProject();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestSetChosenProject()async{
  final Project chosenProject = fakeProjects.projects[0];
  final Map<String, dynamic> chosenProjectAsJson = chosenProject.toJson();
  await storageSaver.setChosenProject(chosenProjectAsJson);
  _verifyStorageElementIsNoNull('chosen_project');
}

void _testGetChosenProject(){
  test(descriptions.testGetChosenProjectDescription, ()async{
    try{
      await _tryTestGetChosenProject();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestGetChosenProject()async{
  final Map<String, dynamic> chosenProjectAsJson = await storageSaver.getChosenProject();
  final Project chosenProject = Project.fromJson(chosenProjectAsJson);
  expect(chosenProject, isNotNull, reason: 'El chosen project retornado por el storageSaver no debería ser null');
  _compararParDeProjects(chosenProject, fakeProjects.projects[0]);
}

void _testRemoveChosenProject(){
  test(descriptions.testRemoveProjectsDescription, ()async{
    try{
      await _tryTestRemoveChosenProject();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestRemoveChosenProject()async{
  await storageSaver.deleteChosenProject();
  _verifYRemovedElement('chosen_project');
}

/***********************************************************
 * * * * * * * * * *  Visits  * * * * * * * * * *
 ***********************************************************/

void _testSetVisits(){
  test(descriptions.testSetChosenVisitDescription, ()async{
    try{
      await _tryTestSetVisits();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestSetVisits()async{
  final List<Visit> visits = fakeVisits.visits;
  final List<Map<String, dynamic>> visitsAsJson = _convertVisitsToJson(visits);
  await storageSaver.setVisits(visitsAsJson);
  _verifyStorageElementIsNoNull('visits');
}

List<Map<String, dynamic>> _convertVisitsToJson(List<Visit> projects){
  final List<Map<String, dynamic>> visitsAsJson = projects.map<Map<String, dynamic>>(
    (Visit p)=>p.toJson()
  ).toList();
  return visitsAsJson;
}

void _testGetVisits(){
  test(descriptions.testGetChosenVisitDescription, ()async{   
    try{
      await _tryTestGetVisits();
    }catch(err){
      throw err;
    }
  });
}

Future<void> _tryTestGetVisits()async{
  final List<Map<String, dynamic>> visitsAsJson = await storageSaver.getVisits();
  final List<Visit> visits = _convertJsonProjectsToVisits(visitsAsJson);
  _verifyStorageGetReturnedElements(visits, fakeVisits.visits, _compararParDeVisits, 'visits');
}

List<Visit> _convertJsonProjectsToVisits(List<Map<String, dynamic>> visitsAsJson){
  final List<Visit> visits = visitsAsJson.map<Visit>(
    (Map<String, dynamic> p)=>Visit.fromJson(p)
  ).toList();
  return visits;
}

void _compararParDeVisits(Visit v1, Visit v2){
  expect(v1.name, v2.name, reason: 'El name del current visit del storageSaver debe ser el mismo que el de los fakeProjects');
  expect(v1.date, v2.date, reason: 'El date del current visit del storageSaver debe ser el mismo que el de los fakeProjects');
  expect(v1.stage, v2.stage, reason: 'El stage del current visit del storageSaver debe ser el mismo que el de los fakeProjects');
}

void _testRemoveVisits(){
  test(descriptions.testRemoveChosenVisitDescription, ()async{
    try{
      await _tryTestRemoveVisits();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestRemoveVisits()async{
  await storageSaver.deleteVisits();
  _verifYRemovedElement('visits');
}

/***********************************************************
 * * * * * * * * * *  Chosen Visit  * * * * * * * * * *
 ***********************************************************/

void _testSetChosenVisit(){
  test(descriptions.testGetVisitsDescription, ()async{   
    try{
      await _tryTestSetChosenVisit();
    }catch(err){
      throw err;
    }
  });
}

Future<void> _tryTestSetChosenVisit()async{
  final Visit chosenOne = fakeVisits.visits[0];
  final Map<String, dynamic> chosenOneAsJson = chosenOne.toJson();
  await storageSaver.setChosenVisit(chosenOneAsJson);
  _verifyStorageElementIsNoNull('chosen_visit');
}

void _testGetChosenVisit(){
  test(descriptions.testGetVisitsDescription, ()async{   
    try{
      await _tryTestGetChosenVisit();
    }catch(err){
      throw err;
    }
  });
}

Future<void> _tryTestGetChosenVisit()async{
  final Map<String, dynamic> chosenOneAsJson = await storageSaver.getChosenVisit();
  final Visit chosenOne = Visit.fromJson(chosenOneAsJson);
  expect(chosenOne, isNotNull, reason: 'El visit retornado por el storage no debería ser null');
  _compararParDeVisits(chosenOne, fakeVisits.visits[0]);
}

void _testRemoveChosenVisit(){
  test(descriptions.testRemoveVisitsDescription, ()async{
    try{
      await _tryTestRemoveChosenVisit();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestRemoveChosenVisit()async{
  await storageSaver.deleteChosenVisit();
  _verifYRemovedElement('chosen_visit');
}

void _verifyStorageGetReturnedElements(List<dynamic> storageReturnedElements, List<dynamic> fakeElements, Function compareCoupleOfElements, String elementsName){
  expect(storageReturnedElements, isNotNull, reason: 'Los $elementsName retornados por el storageSaver no deben ser null');
  expect(storageReturnedElements.length, fakeElements.length, reason: 'El length de los $elementsName retornados por el storageSaver debe ser el mismo que el de los fakeProjects');
  for(int i = 0; i < storageReturnedElements.length; i++){
    compareCoupleOfElements(storageReturnedElements[i], fakeElements[i]);
  }
}

void _verifyStorageElementIsNoNull(String storageKey){
  expect(storageSaver.storage[storageKey], isNotNull, reason: 'El campo $storageKey en el storageSaver no debe ser null');
}

void _verifYRemovedElement(String elementKey){
  expect(storageSaver.storage[elementKey], isNull, reason: 'Después de borrar el campo $elementKey en el storage debe ser null');
}