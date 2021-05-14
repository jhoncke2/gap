import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/central_system/central_system_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/central_system_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

class CentralSystemRepositoryImpl implements CentralSystemRepository{
  final CentralSystemLocalDataSource localDataSource;

  CentralSystemRepositoryImpl({
    @required this.localDataSource
  });

  @override
  Future<Either<Failure, void>> removeAll()async{
    try{
      await localDataSource.removeAll();
    return Right(null);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }

  @override
  Future<Either<Failure, bool>> getAppRunnedAnyTime()async{
    try{
      return Right( await localDataSource.getAppRunnedAnyTime() );
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }

  @override
  Future<Either<Failure, void>> setAppRunnedAnyTime()async{
    try{
      await localDataSource.removeAll();
      await localDataSource.setAppRunnedAnyTime();
      return Right(null);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }

}