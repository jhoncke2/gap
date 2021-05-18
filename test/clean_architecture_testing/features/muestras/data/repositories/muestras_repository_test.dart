import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/visits/visits_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/data_sources/muestras_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestra_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestreo_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/repository/muestras_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetworkInfo{}
class MockMuestrasRemoteDataSource extends Mock implements MuestrasRemoteDataSource{}
class MockUserLocalDataSource extends Mock implements UserLocalDataSource{}
class MockProjectsLocalDataSource extends Mock implements ProjectsLocalDataSource{}
class MockVisitsLocalDataSource extends Mock implements VisitsLocalDataSource{}


MuestrasRepositoryImpl repository;
NetworkInfo networkInfo;
MockMuestrasRemoteDataSource remoteDataSource;
MockUserLocalDataSource userLocalDataSource;
MockProjectsLocalDataSource projectsLocalDataSource;
MockVisitsLocalDataSource visitsLocalDataSource;

void main(){
  setUp((){
    remoteDataSource = MockMuestrasRemoteDataSource();
    userLocalDataSource = MockUserLocalDataSource();
    projectsLocalDataSource = MockProjectsLocalDataSource();
    visitsLocalDataSource = MockVisitsLocalDataSource();
    networkInfo = MockNetworkInfo();    
    repository = MuestrasRepositoryImpl(
      networkInfo: networkInfo,
      remoteDataSource: remoteDataSource,
      userLocalDataSource: userLocalDataSource,
      projectsLocalDataSource: projectsLocalDataSource,
      visitsLocalDataSource: visitsLocalDataSource      
    );
  });

  group('getMuestra', (){
    String tAccessToken;
    ProjectModel tChosenProject;
    VisitModel tChosenVisit;
    MuestreoModel tMuestra;

    setUp((){
      tAccessToken = 'access_token';
      tChosenProject = _getProjectFromFixture();
      tChosenVisit = _getVisitFromFixture();
      tMuestra = _getMuestreoFromFixture();
    });

    test('''should call the methods from localUserDataSource, localProjectsDataSource,
    localVisitDataSource, and finally remoteDataSource, 
    when there is connectivity and all goes good''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
      when(remoteDataSource.getMuestra(any, any)).thenAnswer((_) async => tMuestra);
      await repository.getMuestreo();
      verify(networkInfo.isConnected());
      verify(userLocalDataSource.getAccessToken());
      verify(projectsLocalDataSource.getChosenProject());
      verify(visitsLocalDataSource.getChosenVisit(tChosenProject.id));
      verify(remoteDataSource.getMuestra(tAccessToken, tChosenVisit.id));      
    });

    test('''should never call the methods from localUserDataSource, localProjectsDataSource,
    localVisitDataSource, and finally remoteDataSource, 
    when there is not connectivity and all goes good''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      await repository.getMuestreo();
      verify(networkInfo.isConnected());
      verifyNever(userLocalDataSource.getAccessToken());
      verifyNever(projectsLocalDataSource.getChosenProject());
      verifyNever(visitsLocalDataSource.getChosenVisit(any));
      verifyNever(remoteDataSource.getMuestra(any, any));      
    });

    test('''should return Right(tMuestra), 
    when there is connectivity and all goes good''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
      when(remoteDataSource.getMuestra(any, any)).thenAnswer((_) async => tMuestra);
      final result = await repository.getMuestreo();
      expect(result, Right(tMuestra));
    });

    test('''should return Right(null), 
    when there is not connectivity and all goes good''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      final result = await repository.getMuestreo();
      expect(result, Right(null));
    });

    test('''should return Left(ServerFailure(X)), 
    when there is connectivity and remoteDataSource throws ServerException(X)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
      when(remoteDataSource.getMuestra(any, any)).thenThrow(ServerException(type: ServerExceptionType.REFRESH_ACCESS_TOKEN));
      final result = await repository.getMuestreo();
      expect(result, Left(ServerFailure(servExcType: ServerExceptionType.REFRESH_ACCESS_TOKEN)));
    });

    test('''should return Left(StorageFailure(X)), 
    when there is connectivity and remoteDataSource throws ServerException(X)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenThrow(StorageException(type: StorageExceptionType.NORMAL));
      when(remoteDataSource.getMuestra(any, any)).thenAnswer((_) async => tMuestra);
      final result = await repository.getMuestreo();
      expect(result, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    });
  });

  group('setMuestra', (){
    String tAccessToken;
    ProjectModel tChosenProject;
    VisitModel tChosenVisit;
    MuestreoModel tMuestra;
    int tSelectedRangoIndex;
    List<double> tPesosTomados;

    setUp((){
      tAccessToken = 'access_token';
      tChosenProject = _getProjectFromFixture();
      tChosenVisit = _getVisitFromFixture();
      tMuestra = _getMuestreoFromFixture();
      tSelectedRangoIndex = 0;
      tPesosTomados = [1, 2, 3];
    });

    test('''should call the methods from localUserDataSource, localProjectsDataSource,
    localVisitDataSource, and finally remoteDataSource, 
    when there is connectivity and all goes good''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
      when(remoteDataSource.setMuestra(any, any, any, any)).thenAnswer((_) async => tMuestra);
      await repository.setMuestra(tSelectedRangoIndex, tPesosTomados);
      verify(networkInfo.isConnected());
      verify(userLocalDataSource.getAccessToken());
      verify(projectsLocalDataSource.getChosenProject());
      verify(visitsLocalDataSource.getChosenVisit(tChosenProject.id));
      verify(remoteDataSource.setMuestra(tAccessToken, tChosenVisit.id, tSelectedRangoIndex, tPesosTomados));      
    });

    test('''should never call the methods from localUserDataSource, localProjectsDataSource,
    localVisitDataSource, and finally remoteDataSource, 
    when there is not connectivity and all goes good''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      await repository.setMuestra(tSelectedRangoIndex, tPesosTomados);
      verify(networkInfo.isConnected());
      verifyNever(userLocalDataSource.getAccessToken());
      verifyNever(projectsLocalDataSource.getChosenProject());
      verifyNever(visitsLocalDataSource.getChosenVisit(any));
      verifyNever(remoteDataSource.setMuestra(any, any, any, any));      
    });

    test('''should return Right(null), 
    when there is connectivity and all goes good''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
      when(remoteDataSource.setMuestra(any, any, any, any)).thenAnswer((_) async => tMuestra);
      final result = await repository.setMuestra(tSelectedRangoIndex, tPesosTomados);
      expect(result, Right(null));
    });

    test('''should return Right(null), 
    when there is not connectivity and all goes good''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      final result = await repository.setMuestra(tSelectedRangoIndex, tPesosTomados);
      expect(result, Right(null));
    });

    test('''should return Left(ServerFailure(X)), 
    when there is connectivity and remoteDataSource throws ServerException(X)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
      when(remoteDataSource.setMuestra(any, any, any, any)).thenThrow(ServerException(type: ServerExceptionType.REFRESH_ACCESS_TOKEN));
      final result = await repository.setMuestra(tSelectedRangoIndex, tPesosTomados);
      expect(result, Left(ServerFailure(servExcType: ServerExceptionType.REFRESH_ACCESS_TOKEN)));
    });

    test('''should return Left(StorageFailure(X)), 
    when there is connectivity and remoteDataSource throws ServerException(X)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenThrow(StorageException(type: StorageExceptionType.NORMAL));
      when(remoteDataSource.setMuestra(any, any, any, any)).thenAnswer((_) async => tMuestra);
      final result = await repository.setMuestra(tSelectedRangoIndex, tPesosTomados);
      expect(result, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    });
  });

  group('updatePreparaciones', (){
    ProjectModel tChosenProject;
    VisitModel tChosenVisit;
    String tAccessToken;
    List<String> tPreparaciones;

    setUp((){
      tChosenProject = _getProjectFromFixture();
      tChosenVisit = _getVisitFromFixture();
      tAccessToken = 'access_token';
      tPreparaciones = ['prep1', 'prep2', 'prep3', 'prep4'];
    });

    test('''should call the networkInfo, <user / project / visit> localDataSources and call the remoteDataSource update method, 
    when there is connectivity and all goes good''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      await repository.updatePreparaciones(tPreparaciones);
      verify(networkInfo.isConnected());
      verify(projectsLocalDataSource.getChosenProject());
      verify(visitsLocalDataSource.getChosenVisit(tChosenProject.id));
      verify(userLocalDataSource.getAccessToken());
      verify(remoteDataSource.updatePreparaciones(tAccessToken, tChosenVisit.id, tPreparaciones));
    });

    test('should do nothing, when there is not connectivity', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      await repository.updatePreparaciones(tPreparaciones);
      verify(networkInfo.isConnected());
      verifyNever(projectsLocalDataSource.getChosenProject());
      verifyNever(visitsLocalDataSource.getChosenVisit(any));
      verifyNever(userLocalDataSource.getAccessToken());
      verifyNever(remoteDataSource.updatePreparaciones(any, any, any));
    });

    test('''should return Right(null), 
    when there is connectivity and all goes good''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      final result = await repository.updatePreparaciones(tPreparaciones);
      expect(result, Right(null));
    });

    test('''should return Right(null), 
    when there is not connectivity''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      final result = await repository.updatePreparaciones(tPreparaciones);
      expect(result, Right(null));
    });

    test('''should return Left(ServerFailure(X)), 
    when there is connectivity and remoteDataSource throws ServerException(X)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
      when(remoteDataSource.updatePreparaciones(any, any, any)).thenThrow(ServerException(type: ServerExceptionType.REFRESH_ACCESS_TOKEN));
      final result = await repository.updatePreparaciones(tPreparaciones);
      expect(result, Left(ServerFailure(servExcType: ServerExceptionType.REFRESH_ACCESS_TOKEN)));
    });

    test('''should return Left(StorageFailure(X)), 
    when there is connectivity and remoteDataSource throws ServerException(X)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenThrow(StorageException(type: StorageExceptionType.NORMAL));
      final result = await repository.updatePreparaciones(tPreparaciones);
      expect(result, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    });
  });

  group('removeMuestra', (){

    String tAccessToken;
    int tMuestraId;

    setUp((){
      tAccessToken = 'access_token';
      tMuestraId = 15;
    });

    test('''should call the networkInfo, <user / project / visit> localDataSources and call the remoteDataSource update method, 
    when there is connectivity and all goes good''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      await repository.removeMuestra(tMuestraId);
      verify(networkInfo.isConnected());
      verify(userLocalDataSource.getAccessToken());
      verify(remoteDataSource.removeMuestra(tAccessToken, tMuestraId));
    });

    test('should do nothing, when there is not connectivity', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      await repository.removeMuestra(tMuestraId);
      verify(networkInfo.isConnected());
      verifyNever(userLocalDataSource.getAccessToken());
      verifyNever(remoteDataSource.removeMuestra(any, any));
    });

    test('''should return Right(null), 
    when there is connectivity and all goes good''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      final result = await repository.removeMuestra(tMuestraId);
      expect(result, Right(null));
    });

    test('''should return Right(null), 
    when there is not connectivity''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      final result = await repository.removeMuestra(tMuestraId);
      expect(result, Right(null));
    });

    test('''should return Left(ServerFailure(X)), 
    when there is connectivity and remoteDataSource throws ServerException(X)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.removeMuestra(any, any)).thenThrow(ServerException(type: ServerExceptionType.REFRESH_ACCESS_TOKEN));
      final result = await repository.removeMuestra(tMuestraId);
      expect(result, Left(ServerFailure(servExcType: ServerExceptionType.REFRESH_ACCESS_TOKEN)));
    });

    test('''should return Left(StorageFailure(X)), 
    when there is connectivity and remoteDataSource throws ServerException(X)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenThrow(StorageException(type: StorageExceptionType.NORMAL));
      final result = await repository.removeMuestra(tMuestraId);
      expect(result, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    });
  });
}

ProjectModel _getProjectFromFixture(){
  final String stringPs = callFixture('projects.json');
  final List<Map<String, dynamic>> jsonPs = jsonDecode(stringPs).cast<Map<String, dynamic>>();
  return ProjectModel.fromJson(jsonPs[0]);
}

VisitModel _getVisitFromFixture(){
  final String stringVs = callFixture('visits.json');
  final List<Map<String, dynamic>> jsonVs = jsonDecode(stringVs).cast<Map<String, dynamic>>();
  return VisitModel.fromJson(jsonVs[0]);
}

MuestreoModel _getMuestreoFromFixture(){
  final String stringM = callFixture('muestra.json');
  final Map<String, dynamic> jsonM = jsonDecode(stringM);
  return MuestreoModel.fromJson(jsonM);
}