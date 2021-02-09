//TODO: Implementar testing
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/logic/bloc/entities/projects/projects_storage_manager.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/data/fake_data/fake_data.dart' as fakeProjects;
import '../../../mock/mock_storage_manager.dart';
import './projects_storage_manager_descriptions.dart' as descriptions;

final ProjectsStorageManager projectsStorageManager = ProjectsStorageManager.forTesting(storageConnector: MockStorageConnector());

main(){
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
  await projectsStorageManager.setProjects(projects);
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
  final List<Project> projects = await projectsStorageManager.getProjects();
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
  await projectsStorageManager.removeProjects();
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
  await projectsStorageManager.setChosenProject(chosenProject);
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
  final Project chosenProject = await projectsStorageManager.getChosenProject();
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
  await projectsStorageManager.removeChosenProject();
}
