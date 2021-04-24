import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/index/index_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/index_model.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/index_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../fixtures/fixture_reader.dart';

class MockIndexLocalDataSource extends Mock implements IndexLocalDataSource{}

IndexRepositoryImpl repository;
MockIndexLocalDataSource localDataSource;

IndexModel tIndex;

void main(){
  setUp((){
    localDataSource = MockIndexLocalDataSource();
    repository = IndexRepositoryImpl(localDataSource: localDataSource);

    tIndex = _getIndexFromFixtures();
  });

  group('setIndex', (){
    test('should set the index in the localDataSource', ()async{
      await repository.setIndex(tIndex);
      verify(localDataSource.setIndex(tIndex));
    });

    test('should return Right(null) when all goes good', ()async{
      final result = await repository.setIndex(tIndex);
      expect(result, Right(null));
    });

    test('should return Left(StorageFailure(...)) when localStorageConnector throws a StorageException(...)', ()async{
      when(localDataSource.setIndex(any)).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));
      final result = await repository.setIndex(tIndex);
      expect(result, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    });
  });

  group('getIndex', (){
    test('should get the index from the localDataSource', ()async{
      when(localDataSource.getIndex()).thenAnswer((_) async => tIndex);
      await repository.getIndex();
      verify(localDataSource.getIndex());
    });

    test('should return Right(tIndex) when all goes good', ()async{
      when(localDataSource.getIndex()).thenAnswer((_) async => tIndex);
      final result = await repository.getIndex();
      expect(result, Right(tIndex));
    });

    test('should return Left(StorageFailure(...)) when localStorageConnector throws a StorageException(...)', ()async{
      when(localDataSource.setIndex(any)).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));
      final result = await repository.setIndex(tIndex);
      expect(result, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    });test('should return Left(StorageFailure(...)) when localStorageConnector throws a StorageException(...)', ()async{
      when(localDataSource.getIndex()).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));
      final result = await repository.getIndex();
      expect(result, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    });
  });
}

IndexModel _getIndexFromFixtures(){
  final String stringIndex = callFixture('index.json');
  final Map<String, dynamic> jsonIndex = jsonDecode(stringIndex);
  final IndexModel index = IndexModel.fromJson(jsonIndex);
  return index;
}