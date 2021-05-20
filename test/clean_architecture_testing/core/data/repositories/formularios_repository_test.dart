import 'dart:convert';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/custom_position.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/visits/visits_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/firmer_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded/preloaded_local_data_source.dart';
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
  _testSetChosenFormularioGroup();
  _testGetChosenFormularioGroup();
  _testSetInitialPositionGroup();
  _testSetFormularioGroup();
  _testSetFinalPositionGroup();
  _testSetFirmerGroup();

  group('endFormulario', (){

    String tAccessToken;
    ProjectModel tChosenProject;
    VisitModel tChosenVisit;
    FormularioModel tChosenFormulario;
    setUp((){
      tAccessToken = 'access_token';
      tChosenProject = ProjectModel(id: 1, nombre: 'p');
      tChosenVisit = VisitModel(id: 2, completo: false, sede: null, date: null, hasMuestreo: false, formularios: []);
      tChosenFormulario = _getFormulariosFromFixture()[0];
    });

    test('should remote the formulario from the preloadedData when there is connectivity', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tChosenFormulario);
      await formulariosRepository.endChosenFormulario();
      verify(projectsLocalDataSource.getChosenProject());      
      verify(visitsLocalDataSource.getChosenVisit(tChosenProject.id));
      verify(localDataSource.getChosenFormulario(tChosenVisit.id));
      verify(preloadedDataSource.removePreloadedFormulario(tChosenFormulario.id));
      verify(networkInfo.isConnected());    
    });

    test('should complete the chosenFormulario and saveIt on preloadedDataSource', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tChosenFormulario);
      await formulariosRepository.endChosenFormulario();
      verify(projectsLocalDataSource.getChosenProject());      
      verify(visitsLocalDataSource.getChosenVisit(tChosenProject.id));
      verify(localDataSource.getChosenFormulario(tChosenVisit.id));
      verify(preloadedDataSource.updatePreloadedFormulario(tChosenProject.id, tChosenVisit.id, tChosenFormulario.copyWith(completo: true)));
      verifyNever(preloadedDataSource.removePreloadedFormulario(tChosenFormulario.id));
      verify(networkInfo.isConnected());
    });

    test('should return Right(null) when there is connectivity and all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tChosenFormulario);
      final result = await formulariosRepository.endChosenFormulario();
      expect(result, Right(null));
    });
    
    test('''should return Left(ServerFailure()) when there is connectivity and remoteDataSource
      throws a ServerException''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tChosenFormulario);
      final result = await formulariosRepository.endChosenFormulario();
      expect(result, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    });
    
    test('should return Right(null) when there is not connectivity and all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tChosenFormulario);
      final result = await formulariosRepository.endChosenFormulario();
      expect(result, Right(null));
    });

    test('''should return Left(StorageFailure(...)) when there is not connectivity
      and preloadedDataStorage throws a StorageException(...)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tChosenFormulario);
      final result = await formulariosRepository.endChosenFormulario();
      expect(result, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    });
  });
  

  
}

