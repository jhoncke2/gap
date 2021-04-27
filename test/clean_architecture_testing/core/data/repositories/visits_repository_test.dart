import 'dart:convert';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded/preloaded_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/visits/visits_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/visits/visits_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/visits_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';
import '../../../fixtures/fixture_reader.dart';

class MockVisitsRemoteDataSource extends Mock implements VisitsRemoteDataSource{}
class MockVisitsLocalDataSource extends Mock implements VisitsLocalDataSource{}
class MockPreloadedLocalDataSource extends Mock implements PreloadedLocalDataSource{}
class MockNetworkInfo extends Mock implements NetworkInfo{}
class MockProjectsLocalDataSource extends Mock implements ProjectsLocalDataSource{}
class MockFormulariosRemoteDataSource extends Mock implements FormulariosRemoteDataSource{}
class MockUserLocalDataSource extends Mock implements UserLocalDataSource{}

VisitsRepositoryImpl visitsRepository;
MockNetworkInfo networkInfo;
ProjectsLocalDataSource projectsLocalDataSource;
MockFormulariosRemoteDataSource formulariosRemoteDataSource;
MockVisitsRemoteDataSource remoteDataSource;
MockVisitsLocalDataSource localDataSource;
MockPreloadedLocalDataSource preloadedDataSource;
MockUserLocalDataSource userLocalDataSource;

