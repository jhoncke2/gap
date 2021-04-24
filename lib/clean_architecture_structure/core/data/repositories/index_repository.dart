import 'package:gap/clean_architecture_structure/core/data/models/index_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/index.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/index_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/index/index_local_data_source.dart';

class IndexRepositoryImpl implements IndexRepository{
  final IndexLocalDataSource localDataSource;

  IndexRepositoryImpl({
    @required this.localDataSource
  });

  @override
  Future<Either<Failure, void>> setIndex(Index index)async{
    try{
      await localDataSource.setIndex(index);
      return Right(null);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }

  @override
  Future<Either<Failure, Index>> getIndex()async{
    try{
      final IndexModel index = await localDataSource.getIndex();
      return Right(index);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }
}