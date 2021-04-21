import 'dart:convert';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/projects_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/project.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';
import '../../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetworkInfo{}

class MockProjectsLocalDataSource extends Mock implements ProjectsLocalDataSource{}

class MockProjectsRemoteDataSource extends Mock implements ProjectsRemoteDataSource{}

ProjectsRepositoryImpl projectsRepository;
MockNetworkInfo networkInfo;
MockProjectsLocalDataSource localDataSource;
MockProjectsRemoteDataSource remoteDataSource;

List<Project> tProjects;

void main(){
  setUp((){
    remoteDataSource = MockProjectsRemoteDataSource();    
    localDataSource = MockProjectsLocalDataSource();
    networkInfo = MockNetworkInfo();
    projectsRepository = ProjectsRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo 
    );
  });

  group('get projects', (){
    setUp((){
      tProjects = _getProjectsFromFixture();
    });
    
    test('should get projects from services when there is connectivity.', ()async{
      when(networkInfo.isConnected()).thenAnswer((realInvocation) async => true);
      await projectsRepository.getProjects();
      verify(remoteDataSource.getProjects());
      verify(localDataSource.setProjects(tProjects));
    });
  });
}

List<Project> _getProjectsFromFixture(){
  final String stringProjects = callFixture('projects.json');
  final List<Map<String, dynamic>> jsonProjects = jsonDecode(stringProjects).cast<Map<String, dynamic>>();
  return projectsFromJson(jsonProjects);
}