void main(){
  setUp((){
    userLocalDataSource = MockUserLocalDataSource();
    preloadedDataSource = MockPreloadedLocalDataSource();
    localDataSource= MockVisitsLocalDataSource();
    remoteDataSource = MockVisitsRemoteDataSource();
    projectsLocalDataSource = MockProjectsLocalDataSource();
    formulariosRemoteDataSource = MockFormulariosRemoteDataSource();
    networkInfo = MockNetworkInfo();
    visitsRepository = VisitsRepositoryImpl(
      networkInfo: networkInfo,
      projectsLocalDataSource: projectsLocalDataSource,
      formulariosRemoteDataSource: formulariosRemoteDataSource,
      remoteDataSource: remoteDataSource, 
      localDataSource: localDataSource, 
      preloadedDataSource: preloadedDataSource,
      userLocalDataSource: userLocalDataSource
    );
  });

  group('getVisits', (){
    String tAccessToken;
    ProjectModel tProject;
    List<Visit> tVisits;
    List<int> tVisitsIds;
    List<Visit> tUncompleteVisits;
    List<int> tUncompleteVisitsIds;

    setUp((){
      tAccessToken = 'access_token';
      tProject = _getProjectFromFixture();
      tVisits = _getVisitsFromFixture();
      tVisitsIds = tVisits.map((v) => v.id).toList();
      tUncompleteVisits = [_getVisitsFromFixture()[0]];
      tUncompleteVisitsIds = [tUncompleteVisits[0].id];

    });

    test('should get the visits from remoteDataSource with tAccessToken and save it in localDataSource when there is connection', ()async{
      when(networkInfo.isConnected()).thenAnswer((realInvocation) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(remoteDataSource.getVisits(any, any)).thenAnswer((_) async => tVisits);
      await visitsRepository.getVisits();
      verify(networkInfo.isConnected());
      verify(userLocalDataSource.getAccessToken());
      verify(projectsLocalDataSource.getChosenProject());
      verify(remoteDataSource.getVisits(tProject.id, tAccessToken));
      verify(localDataSource.setVisits(tVisits, tProject.id));
    });

    test('should get the visits from preloadedDataSource when there is not connection', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(preloadedDataSource.getPreloadedVisitsIds(any)).thenAnswer((_) async => tVisitsIds);
      when(localDataSource.getVisits(any)).thenAnswer((_) async => tVisits);
      await visitsRepository.getVisits();
      verify(preloadedDataSource.getPreloadedVisitsIds(tProject.id));
      verify(localDataSource.getVisits(tProject.id));
    });

    
    test('should get the Right(tVisits) when there is connection and all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((realInvocation) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(remoteDataSource.getVisits(any, any)).thenAnswer((realInvocation) async => tVisits);
      final response = await visitsRepository.getVisits();
      expect(response, Right(tVisits));
    });
    
    test('should get the Left(ServiceFailure()) when there is connection and remoteDataSource throws a ServerException', ()async{
      when(networkInfo.isConnected()).thenAnswer((realInvocation) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(remoteDataSource.getVisits(any, any)).thenThrow(ServerException());
      final response = await visitsRepository.getVisits();
      expect(response, Left(ServerFailure()));
    });

    test('should return Right(tUncompleteVisits) when there is not connection and all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((realInvocation) async => false);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(preloadedDataSource.getPreloadedVisitsIds(any)).thenAnswer((_) async => tUncompleteVisitsIds);
      when(localDataSource.getVisits(any)).thenAnswer((_) async => tVisits);
      final response = await visitsRepository.getVisits();
      expect(response.isRight(), true);
      response.fold((l) => null, (r){
        expect(r, tUncompleteVisits);
      });
    });

    test('should return Left(StorageFailure()) when there is connection and preloadedDataSource throws StorageException', ()async{
      when(networkInfo.isConnected()).thenAnswer((realInvocation) async => false);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(preloadedDataSource.getPreloadedVisitsIds(any)).thenAnswer((realInvocation) async => tVisitsIds);
      when(localDataSource.getVisits(any)).thenThrow(StorageException(type: StorageExceptionType.NORMAL));
      final response = await visitsRepository.getVisits();
      expect(response, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    });
    
  });

  group('setChosenVisit', (){
    String tAccessToken;
    Visit tChosenVisit;
    ProjectModel tChosenProject;
    List<FormularioModel> tFormularios;
    setUp((){
      tAccessToken = 'a_t';
      tChosenVisit = _getVisitsFromFixture()[0];
      tChosenProject = _getProjectFromFixture();
      tFormularios = _getFormulariosFromFixture();
    });

    test('should set the chosen visit from localDataSource when there is connectivity', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(formulariosRemoteDataSource.getFormularios(any, any)).thenAnswer((_) async => tFormularios);
      when(userLocalDataSource.getAccessToken()).thenAnswer((realInvocation) async => tAccessToken);
      await visitsRepository.setChosenVisit(tChosenVisit);
      verify(networkInfo.isConnected());
      verify(localDataSource.setChosenVisit(tChosenVisit));
      verify(projectsLocalDataSource.getChosenProject());
      verify(formulariosRemoteDataSource.getFormularios(tChosenVisit.id, tAccessToken));
      verify(preloadedDataSource.setPreloadedFamily(tChosenProject.id, tChosenVisit.id, tFormularios));
    });

    test('should set the chosen visit from localDataSource when there is not connectivity', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      await visitsRepository.setChosenVisit(tChosenVisit);
      verify(networkInfo.isConnected());
      verify(localDataSource.setChosenVisit(tChosenVisit));
      verifyNever(projectsLocalDataSource.getChosenProject());
      verifyNever(formulariosRemoteDataSource.getFormularios(any, any));
      verifyNever(preloadedDataSource.setPreloadedFamily(any, any, any));
    });

    test('should return Right(null) when all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(formulariosRemoteDataSource.getFormularios(any, any)).thenAnswer((_) async => tFormularios);
      when(userLocalDataSource.getAccessToken()).thenAnswer((realInvocation) async => tAccessToken);
      final response = await visitsRepository.setChosenVisit(tChosenVisit);
      expect(response, Right(null));
    });

    test('should return Left(StorageFailure()) when localDataSource throws a StorageException()', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(formulariosRemoteDataSource.getFormularios(any, any)).thenAnswer((_) async => tFormularios);
      when(userLocalDataSource.getAccessToken()).thenAnswer((realInvocation) async => tAccessToken);
      when(localDataSource.setChosenVisit(any)).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));
      final response = await visitsRepository.setChosenVisit(tChosenVisit);
      expect(response, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    });
  });

  group('getChosenVisit', (){
    ProjectModel tProject;
    int tProjectId;
    Visit tChosenVisit;

    setUp((){
      tProject = _getProjectFromFixture();
      tProjectId = 1;
      tChosenVisit = _getVisitsFromFixture()[0];
    });

    test('should get the chosen visit from localDataSource when there is connection', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(localDataSource.getChosenVisit(any)).thenAnswer((realInvocation) async => tChosenVisit);
      await visitsRepository.getChosenVisit();
      verify(localDataSource.getChosenVisit(tProject.id));
    });

    
    test('should get the chosen visit from localDataSource when there is not connection', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(localDataSource.getChosenVisit(any)).thenAnswer((realInvocation) async => tChosenVisit);
      await visitsRepository.getChosenVisit();
      verify(localDataSource.getChosenVisit(tProject.id));
    });

    test('should return Right(tChosenVisit) when all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(localDataSource.getChosenVisit(any)).thenAnswer((realInvocation) async => tChosenVisit);
      final response = await visitsRepository.getChosenVisit();
      expect(response, Right(tChosenVisit));
    });

    test('should return Left(StorageFailure()) when localDataSource throws a StorageException()', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(localDataSource.getChosenVisit(any)).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));
      final response = await visitsRepository.getChosenVisit();
      expect(response, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    });
  });
}

ProjectModel _getProjectFromFixture(){
  final String stringProjects = callFixture('projects.json');
  final List<Map<String, dynamic>> jsonProjects = jsonDecode(stringProjects).cast<Map<String, dynamic>>();
  final List<ProjectModel> projects = projectsFromJson(jsonProjects);
  return projects[0];
}

List<VisitModel> _getVisitsFromFixture(){
  final String stringVisits = callFixture('visits.json');
  final List<Map<String, dynamic>> jsonVisits = jsonDecode(stringVisits).cast<Map<String, dynamic>>();
  final List<VisitModel> visits = visitsFromStorageJson(jsonVisits);
  return visits;
} 

List<FormularioModel> _getFormulariosFromFixture(){
  final String stringFormularios = callFixture('visits.json');
  final List<Map<String, dynamic>> jsonFormularios = jsonDecode(stringFormularios).cast<Map<String, dynamic>>();
  final List<FormularioModel> formularios = formulariosFromJson(jsonFormularios);
  return formularios;
}