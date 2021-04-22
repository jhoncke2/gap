import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded_data/preloaded_local_data_source.dart';
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
class MockUserLocalDataSource extends Mock implements UserLocalDataSource{}

VisitsRepositoryImpl visitsRepository;
MockNetworkInfo networkInfo;
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
    networkInfo = MockNetworkInfo();
    visitsRepository = VisitsRepositoryImpl(
      networkInfo: networkInfo,
      remoteDataSource: remoteDataSource, 
      localDataSource: localDataSource, 
      preloadedDataSource: preloadedDataSource,
      userLocalDataSource: userLocalDataSource
    );
  });

  group('getVisits', (){
    String tAccessToken;
    int tProjectId;
    List<Visit> tVisits;
    List<int> tVisitsIds;
    List<Visit> tUncompleteVisits;
    List<int> tUncompleteVisitsIds;

    setUp((){
      tAccessToken = 'access_token';
      tProjectId = 1;
      tVisits = _getVisitsFromFixture();
      tVisitsIds = tVisits.map((v) => v.id).toList();
      tUncompleteVisits = [_getVisitsFromFixture()[0]];
      tUncompleteVisitsIds = [tUncompleteVisits[0].id];

    });

    test('should get the visits from remoteDataSource with tAccessToken and save it in localDataSource when there is connection', ()async{
      when(networkInfo.isConnected()).thenAnswer((realInvocation) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.getVisits(any, any)).thenAnswer((_) async => tVisits);
      await visitsRepository.getVisits(tProjectId);
      verify(networkInfo.isConnected());
      verify(userLocalDataSource.getAccessToken());
      verify(remoteDataSource.getVisits(tProjectId, tAccessToken));
      verify(localDataSource.setVisits(tVisits, tProjectId));
    });

    test('should get the visits from preloadedDataSource when there is not connection', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(preloadedDataSource.getPreloadedVisitsIds(any)).thenAnswer((_) async => tVisitsIds);
      when(localDataSource.getVisits(any)).thenAnswer((_) async => tVisits);
      await visitsRepository.getVisits(tProjectId);
      verify(preloadedDataSource.getPreloadedVisitsIds(tProjectId));
      verify(localDataSource.getVisits(tProjectId));
    });

    
    test('should get the Right(tVisits) when there is connection and all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((realInvocation) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.getVisits(any, any)).thenAnswer((realInvocation) async => tVisits);
      final response = await visitsRepository.getVisits(tProjectId);
      expect(response, Right(tVisits));
    });
    
    test('should get the Left(ServiceFailure()) when there is connection and remoteDataSource throws a ServerException', ()async{
      when(networkInfo.isConnected()).thenAnswer((realInvocation) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.getVisits(any, any)).thenThrow(ServerException());
      final response = await visitsRepository.getVisits(tProjectId);
      expect(response, Left(ServerFailure()));
    });

    test('should return Right(tUncompleteVisits) when there is not connection and all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((realInvocation) async => false);
      when(preloadedDataSource.getPreloadedVisitsIds(any)).thenAnswer((_) async => tUncompleteVisitsIds);
      when(localDataSource.getVisits(any)).thenAnswer((_) async => tVisits);
      final response = await visitsRepository.getVisits(tProjectId);
      expect(response.isRight(), true);
      response.fold((l) => null, (r){
        expect(r, tUncompleteVisits);
      });
    });

    test('should return Left(StorageFailure()) when there is connection and preloadedDataSource throws StorageException', ()async{
      when(networkInfo.isConnected()).thenAnswer((realInvocation) async => false);
      when(preloadedDataSource.getPreloadedVisitsIds(any)).thenAnswer((realInvocation) async => tVisitsIds);
      when(localDataSource.getVisits(any)).thenThrow(StorageException(type: StorageExceptionType.NORMAL));
      final response = await visitsRepository.getVisits(tProjectId);
      expect(response, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    });
    
  });

  group('setChosenVisit', (){
    Visit tChosenVisit;

    setUp((){
      tChosenVisit = _getVisitsFromFixture()[0];
    });

    test('should set the chosen visit from localDataSource when there is connection', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      await visitsRepository.setChosenVisit(tChosenVisit);
      verify(localDataSource.setChosenVisit(tChosenVisit));
    });

    test('should set the chosen visit from localDataSource when there is not connection', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      await visitsRepository.setChosenVisit(tChosenVisit);
      verify(localDataSource.setChosenVisit(tChosenVisit));
    });

    test('should return Right(null) when all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      final response = await visitsRepository.setChosenVisit(tChosenVisit);
      expect(response, Right(null));
    });

    test('should return Left(StorageFailure()) when localDataSource throws a StorageException()', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(localDataSource.setChosenVisit(any)).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));
      final response = await visitsRepository.setChosenVisit(tChosenVisit);
      expect(response, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    });
  });

  group('getChosenVisit', (){
    int tProjectId;
    Visit tChosenVisit;

    setUp((){
      tProjectId = 1;
      tChosenVisit = _getVisitsFromFixture()[0];
    });

    test('should get the chosen visit from localDataSource when there is connection', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(localDataSource.getChosenVisit(any)).thenAnswer((realInvocation) async => tChosenVisit);
      await visitsRepository.getChosenVisit(tProjectId);
      verify(localDataSource.getChosenVisit(tProjectId));
    });

    
    test('should get the chosen visit from localDataSource when there is not connection', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(localDataSource.getChosenVisit(any)).thenAnswer((realInvocation) async => tChosenVisit);
      await visitsRepository.getChosenVisit(tProjectId);
      verify(localDataSource.getChosenVisit(tProjectId));
    });

    test('should return Right(tChosenVisit) when all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(localDataSource.getChosenVisit(any)).thenAnswer((realInvocation) async => tChosenVisit);
      final response = await visitsRepository.getChosenVisit(tProjectId);
      expect(response, Right(tChosenVisit));
    });

    test('should return Left(StorageFailure()) when localDataSource throws a StorageException()', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(localDataSource.getChosenVisit(any)).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));
      final response = await visitsRepository.getChosenVisit(tProjectId);
      expect(response, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    });
  });
}

List<Visit> _getVisitsFromFixture(){
  final String stringVisits = callFixture('visits.json');
  final List<Map<String, dynamic>> jsonVisits = jsonDecode(stringVisits).cast<Map<String, dynamic>>();
  final List<Visit> visits = visitsFromStorageJson(jsonVisits);
  return visits;
} 