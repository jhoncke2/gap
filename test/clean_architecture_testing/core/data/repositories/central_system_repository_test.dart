import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/central_system/central_system_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/central_system_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/central_system_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockCentralSystemLocalDataSource extends Mock implements CentralSystemLocalDataSource{}

CentralSystemRepositoryImpl repository;
MockCentralSystemLocalDataSource localDataSource;

void main(){
  setUp((){
    localDataSource = MockCentralSystemLocalDataSource();
    repository = CentralSystemRepositoryImpl(
      localDataSource: localDataSource
    );
  });

  group('removeAll', (){
    
    test('should call the specified methods', ()async{
      await repository.removeAll();
      verify(localDataSource.removeAll());
    });

    test('should call the specified methods', ()async{
      final result = await repository.removeAll();
      expect(result, Right(null) );
    });

    test('should call the specified methods', ()async{
      when(localDataSource.removeAll()).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));
      final result = await repository.removeAll();
      expect(result, Left( StorageFailure(excType: StorageExceptionType.PLATFORM)) );
    });
  });

  group('getAppRunnedAnyTime', (){
    
    test('should call the specified methods', ()async{
      when(localDataSource.getAppRunnedAnyTime()).thenAnswer((_) async => true);
      await repository.getAppRunnedAnyTime();
      verify(localDataSource.getAppRunnedAnyTime());
    });

    test('should return Right(true) when all goes good', ()async{
      when(localDataSource.getAppRunnedAnyTime()).thenAnswer((_) async => true);
      final result = await repository.getAppRunnedAnyTime();
      expect(result, Right(true) );
    });

    test('should Left(Failure(X)) when there is any problem', ()async{
      when(localDataSource.getAppRunnedAnyTime()).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));
      final result = await repository.getAppRunnedAnyTime();
      expect(result, Left( StorageFailure(excType: StorageExceptionType.PLATFORM)) );
    });
  });

  group('setAppRunnedAnyTime', (){
    
    test('should call the specified methods', ()async{
      await repository.setAppRunnedAnyTime();
      verify(localDataSource.removeAll());
      verify(localDataSource.setAppRunnedAnyTime());
    });

    test('should return Right(true) when all goes good', ()async{
      final result = await repository.setAppRunnedAnyTime();
      expect(result, Right(null) );
    });

    test('should Left(Failure(X)) when there is any problem', ()async{
      when(localDataSource.setAppRunnedAnyTime()).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));
      final result = await repository.setAppRunnedAnyTime();
      expect(result, Left( StorageFailure(excType: StorageExceptionType.PLATFORM)) );
    });
  });
}