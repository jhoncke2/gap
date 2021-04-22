import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/visits_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';
import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded_data/preloaded_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/visits/visits_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/visits/visits_remote_data_source.dart';

class VisitsRepositoryImpl implements VisitsRepository{
  final NetworkInfo networkInfo;
  final VisitsRemoteDataSource remoteDataSource;
  final VisitsLocalDataSource localDataSource;
  final PreloadedLocalDataSource preloadedDataSource;
  final UserLocalDataSource userLocalDataSource;

  VisitsRepositoryImpl({
    @required this.networkInfo,
    @required this.remoteDataSource, 
    @required this.localDataSource, 
    @required this.preloadedDataSource,
    @required this.userLocalDataSource
  });

  

  @override
  Future<Either<Failure, List<Visit>>> getVisits(int projectId)async{
    if(await networkInfo.isConnected()){
      try{
        final String accessToken = await userLocalDataSource.getAccessToken();
        final List<VisitModel> visits = await remoteDataSource.getVisits(projectId, accessToken);
        await localDataSource.setVisits(visits, projectId);
        return Right(visits);
      }on ServerException{
        return Left(ServerFailure());
      }
    }else{
      try{
        final List<int> visitsIds = await preloadedDataSource.getPreloadedVisitsIds(projectId);
        List<VisitModel> visits = await localDataSource.getVisits(projectId);
        visits = visits.where((v) => visitsIds.contains(v.id)).toList();
        return Right(visits);
      }on StorageException catch(exception){
        return Left(StorageFailure(excType: exception.type));
      }
    }
  }

  @override
  Future<Either<Failure, void>> setChosenVisit(Visit visit)async{
    try{
      await localDataSource.setChosenVisit(visit);
      return Right(null);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }
  
  @override
  Future<Either<Failure, Visit>> getChosenVisit(int projectId)async{
    try{
      final VisitModel chosenVisit = await localDataSource.getChosenVisit(projectId);
      return Right(chosenVisit);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }

  
}