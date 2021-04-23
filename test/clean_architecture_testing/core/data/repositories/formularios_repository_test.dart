import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/visits/visits_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/project.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded_data/preloaded_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';
import '../../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetworkInfo{}
class MockFormulariosRemoteDataSource extends Mock implements FormulariosRemoteDataSource{}
class MockFormulariosLocalDataSource extends Mock implements FormulariosLocalDataSource{}
class MockPreloadedLocalDataSource extends Mock implements PreloadedLocalDataSource{}
class MockUserLocalDataSource extends Mock implements UserLocalDataSource{}
class MockVisitsLocalDataSource extends Mock implements VisitsLocalDataSource{}
class MockProjectsLocalDataSource extends Mock implements ProjectsLocalDataSource{}

FormulariosRepositoryImpl formulariosRepository;
MockNetworkInfo networkInfo;
MockFormulariosRemoteDataSource remoteDataSource;
MockFormulariosLocalDataSource localDataSource;
MockPreloadedLocalDataSource preloadedDataSource;
MockUserLocalDataSource userLocalDataSource;
MockVisitsLocalDataSource visitsLocalDataSource;
MockProjectsLocalDataSource projectsLocalDataSource;

void main(){

  setUp((){
    projectsLocalDataSource = MockProjectsLocalDataSource();
    visitsLocalDataSource = MockVisitsLocalDataSource();
    preloadedDataSource = MockPreloadedLocalDataSource();
    localDataSource = MockFormulariosLocalDataSource();
    remoteDataSource = MockFormulariosRemoteDataSource();
    networkInfo = MockNetworkInfo();
    userLocalDataSource = MockUserLocalDataSource();
    formulariosRepository = FormulariosRepositoryImpl(
      networkInfo: networkInfo, 
      remoteDataSource: remoteDataSource, 
      localDataSource: localDataSource, 
      preloadedDataSource: preloadedDataSource,
      userLocalDataSource: userLocalDataSource,
      visitsLocalDataSource: visitsLocalDataSource,
      projectsLocalDataSource: projectsLocalDataSource,
    );
  });

  _testGetFormulariosGroup();
  _testSetInitialPositionGroup();
}

void _testGetFormulariosGroup(){
  group('getFormularios', (){
    String tAccessToken;
    ProjectModel tProject;
    VisitModel tVisit;
    List<Formulario> tFormularios;

    setUp((){
      tAccessToken = 'access_token';
      tProject = ProjectModel(id: 1, nombre: '');
      tVisit = VisitModel(id: 2, date: null, completo: false, sede: null, formularios: []);
      tFormularios = _getFormulariosFromFixture();
    });

    test('should get the formularios from remoteDataSource with tAccessToken when there is connectivity', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.getFormularios(any)).thenAnswer((_) async => tFormularios);
      await formulariosRepository.getFormularios();
      verify(networkInfo.isConnected());
      verify(userLocalDataSource.getAccessToken());
      verify(remoteDataSource.getFormularios(tAccessToken));
    });

    test('''should get the formularios from preloadedDataSource obtaining the visitId, projectId from their respective dataSources 
      when there is not connectivity''', 
      ()async{
        when(networkInfo.isConnected()).thenAnswer((_) async => false);
        when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
        when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
        when(preloadedDataSource.getPreloadedFormularios(any, any)).thenAnswer((_) async => tFormularios);
        await formulariosRepository.getFormularios();
        verify(projectsLocalDataSource.getChosenProject());
        verify(visitsLocalDataSource.getChosenVisit(tProject.id));
        verify(preloadedDataSource.getPreloadedFormularios(tProject.id, tVisit.id));
      }
    );

    test('should return Right(tFormularios) when there is connection and all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.getFormularios(any)).thenAnswer((_) async => tFormularios);
      final result = await formulariosRepository.getFormularios();
      expect(result, Right(tFormularios));
    });

    test('should return Left(ServerFailure) when there is connection and the remoteDataSource throws a ServerException', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.getFormularios(any)).thenThrow(ServerException());
      final result = await formulariosRepository.getFormularios();
      expect(result, Left(ServerFailure()));
    });

    test('''should return Right(tFormularios) when there is not connectivity and all goes good''', 
      ()async{
        when(networkInfo.isConnected()).thenAnswer((_) async => false);
        when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
        when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
        when(preloadedDataSource.getPreloadedFormularios(any, any)).thenAnswer((_) async => tFormularios);
        final result = await formulariosRepository.getFormularios();
        expect(result, Right(tFormularios));
      }
    );

    test('''should return Left(StorageFailure) when there is not connectivity and preloadedDataSource throws a StorageException''', 
      ()async{
        when(networkInfo.isConnected()).thenAnswer((_) async => false);
        when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
        when(visitsLocalDataSource.getChosenVisit(any)).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));
        when(preloadedDataSource.getPreloadedFormularios(any, any)).thenAnswer((_) async => tFormularios);
        final result = await formulariosRepository.getFormularios();
        expect(result, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
      }
    );
  });
}

