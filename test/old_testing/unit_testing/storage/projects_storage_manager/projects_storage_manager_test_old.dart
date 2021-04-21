//TODO: Implementar testing
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/old_architecture/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/data/fake_data/fake_data.dart' as fakeData;
import 'projects_storage_manager_descriptions.dart' as descriptions;

/*
main(){
  _initStorageConnector();
  
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
  
  group(descriptions.projectsWithPreloadedVisitsGroupDescription, (){
    _testSetProjecstWithPreloadedVisits();
    _testGetProjecstWithPreloadedVisits();
    _testRemoveProjectWithPreloadedVisits();
  });
}
*/

void _initStorageConnector(){
  // ignore: invalid_use_of_protected_member
  //StorageConnectorSingleton.storageConnector.fss = MockFlutterSecureStorage();
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

Future<void> _tryTestSetProjects()async{
  final List<ProjectOld> projects = fakeData.oldProjects;
  await ProjectsStorageManager.setProjects(projects);
}

void _testGetProjects(){
  test(descriptions.testGetProjectsDescription, ()async{
      await _tryTestGetProjects();

  });
}

Future<void> _tryTestGetProjects()async{
  final List<ProjectOld> projects = await ProjectsStorageManager.getProjects();
  _verifyReturnedProjects(projects);
}



void _testRemoveProjects(){
  test(descriptions.testRemoveProjectsDescription, ()async{
      await _tryTestRemoveProjects();

  });
}

Future<void> _tryTestRemoveProjects()async{
  await ProjectsStorageManager.removeProjects();
}


void _testSetChosenProject(){
  test(descriptions.testSetChosenProjectDescription, ()async{
      await _tryTestSetChosenProject();

  });
}

Future<void> _tryTestSetChosenProject()async{
  final ProjectOld chosenProject = fakeData.oldProjects[0];
  await ProjectsStorageManager.setChosenProject(chosenProject);
}

void _testGetChosenProject(){
  test(descriptions.testGetChosenProjectDescription, ()async{
      await _tryTestGetChosenProject();

  });
}

Future<void> _tryTestGetChosenProject()async{
  final ProjectOld chosenProject = await ProjectsStorageManager.getChosenProject();
  expect(chosenProject, isNotNull, reason: 'El chosen project retornado por el storageSaver no debería ser null');
  _compararParDeProjects(chosenProject, fakeData.oldProjects[0]);
}

void _testRemoveChosenProject(){
  test(descriptions.testRemoveProjectsDescription, ()async{
      await _tryTestRemoveChosenProject();

  });
}

Future<void> _tryTestRemoveChosenProject()async{
  await ProjectsStorageManager.removeChosenProject();
}

void _testSetProjecstWithPreloadedVisits(){
  test(descriptions.testSetProjectWithPreloadedVisitsDescription, ()async{
      await _tryTestSetProjecstWithPreloadedVisits();

  });
}

Future<void> _tryTestSetProjecstWithPreloadedVisits()async{
  for(int i = 0; i < fakeData.oldProjects.length; i++){
    final ProjectOld p = fakeData.oldProjects[i];
    await ProjectsStorageManager.setProjectWithPreloadedVisits(p);
  }
}

void _testGetProjecstWithPreloadedVisits(){
  test(descriptions.testGetProjectsWithPreloadedVisitsDescription, ()async{
      await _tryTestGetProjecstWithPreloadedVisits();

  });
}

Future<void> _tryTestGetProjecstWithPreloadedVisits()async{
  final List<ProjectOld> projects =  await ProjectsStorageManager.getProjectsWithPreloadedVisits();
  expect(projects, isNotNull, reason: 'Los projectos del projectsStorageManager no deberian ser null');
  _verifyReturnedProjects(projects);
}

void _verifyReturnedProjects(List<ProjectOld> storageReturnedElements){
  expect(storageReturnedElements, isNotNull, reason: 'Los projects retornados por el storage no deben ser null');
  expect(storageReturnedElements.length, fakeData.oldProjects.length, reason: 'El length de los projects retornados por el storage debe ser el mismo que el de los fakeProjects');
  for(int i = 0; i < storageReturnedElements.length; i++){
    _compararParDeProjects(storageReturnedElements[i], fakeData.oldProjects[i]);
  }
}

void _compararParDeProjects(ProjectOld p1, ProjectOld p2){
  expect(p1.id, p2.id, reason: 'El id del current project del storage debe ser el mismo que el de los fakeProjects');
  expect(p1.nombre, p2.nombre, reason: 'El name del current project del storage debe ser el mismo que el de los fakeProjects');
}

Future<void> _testRemoveProjectWithPreloadedVisits()async{
  test(descriptions.testGetProjectsWithPreloadedVisitsDescription, ()async{
      await _tryTestRemoveProjectWithPreloadedVisits();

  });
}

Future<void> _tryTestRemoveProjectWithPreloadedVisits()async{
  for(int i = 0; i < fakeData.oldProjects.length; i++){
    await ProjectsStorageManager.removeProjectWithPreloadedVisits(fakeData.oldProjects[i].id);
    final List<ProjectOld> projectsWithPreloadedVisits = await ProjectsStorageManager.getProjectsWithPreloadedVisits();
    _ensureProjectIsntInProjects(fakeData.oldProjects[i], projectsWithPreloadedVisits);
  }
}

void _ensureProjectIsntInProjects(ProjectOld project, List<ProjectOld> projects){
  for(int i = 0; i < projects.length; i++){
    expect(project.id, isNot(projects[i].id), reason: 'El projecto que se acabó de borrar no puede estar entre los projects with preloaded visits');
  }
}
