import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/visits_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded/preloaded_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/visits/visits_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/visits/visits_remote_data_source.dart';

class VisitsRepositoryImpl implements VisitsRepository{
  final NetworkInfo networkInfo;
  final VisitsRemoteDataSource remoteDataSource;
  final VisitsLocalDataSource localDataSource;
  final PreloadedLocalDataSource preloadedDataSource;
  final UserLocalDataSource userLocalDataSource;
  final ProjectsLocalDataSource projectsLocalDataSource;
  final FormulariosRemoteDataSource formulariosRemoteDataSource;

  VisitsRepositoryImpl({
    @required this.networkInfo,
    @required this.remoteDataSource, 
    @required this.localDataSource, 
    @required this.preloadedDataSource,
    @required this.userLocalDataSource,
    @required this.projectsLocalDataSource,
    @required this.formulariosRemoteDataSource
  });

  @override
  Future<Either<Failure, List<Visit>>> getVisits()async{
    final ProjectModel chosenProject = await projectsLocalDataSource.getChosenProject();
    if(await networkInfo.isConnected()){
      try{
        final String accessToken = await userLocalDataSource.getAccessToken();
        final List<VisitModel> visits = await remoteDataSource.getVisits(chosenProject.id, accessToken);
        await localDataSource.setVisits(visits, chosenProject.id);
        return Right(visits);
      }on ServerException{
        return Left(ServerFailure());
      }
    }else{
      try{
        final List<int> visitsIds = await preloadedDataSource.getPreloadedVisitsIds(chosenProject.id);
        List<VisitModel> visits = await localDataSource.getVisits(chosenProject.id);
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
      if(await networkInfo.isConnected()){
        final ProjectModel chosenProject = await projectsLocalDataSource.getChosenProject();
        final String accessToken = await userLocalDataSource.getAccessToken();
        final List<FormularioModel> visitFormularios = await formulariosRemoteDataSource.getFormularios(visit.id, accessToken);
        await preloadedDataSource.setPreloadedFamily(chosenProject.id, visit.id, visitFormularios);
      }
      return Right(null);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }
  
  @override
  Future<Either<Failure, Visit>> getChosenVisit()async{
    try{
      final ProjectModel chosenProject = await projectsLocalDataSource.getChosenProject();
      final VisitModel chosenVisit = await localDataSource.getChosenVisit(chosenProject.id);
      return Right(chosenVisit);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }
}