List<Formulario> _getFormulariosFromFixture(){
  final String stringVisits = callFixture('formularios.json');
  final List<Map<String, dynamic>> jsonVisits = jsonDecode(stringVisits).cast<Map<String, dynamic>>();
  final List<Formulario> visits = formulariosFromJson(jsonVisits);
  return visits;
}

void _testSetInitialPositionGroup(){
  group('setInitialPosition', (){
    String tAccessToken;
    ProjectModel tProject;
    VisitModel tVisit;
    Position tInitialPosition;
    FormularioModel tFormulario;
    Position tFinalPosition;

    setUp((){
      tAccessToken = 'access_token';
      tProject = ProjectModel(id: 1, nombre: 'project');
      tVisit = VisitModel(id: 2, completo: false);
      tInitialPosition = Position(latitude: 1.1, longitude: 2.2);
      tFormulario = FormularioModel(id: 3, completo: false);
      tFinalPosition = Position(latitude: 3.3, longitude: 4.4);

      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tFormulario);
    });

    
    test('''should set the initial position in remoteDataSource, obtaining the
        projectId from projectsLocalDataSource, visitId from visitsLocalDataSource,
        formularioId from formulariosLocalDataSource, the accessToken from userLocalDataSource,
        when there is connectivity''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      await formulariosRepository.setInitialPosition(tInitialPosition);
      verify(networkInfo.isConnected());
      verify(projectsLocalDataSource.getChosenProject());
      verify(visitsLocalDataSource.getChosenVisit(tProject.id));
      verify(localDataSource.getChosenFormulario(tVisit.id));
      verify(userLocalDataSource.getAccessToken());
      verify(remoteDataSource.setInitialPosition(tInitialPosition, tFormulario.id, tAccessToken));
    });

    test('''should set the initial position in localDataSource, obtaining the
        projectId from projectsLocalDataSource, visitId from visitsLocalDataSource,
        formularioId from formulariosLocalDataSource, when there is not connectivity''', ()async{
      final FormularioModel tFormularioWithInitialPosition = FormularioModel(
        id: tFormulario.id,
        completo: tFormulario.completo,
        initialPosition: tInitialPosition
      );
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      await formulariosRepository.setInitialPosition(tInitialPosition);
      verify(networkInfo.isConnected());
      verify(projectsLocalDataSource.getChosenProject());
      verify(visitsLocalDataSource.getChosenVisit(tProject.id));
      verify(localDataSource.getChosenFormulario(tVisit.id));
      verify(localDataSource.setChosenFormulario(tFormularioWithInitialPosition));
      verify(preloadedDataSource.updatePreloadedFormulario(tProject.id, tVisit.id, tFormularioWithInitialPosition));
    });

    test('should return Right(null) when there is connectivity and all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      final result = await formulariosRepository.setInitialPosition(tInitialPosition);
      expect(result, Right(null));
    });

    test('''should return Left(ServerFailure()) when there is connectivity 
        and remoteDataSource throws ServerException''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.setInitialPosition(any, any, any)).thenThrow(ServerException());
      final result = await formulariosRepository.setInitialPosition(tInitialPosition);
      expect(result, Left(ServerFailure()));
    });

    test('''should return Right(null) when there is not connectivity and
        all goes good''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      final result = await formulariosRepository.setInitialPosition(tInitialPosition);
      expect(result, Right(null));
    });

    test('''should return Left(StorageFailure(...)) when there is not connectivity and
        PreloadedDataSource throws a StorageException(...)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(preloadedDataSource.updatePreloadedFormulario(any, any, any)).thenThrow(StorageException(type: StorageExceptionType.NORMAL));
      final result = await formulariosRepository.setInitialPosition(tInitialPosition);
      expect(result, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    });
  });
}