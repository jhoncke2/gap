
import 'dart:convert';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockStorageConnector extends Mock implements StorageConnector{

}

ProjectsLocalDataSourceImpl localDataSource;
MockStorageConnector storageConnector;

String tStringProjects;
List<Map<String, dynamic>> tJsonProjects;
List<ProjectModel> tProjects;

void main(){
  setUp((){
    storageConnector = MockStorageConnector();
    localDataSource = ProjectsLocalDataSourceImpl(storageConnector: storageConnector);

    tStringProjects = callFixture('projects.json');
    tJsonProjects = jsonDecode(tStringProjects).cast<Map<String, dynamic>>();
    tProjects = projectsFromJson(tJsonProjects);    
  });

  group('get projects', (){
    test('should get the projects successfuly', ()async{
      when(storageConnector.getList(any)).thenAnswer((realInvocation) async => tJsonProjects);
      final List<ProjectModel> projects = await localDataSource.getProjects();
      verify(storageConnector.getList(ProjectsLocalDataSourceImpl.PROJECTS_STORAGE_KEY));
      expect(projects, tProjects);
    });
  });

  group('set projects', (){

    test('should set the projects successfuly', ()async{
      await localDataSource.setProjects(tProjects);
      verify(storageConnector.setList(tJsonProjects, ProjectsLocalDataSourceImpl.PROJECTS_STORAGE_KEY));
    });
  });

  group('setChosenProject', (){
    int tChosenProjectId;
    ProjectModel tChosenProject;
    setUp((){
      tChosenProjectId = tProjects[0].id;
      tChosenProject = tProjects[0];
    });
    test('should set the chosen project succesfuly', ()async{
      
      await localDataSource.setChosenProject(tChosenProject);
      verify(storageConnector.setString('$tChosenProjectId', ProjectsLocalDataSourceImpl.CHOSEN_PROJECT_STORAGE_KEY));
    });
  });

  group('getChosenProject', (){
    int tChosenProjectId;
    ProjectModel tChosenProject;
    setUp((){
      tChosenProjectId = tProjects[0].id;
      tChosenProject = tProjects[0];
    });
    test('should get the chosen project succesfuly', ()async{
      when(storageConnector.getString(any)).thenAnswer((realInvocation)async => '$tChosenProjectId');
      when(storageConnector.getList(any)).thenAnswer((_)async => tJsonProjects);
      
      final ProjectModel chosenProject = await localDataSource.getChosenProject();
      
      verify(storageConnector.getString(ProjectsLocalDataSourceImpl.CHOSEN_PROJECT_STORAGE_KEY));
      verify(storageConnector.getList(ProjectsLocalDataSourceImpl.PROJECTS_STORAGE_KEY));
      expect(chosenProject, equals(tChosenProject));
    });
  });
  
  group('deleteAll', (){
    test('should delete all successfuly', ()async{
      await localDataSource.deleteAll();
      verify(storageConnector.remove(ProjectsLocalDataSourceImpl.CHOSEN_PROJECT_STORAGE_KEY));
      verify(storageConnector.remove(ProjectsLocalDataSourceImpl.PROJECTS_STORAGE_KEY));
    });
  });
}