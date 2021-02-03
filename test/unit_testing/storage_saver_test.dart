import 'package:flutter_test/flutter_test.dart';
import 'package:gap/logic/models/entities/project.dart';
import 'package:gap/logic/fake_data/projects.dart' as fakeProjects;
import 'package:gap/logic/fake_data/visits.dart' as fakeVisits;
import 'package:gap/logic/models/entities/visit.dart';
import '../mock/mock_storage_saver.dart';

final String _authTokenGroupDescription = 'Se testeará el método de set, get, y delete authorization token';
final String _testSetAuthTokenDescription = 'Se testeará el método de set el authorization token';
final String _testGetAuthTokenDescription = 'Se testeará el método de get el authorization token';
final String _testRemoveAuthTokenDescription = 'Se testeará el método de remove el authorization token';
final String _projectsGroupDescription = 'Se testeará el método de set, get, y delete projects';
final String _testSetProjectsDescription = 'Se testeará el método de set projects';
final String _testGetProjectsDescription = 'Se testeará el método de get projects';
final String _testRemoveProjectsDescription = 'Se testeará el método de remove projects';
final String _visitsGroupDescription = 'Se testeará el método de set, get, y delete visits';
final String _testSetVisitsDescription = 'Se testeará el método de set visits';
final String _testGetVisitsDescription = 'Se testeará el método de get visits';
final String _testRemoveVisitsDescription = 'Se testeará el método de remove visits';

final String _fakeAuthToken = 'ThisIsAnFakeAuthorizationToken';

final MockStorageSaver storageSaver = MockStorageSaver();

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  group(_authTokenGroupDescription, (){
    _testSetAuthToken();
    _testGetAuthToken();
    _testRemoveAuthToken();    
  });

  group(_projectsGroupDescription, (){
    _testSetProjects();
    _testGetProjects();
    _testRemoveProjects();
  });

  group(_visitsGroupDescription, (){
    _testSetVisits();
    _testGetVisits();
    _testRemoveVisits();
  });
}

/***********************************************************
 * * * * * * * * * *  Auth  Token  * * * * * * * * * *
 ***********************************************************/


void _testSetAuthToken(){
  test(_testSetAuthTokenDescription, ()async{
    try{
      await _tryTestSetAuthToken();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestSetAuthToken()async{
  await storageSaver.setAuthToken(_fakeAuthToken);
  expect(storageSaver.storage['auth_token'], isNotNull, reason: 'El auth token en el storageSaver no debe ser null');
  expect(storageSaver.storage['auth_token'], _fakeAuthToken, reason: 'El auth token en el storageSaver debe ser igual al creado en este test');
}

void _testGetAuthToken(){
  test(_testGetAuthTokenDescription, ()async{
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
  test(_testRemoveAuthTokenDescription, ()async{
    try{
      await _tryTestRemoveAuthToken();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestRemoveAuthToken()async{
  await storageSaver.deleteAuthToken();
  expect(storageSaver.storage['auth_token'], isNull, reason: 'El auth token en el storageSaver sí debe ser null');
}

void _testSetProjects(){
  test(_testSetProjectsDescription, ()async{
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
  expect(storageSaver.storage['projects'], isNotNull, reason: 'Los projects en el storageSaver no debe ser null');
}

List<Map<String, dynamic>> _convertProjectsToJson(List<Project> projects){
  final List<Map<String, dynamic>> projectsAsJson = projects.map<Map<String, dynamic>>(
    (Project p)=>p.toJson()
  ).toList();
  return projectsAsJson;
}

void _testGetProjects(){
  test(_testGetProjectsDescription, ()async{
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
  expect(projects, isNotNull, reason: 'Los projects retornados por el storageSaver no deben ser null');
  expect(projects.length, fakeProjects.projects.length, reason: 'El length de los projects retornados por el storageSaver debe ser el mismo que el de los fakeProjects');
  for(int i = 0; i < projects.length; i++){
    _compararParDeProjects(projects[i], fakeProjects.projects[i]);
  }
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
  test(_testRemoveProjectsDescription, ()async{
    try{
      await _tryTestRemoveProjects();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestRemoveProjects()async{
  await storageSaver.deleteProjects();
  expect(storageSaver.storage['projects'], isNull, reason: 'Después de borrar los projects, su campo en el storage debe ser null');
}

/***********************************************************
 * * * * * * * * * *  Visits  * * * * * * * * * *
 ***********************************************************/


void _testSetVisits(){
  test(_testSetVisitsDescription, ()async{
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
  expect(storageSaver.storage['visits'], isNotNull, reason: 'Las visits en el storageSaver no debe ser null');
}

List<Map<String, dynamic>> _convertVisitsToJson(List<Visit> projects){
  final List<Map<String, dynamic>> visitsAsJson = projects.map<Map<String, dynamic>>(
    (Visit p)=>p.toJson()
  ).toList();
  return visitsAsJson;
}

void _testGetVisits(){
  test(_testGetVisitsDescription, ()async{   
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
  expect(visits, isNotNull, reason: 'Los visits retornados por el storageSaver no deben ser null');
  expect(visits.length, fakeVisits.visits.length, reason: 'El length de los visits retornados por el storageSaver debe ser el mismo que el de los fakeProjects');
  for(int i = 0; i < visits.length; i++){
    _compararParDeVisits(visits[i], fakeVisits.visits[i]);
  }
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
  test(_testRemoveVisitsDescription, ()async{
    try{
      await _tryTestRemoveVisits();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestRemoveVisits()async{
  await storageSaver.deleteVisits();
  expect(storageSaver.storage['visits'], isNull, reason: 'Después de borrar los visits, su campo en el storage debe ser null');
}