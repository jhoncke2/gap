import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded/preloaded_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/features/projects/data/repository/projects_repository.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/entities/project.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetworkInfo{}

class MockProjectsLocalDataSource extends Mock implements ProjectsLocalDataSource{}

class MockProjectsRemoteDataSource extends Mock implements ProjectsRemoteDataSource{}

class MockPreloadedLocalDataSource extends Mock implements PreloadedLocalDataSource{}

class MockUserLocalDataSource extends Mock implements UserLocalDataSource{}

ProjectsRepositoryImpl projectsRepository;
MockNetworkInfo networkInfo;
MockProjectsLocalDataSource localDataSource;
MockProjectsRemoteDataSource remoteDataSource;
MockPreloadedLocalDataSource preloadedLocalDataSource;
MockUserLocalDataSource userLocalDataSource;

List<Project> tProjects;

void main(){
  setUp((){
    remoteDataSource = MockProjectsRemoteDataSource();    
    localDataSource = MockProjectsLocalDataSource();
    preloadedLocalDataSource = MockPreloadedLocalDataSource();
    networkInfo = MockNetworkInfo();
    userLocalDataSource = MockUserLocalDataSource();
    projectsRepository = ProjectsRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
      preloadedLocalDataSource: preloadedLocalDataSource,
      userLocalDataSource: userLocalDataSource
    );
  });

  group('get projects', (){
    String tAccessToken;
    setUp((){
      tProjects = _getProjectsFromFixture();
      tAccessToken = 'access_token';
    });
    
    test('should get projects from remoteDataSource with tAccessToken when there is connectivity.', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.getProjects(any)).thenAnswer((_) async => tProjects);
      await projectsRepository.getProjects();
      verify(userLocalDataSource.getAccessToken());
      verify(remoteDataSource.getProjects(tAccessToken));
      verify(localDataSource.setProjects(tProjects));
    });

    
    test('should get projects from localDataSource when there is not connectivity.', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(preloadedLocalDataSource.getPreloadedProjectsIds()).thenAnswer((_) async => tProjects.map((p) => p.id).toList());
      when(localDataSource.getProjects()).thenAnswer((realInvocation) async => tProjects );
      await projectsRepository.getProjects();
      verify(preloadedLocalDataSource.getPreloadedProjectsIds());
      verify(localDataSource.getProjects());
    });

    test('should get Right(tProjects) wthere there is connectivity and remoteDataSource returns good response.', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.getProjects(any)).thenAnswer((realInvocation) async => tProjects);
      final response = await projectsRepository.getProjects();
      expect(response.isRight(), true);
      response.fold((l) => null, (r){
        expect(r, tProjects);
      });
    });
    
    test('should get Left(ServerFailure) wthere is not connectivity and remoteDataSource throws ServerException.', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.getProjects(any)).thenThrow(ServerException());
      final response = await projectsRepository.getProjects();
      expect(response, Left(ServerFailure()));
    });

    test('should get Right(tProjects) when there is not connectivity and localDataSource returns good response.', ()async{
      final List<Project> tPreloadedProjects = [_getProjectsFromFixture()[0]];
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(preloadedLocalDataSource.getPreloadedProjectsIds()).thenAnswer((_) async => [tPreloadedProjects[0].id]);
      when(localDataSource.getProjects()).thenAnswer((realInvocation) async => tProjects);
      final response = await projectsRepository.getProjects();
      expect(response.isRight(), true);
      response.fold((l) => null, (r){
        expect(r, tPreloadedProjects);
      });
    });

    test('should get Left(StorageFailure) when there is not connectivity and remoteDataSource throws StorageException.', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(localDataSource.getProjects()).thenThrow(StorageException(type: StorageExceptionType.NORMAL));
      final response = await projectsRepository.getProjects();
      expect(response, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    });
  });

  group('setChosenProject', (){
    ProjectModel tProject;
    setUp((){
      tProject = _getProjectsFromFixture()[0];
    });

    test('should set chosenProject in remoteDataSource when there is connectivity.', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      await projectsRepository.setChosenProject(tProject);
      verify(localDataSource.setChosenProject(tProject));
    });

    test('should set chosenProject in remoteDataSource when there is not connectivity.', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      await projectsRepository.setChosenProject(tProject);
      verify(localDataSource.setChosenProject(tProject));
    });

    test('should return Right(void) when all goes good.', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      final response = await projectsRepository.setChosenProject(tProject);
      expect(response, Right(null));
    });
    
    test('should return Left(ServerFailure) when localDataSource throws a StorageFailure.', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(localDataSource.setChosenProject(any)).thenThrow(StorageException(type: StorageExceptionType.NORMAL));
      final response = await projectsRepository.setChosenProject(tProject);
      expect(response, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    });
  });

  group('getChosenProject', (){
    ProjectModel tProject;
    setUp((){
      tProject = _getProjectsFromFixture()[0];
    });

    test('should get chosenProject from remoteDataSource when there is connectivity', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      await projectsRepository.getChosenProject();
      verify(localDataSource.getChosenProject());
    });

    test('should get chosenProject from remoteDataSource when there is not connectivity', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      await projectsRepository.getChosenProject();
      verify(localDataSource.getChosenProject());
    });

    test('should get Right(tProject) when all is good', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(localDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      final response = await projectsRepository.getChosenProject();
      expect(response, Right(tProject));
    });

    test('should get Left(StorageFailure) when localDataSource throws a StorageException', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(localDataSource.getChosenProject()).thenThrow(StorageException(type: StorageExceptionType.NORMAL));
      final response = await projectsRepository.getChosenProject();
      expect(response, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    });
  });
}

List<Project> _getProjectsFromFixture(){
  final String stringProjects = callFixture('projects.json');
  final List<Map<String, dynamic>> jsonProjects = jsonDecode(stringProjects).cast<Map<String, dynamic>>();
  return projectsFromJson(jsonProjects);
}