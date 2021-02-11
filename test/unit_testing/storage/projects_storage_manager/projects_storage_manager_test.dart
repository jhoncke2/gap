//TODO: Implementar testing
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/logic/bloc/entities/projects/projects_storage_manager.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/data/fake_data/fake_data.dart' as fakeProjects;
import 'package:gap/native_connectors/storage_connector.dart';
import '../../../mock/storage/mock_flutter_secure_storage.dart';
import './projects_storage_manager_descriptions.dart' as descriptions;

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
    //_testGetProjecstWithPreloadedVisits();
  });
}

void _initStorageConnector(){
  // ignore: invalid_use_of_protected_member
  StorageConnectorSingleton.storageConnector.fss = MockFlutterSecureStorage();
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
  final List<Project> projects = fakeProjects.projects;
  await ProjectsStorageManager.setProjects(projects);
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
  final List<Project> projects = await ProjectsStorageManager.getProjects();
  _verifyReturnedProjects(projects);
}

void _verifyReturnedProjects(List<Project> storageReturnedElements){
  expect(storageReturnedElements, isNotNull, reason: 'Los projects retornados por el storageSaver no deben ser null');
  expect(storageReturnedElements.length, fakeProjects.projects.length, reason: 'El length de los projects retornados por el storageSaver debe ser el mismo que el de los fakeProjects');
  for(int i = 0; i < storageReturnedElements.length; i++){
    _compararParDeProjects(storageReturnedElements[i], fakeProjects.projects[i]);
  }
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
  await ProjectsStorageManager.removeProjects();
}


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
  await ProjectsStorageManager.setChosenProject(chosenProject);
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
  final Project chosenProject = await ProjectsStorageManager.getChosenProject();
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
  await ProjectsStorageManager.removeChosenProject();
}


void _testGetProjecstWithPreloadedVisits(){
  test(descriptions.testGetProjectsWithPreloadedVisitsDescription, ()async{
    try{
      await _tryTestGetProjecstWithPreloadedVisits();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestGetProjecstWithPreloadedVisits()async{
  final List<Project> projects =  await ProjectsStorageManager.getProjectsWithPreloadedVisits();
  expect(projects, isNotNull, reason: 'Los projectos del projectsStorageManager no deberian ser null');
}