void _testGetFormulariosGroup(){
  group('getFormularios', (){
    String tAccessToken;
    ProjectModel tProject;
    VisitModel tVisit;
    List<Formulario> tFormularios;
    FormularioModel tChosenFormulario;

    setUp((){
      tAccessToken = 'access_token';
      tProject = ProjectModel(id: 1, nombre: '');
      tVisit = VisitModel(id: 2, completo: false, sede: null, date: null, hasMuestreo: false, formularios: []);
      tFormularios = _getFormulariosFromFixture();
      tChosenFormulario = _getFormulariosFromFixture()[0];
      tChosenFormulario = tChosenFormulario.copyWith(completo: !tChosenFormulario.completo);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
    });

    test('should get the formularios from remoteDataSource with tAccessToken when there is connectivity', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.getFormularios(any, any)).thenAnswer((_) async => tFormularios);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tChosenFormulario);
      await formulariosRepository.getFormularios();
      verify(networkInfo.isConnected());
      verify(userLocalDataSource.getAccessToken());
      verify(remoteDataSource.getFormularios(tVisit.id, tAccessToken));
      verify(localDataSource.getChosenFormulario(tVisit.id));
    });

    test('''should get the formularios from preloadedDataSource obtaining the visitId, projectId from their respective dataSources 
      and neither the chosenFormulario nor the accessToken, when there is not connectivity''', 
      ()async{
        when(networkInfo.isConnected()).thenAnswer((_) async => false);
        when(preloadedDataSource.getPreloadedFormularios(any, any)).thenAnswer((_) async => tFormularios);
        await formulariosRepository.getFormularios();
        verify(projectsLocalDataSource.getChosenProject());
        verify(visitsLocalDataSource.getChosenVisit(tProject.id));
        verify(preloadedDataSource.getPreloadedFormularios(tProject.id, tVisit.id));
        verifyNever(userLocalDataSource.getAccessToken());
        verifyNever(localDataSource.getChosenFormulario(any));
      }
    );

    test('should return Right(tFormularios) when there is connection and all goes good', ()async{
      List<Formulario> tUpdatedFormularios = List.of(tFormularios);
      tUpdatedFormularios[0] = tChosenFormulario;
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.getFormularios(any, any)).thenAnswer((_) async => tFormularios);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tChosenFormulario);
      final result = await formulariosRepository.getFormularios();
      result.fold((l){
        fail('No debería retornar Left(...)');
      }, (fs){
        expect(fs, equals(tUpdatedFormularios));
      });
    });

    test('should return Left(ServerFailure) when there is connection and the remoteDataSource throws a ServerException', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.getFormularios(any, any)).thenThrow(ServerException());
      final result = await formulariosRepository.getFormularios();
      expect(result, Left(ServerFailure()));
    });

    test('''should return Right(tFormularios) when there is not connectivity and all goes good''', 
      ()async{
        when(networkInfo.isConnected()).thenAnswer((_) async => false);
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

void _testSetChosenFormularioGroup(){
  group('setChosenFormulario', (){
    ProjectModel tChosenProject;
    VisitModel tChosenVisit;
    FormularioModel tFormulario;
    setUp((){
      tChosenProject = ProjectModel(id: 1, nombre: 'p');
      tChosenVisit = VisitModel(id: 2, completo: false, sede: null, date: null, hasMuestreo: false, formularios: []);
      tFormulario = _getFormulariosFromFixture()[0];
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
    });

    test('should set the formulario on the localDataSource', ()async{
      await formulariosRepository.setChosenFormulario(tFormulario);
      verify(projectsLocalDataSource.getChosenProject());
      verify(visitsLocalDataSource.getChosenVisit(tChosenProject.id));
      verify(localDataSource.setChosenFormulario(tFormulario, tChosenVisit.id));
    });

    test('should return Right(null) when all goes good', ()async{
      final result = await formulariosRepository.setChosenFormulario(tFormulario);
      expect(result, Right(null));
    });

    test('should return Left(StorageFailure(X)) when localDataSource throws a StorageException(X)', ()async{
      when(localDataSource.setChosenFormulario(any, any)).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));
      final result = await formulariosRepository.setChosenFormulario(tFormulario);
      expect(result, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    });

  });
}

void _testGetChosenFormularioGroup(){
  group('getChosenFormulario', (){
    String tAccessToken;
    ProjectModel tProject;
    VisitModel tVisit;
    FormularioModel tFormulario;
    setUp((){
      tProject = ProjectModel(id: 1, nombre: '');
      tVisit = VisitModel(id: 2, completo: false, sede: null, date: null, hasMuestreo: false, formularios: []);
      tFormulario = _getFormulariosFromFixture()[0];
      tAccessToken = 'access_token';
    });

    test('''should get the formulario id from the localDataSource and get the updated formulario from the remoteDataSource
    when there is connectivity. Obtaining the projectId, visitId, accessToken from its localDataSources.''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tFormulario);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.getChosenFormulario(any, any)).thenAnswer((_) async => tFormulario);
      await formulariosRepository.getChosenFormulario();
      verify(networkInfo.isConnected());
      verify(projectsLocalDataSource.getChosenProject());      
      verify(visitsLocalDataSource.getChosenVisit(tProject.id));
      verify(localDataSource.getChosenFormulario(tVisit.id));
      verify(userLocalDataSource.getAccessToken());
      verify(remoteDataSource.getChosenFormulario(tFormulario.id, tAccessToken));
    });

    test('''should get the chosen formulario from preloadedDataSource when there is not connectivity. 
    Obtaining the projectId, visitId, accessToken from its localDataSources.''', ()async{
      final List<FormularioModel> tFormularios = _getFormulariosFromFixture();
      final FormularioModel tChosenFormuario = tFormulario.copyWith(nombre: 'preloaded_formulario');
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tChosenFormuario);
      when(preloadedDataSource.getPreloadedFormularios(any, any)).thenAnswer((_) async => tFormularios);
      await formulariosRepository.getChosenFormulario();
      verify(networkInfo.isConnected());
      verify(projectsLocalDataSource.getChosenProject());      
      verify(visitsLocalDataSource.getChosenVisit(tProject.id));
      verify(localDataSource.getChosenFormulario(tVisit.id));
      verify(preloadedDataSource.getPreloadedFormularios(tProject.id, tVisit.id));
      verifyNever(userLocalDataSource.getAccessToken());
      verifyNever(remoteDataSource.getChosenFormulario(tFormulario.id, tAccessToken));
    });

    test('''should return Right(tFormulario) when there is connectivity and all goes good''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tFormulario);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.getChosenFormulario(any, any)).thenAnswer((_) async => tFormulario);
      final result = await formulariosRepository.getChosenFormulario();
      expect(result, Right(tFormulario));
    });

    test('''should get the chosen formulario from preloadedDataSource when there is not connectivity. 
    Obtaining the projectId, visitId, chosenFormulario from its localDataSources.''', ()async{
      final List<FormularioModel> tFormularios = _getFormulariosFromFixture();
      final FormularioModel tChosenFormuario = tFormulario.copyWith(nombre: 'preloaded_formulario');
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tChosenFormuario);
      when(preloadedDataSource.getPreloadedFormularios(any, any)).thenAnswer((_) async => tFormularios);
      final result = await formulariosRepository.getChosenFormulario();
      expect(result, Right(tFormulario));
    });

    test('''should return Left(ServerFailure(X)) when there is connectivity
    and RemoteDataSource throws a ServerException(X)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tFormulario);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.getChosenFormulario(any, any)).thenThrow(ServerException(type: ServerExceptionType.NORMAL));
      final result = await formulariosRepository.getChosenFormulario();
      expect(result, Left(ServerFailure(servExcType: ServerExceptionType.NORMAL)));
    });

    test('''should return Left(StorageFailure(X)) when there is connectivity
    and any localDataSource throws a StorageException(X)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      when(localDataSource.getChosenFormulario(any)).thenThrow(StorageException(type: StorageExceptionType.NORMAL));
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.getChosenFormulario(any, any)).thenAnswer((_) async => tFormulario);
      final result = await formulariosRepository.getChosenFormulario();
      expect(result, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    });

    test('''should return Left(StorageFailure(X)) when there is not connectivity
    and any localDataSource throws StorageException(X).''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tFormulario);
      when(preloadedDataSource.getPreloadedFormularios(any, any)).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));
      final result = await formulariosRepository.getChosenFormulario();
      expect(result, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    });
  });
}

void _testSetInitialPositionGroup(){
  group('setInitialPosition', (){
    String tAccessToken;
    ProjectModel tProject;
    VisitModel tVisit;
    CustomPositionModel tInitialPosition;
    FormularioModel tFormulario;

    setUp((){
      tAccessToken = 'access_token';
      tProject = ProjectModel(id: 1, nombre: 'project');
      tVisit = VisitModel(id: 2, completo: false, sede: null, date: null, hasMuestreo: false, formularios: []);
      tInitialPosition = CustomPositionModel(latitude: 1.1, longitude: 2.2);
      tFormulario = FormularioModel(id: 3, completo: false);
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
      verify(localDataSource.setChosenFormulario(tFormulario, tVisit.id));
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
      verify(localDataSource.setChosenFormulario(tFormularioWithInitialPosition, tVisit.id));
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

void _testSetFormularioGroup(){
  group('setCampos', (){
    String tAccessToken;
    ProjectModel tProject;
    VisitModel tVisit;
    FormularioModel tFormulario;
    setUp((){
      tAccessToken = 'access_token';
      tProject = ProjectModel(id: 1, nombre: 'p');
      tVisit = VisitModel(id: 2, completo: false, sede: null, date: null, hasMuestreo: false, formularios: []);
      tFormulario = _getFormulariosFromFixture()[0];
    });

    test('should set the Formulario in remoteDataSource when there is connectivity', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      await formulariosRepository.setCampos(tFormulario);
      verify(networkInfo.isConnected());
      verify(userLocalDataSource.getAccessToken());
      verify(projectsLocalDataSource.getChosenProject());
      verify(visitsLocalDataSource.getChosenVisit(tProject.id));
      verify(remoteDataSource.setCampos(tFormulario, tVisit.id, tAccessToken));
      verify(localDataSource.setChosenFormulario(tFormulario, tVisit.id));
    });

    test('should update the Formulario in preloadedDataSource and localDataSource when there is not connectivity', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      await formulariosRepository.setCampos(tFormulario);
      verify(networkInfo.isConnected());
      verify(projectsLocalDataSource.getChosenProject());
      verify(visitsLocalDataSource.getChosenVisit(tProject.id));
      verify(preloadedDataSource.updatePreloadedFormulario(tProject.id, tVisit.id, tFormulario));
    });
    
    test('should return Right(null) when there is connectivity and all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      final result = await formulariosRepository.setCampos(tFormulario);
      expect(result, Right(null));
    });

    test('''should return Left(ServerFailure()) when there is connectivity and remoteDataSource
      throws a ServerException()''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      when(remoteDataSource.setCampos(any, any, any)).thenThrow(ServerException());
      final result = await formulariosRepository.setCampos(tFormulario);
      expect(result, Left(ServerFailure()));
    });

    test('should return Right(null) when there is not connectivity and all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      final result = await formulariosRepository.setCampos(tFormulario);
      expect(result, Right(null));
    });

    test('''should return Left(StorageFailure(...)) when there is not connectivity and
      preloadedDataSource throws a StorageException(...)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      when(preloadedDataSource.updatePreloadedFormulario(any, any, any)).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));
      final result = await formulariosRepository.setCampos(tFormulario);
      expect(result, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    });
  });
}

void _testSetFinalPositionGroup(){
  group('setFinalPosition', (){
    String tAccessToken;
    ProjectModel tProject;
    VisitModel tVisit;
    CustomPositionModel tInitialPosition;
    FormularioModel tFormulario;
    CustomPositionModel tFinalPosition;

    setUp((){
      tAccessToken = 'access_token';
      tProject = ProjectModel(id: 1, nombre: 'project');
      tVisit = VisitModel(id: 2, completo: false, sede: null, date: null, hasMuestreo: false, formularios: []);
      tInitialPosition = CustomPositionModel(latitude: 1.1, longitude: 2.2);
      tFormulario = FormularioModel(id: 3, completo: false);
      tFinalPosition = CustomPositionModel(latitude: 3.3, longitude: 4.4);

      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tFormulario);
    });

    
    test('''should set the final position in remoteDataSource, obtaining the
        projectId from projectsLocalDataSource, visitId from visitsLocalDataSource,
        formularioId from formulariosLocalDataSource, the accessToken from userLocalDataSource,
        when there is connectivity''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      await formulariosRepository.setFinalPosition(tFinalPosition);
      verify(networkInfo.isConnected());
      verify(projectsLocalDataSource.getChosenProject());
      verify(visitsLocalDataSource.getChosenVisit(tProject.id));
      verify(localDataSource.getChosenFormulario(tVisit.id));
      verify(userLocalDataSource.getAccessToken());
      verify(remoteDataSource.setFinalPosition(tFinalPosition, tFormulario.id, tAccessToken));
      verify(localDataSource.setChosenFormulario(tFormulario, tVisit.id));
    });
    
    test('''should set the final position in localDataSource, obtaining the
        projectId from projectsLocalDataSource, visitId from visitsLocalDataSource,
        formularioId from formulariosLocalDataSource, when there is not connectivity''', ()async{
      final FormularioModel tFormularioWithFinalPosition = FormularioModel(
        id: tFormulario.id,
        completo: tFormulario.completo,
        initialPosition: tInitialPosition,
        finalPosition: tInitialPosition
      );
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      await formulariosRepository.setFinalPosition(tInitialPosition);
      verify(networkInfo.isConnected());
      verify(projectsLocalDataSource.getChosenProject());
      verify(visitsLocalDataSource.getChosenVisit(tProject.id));
      verify(localDataSource.getChosenFormulario(tVisit.id));
      verify(localDataSource.setChosenFormulario(tFormularioWithFinalPosition, tVisit.id));
      verify(preloadedDataSource.updatePreloadedFormulario(tProject.id, tVisit.id, tFormularioWithFinalPosition));
    });

    
    test('should return Right(null) when there is connectivity and all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      final result = await formulariosRepository.setFinalPosition(tFinalPosition);
      expect(result, Right(null));
    });
    
    
    test('''should return Left(ServerFailure()) when there is connectivity 
        and remoteDataSource throws ServerException''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.setFinalPosition(any, any, any)).thenThrow(ServerException());
      final result = await formulariosRepository.setFinalPosition(tFinalPosition);
      expect(result, Left(ServerFailure()));
    });

    
    test('''should return Right(null) when there is not connectivity and
        all goes good''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      final result = await formulariosRepository.setFinalPosition(tFinalPosition);
      expect(result, Right(null));
    });

    test('''should return Left(StorageFailure(...)) when there is not connectivity and
        PreloadedDataSource throws a StorageException(...)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(preloadedDataSource.updatePreloadedFormulario(any, any, any)).thenThrow(StorageException(type: StorageExceptionType.NORMAL));
      final result = await formulariosRepository.setFinalPosition(tInitialPosition);
      expect(result, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    });
  });
}

void _testSetFirmerGroup(){
  group('setFirmer', (){
    String tAccessToken;
    ProjectModel tProject;
    VisitModel tVisit;
    FormularioModel tFormulario1;
    FirmerModel tFirmer1;
    setUp((){
      tAccessToken = 'access_token';
      tProject = ProjectModel(id: 1, nombre: 'p');
      tVisit = VisitModel(id: 2, completo: false, sede: null, date: null, hasMuestreo: false, formularios: []);VisitModel(id: 2, completo: false, sede: null, date: null, hasMuestreo: false, formularios: []);
      tVisit = VisitModel(id: 2, completo: false, sede: null, date: null, hasMuestreo: false, formularios: []);VisitModel(id: 2, completo: false, sede: null, date: null, hasMuestreo: false, formularios: []);
      tFormulario1 = _getFormulariosFromFixture()[0];
      tFirmer1 = _getFormulariosFromFixture()[1].firmers[0];
    });

    test('''should set the firmer in remoteDataSource, obtaining the chosenProject from projectsLocalDataSource, 
    and the chosenVisit from visitsLocalDataSource, when there is connectivity ''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tFormulario1);
      await formulariosRepository.setFirmer(tFirmer1);
      verify(networkInfo.isConnected());
      verify(userLocalDataSource.getAccessToken());
      verify(projectsLocalDataSource.getChosenProject());
      verify(visitsLocalDataSource.getChosenVisit(tProject.id));
      verify(remoteDataSource.setFirmer(tFirmer1, tFormulario1.id, tVisit.id, tAccessToken));
      verify(localDataSource.setChosenFormulario(tFormulario1, tVisit.id));
    });

    test('''should update the formulario with the new firmer in preloadedDataSource, obtaining the chosenProject from projectsLocalDataSource, 
    and the chosenVisit from visitsLocalDataSource, when there is not connectivity ''', ()async{
      List<FirmerModel> tFormulario1FirmersWithNewOne = tFormulario1.firmers.toList();
      tFormulario1FirmersWithNewOne.add(tFirmer1);
      tFormulario1 = tFormulario1.copyWith(firmers: []);
      final FormularioModel tFormularioWithNewFirmer = tFormulario1.copyWith(firmers: tFormulario1FirmersWithNewOne);
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tFormulario1);
      when(preloadedDataSource.getPreloadedFormularios(any, any)).thenAnswer((_) async => [tFormulario1]);
      await formulariosRepository.setFirmer(tFirmer1);
      verify(networkInfo.isConnected());
      verify(projectsLocalDataSource.getChosenProject());
      verify(visitsLocalDataSource.getChosenVisit(tProject.id));
      verify(preloadedDataSource.getPreloadedFormularios(tProject.id, tVisit.id));
      verify(preloadedDataSource.updatePreloadedFormulario(tProject.id, tVisit.id, tFormularioWithNewFirmer));
    });

    test('should return Right(null) when there is connectivity and all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tFormulario1);
      final result = await formulariosRepository.setFirmer(tFirmer1);
      expect(result, Right(null));
    });
    
    test('''should return Left(ServerFailure()) when there is connectivity and remoteDataSource
      throws a ServerException''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tFormulario1);
      when(remoteDataSource.setFirmer(any, any, tVisit.id, any)).thenThrow(ServerException());
      final result = await formulariosRepository.setFirmer(tFirmer1);
      expect(result, Left(ServerFailure()));
    });
    
    test('should return Right(null) when there is not connectivity and all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      when(localDataSource.getChosenFormulario(tVisit.id)).thenAnswer((_) async => tFormulario1);
      when(preloadedDataSource.getPreloadedFormularios(any, any)).thenAnswer((_) async => [tFormulario1]);
      final result = await formulariosRepository.setFirmer(tFirmer1);
      expect(result, Right(null));
    });

    test('''should return Left(StorageFailure(...)) when there is not connectivity
      and preloadedDataStorage throws a StorageException(...)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tVisit);
      when(localDataSource.getChosenFormulario(any)).thenAnswer((_) async => tFormulario1);
      when(preloadedDataSource.getPreloadedFormularios(any, any)).thenAnswer((_) async => [tFormulario1]);
      when(preloadedDataSource.updatePreloadedFormulario(any, any, any)).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));
      final result = await formulariosRepository.setFirmer(tFirmer1);
      expect(result, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    });
  });
}