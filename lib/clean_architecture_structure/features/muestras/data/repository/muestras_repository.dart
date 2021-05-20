import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/visits/visits_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestreo_model.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/data_sources/muestras_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';

class MuestrasRepositoryImpl implements MuestrasRepository{
  final NetworkInfo networkInfo;
  final MuestrasRemoteDataSource remoteDataSource;
  final UserLocalDataSource userLocalDataSource;
  final ProjectsLocalDataSource projectsLocalDataSource;
  final VisitsLocalDataSource visitsLocalDataSource;

  MuestrasRepositoryImpl({
    @required this.remoteDataSource,
    @required this.userLocalDataSource,
    @required this.projectsLocalDataSource,
    @required this.visitsLocalDataSource,
    @required this.networkInfo 
  });

  @override
  Future<Either<Failure, Muestreo>> getMuestreo()async{
    if( await networkInfo.isConnected() ){
      try{
        final ProjectModel chosenProject = await projectsLocalDataSource.getChosenProject();
        final VisitModel chosenVisit = await visitsLocalDataSource.getChosenVisit(chosenProject.id);
        final String accessToken = await userLocalDataSource.getAccessToken();
        final MuestreoModel muestreo = await remoteDataSource.getMuestreo(accessToken, chosenVisit.id);
        return Right(muestreo);
      }on StorageException catch(exception){
        return Left(StorageFailure(excType: exception.type));
      }on ServerException catch(exception){
        return Left(ServerFailure(servExcType: exception.type, message: exception.message));
      }
    }
    return Right(null);
  }

  @override
  Future<Either<Failure, void>> setMuestra(int muestreoId, int selectedRangoId, List<double> pesosTomados)async{
    try{
      if( await networkInfo.isConnected() ){
        final String accessToken = await userLocalDataSource.getAccessToken();
        await remoteDataSource.setMuestra(accessToken, muestreoId, selectedRangoId, pesosTomados);
      }
      return Right(null);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }on ServerException catch(exception){
      return Left(ServerFailure(servExcType: exception.type, message: exception.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeMuestra(int muestraId)async{
    try{
      if( await networkInfo.isConnected() ){
        String accessToken = await userLocalDataSource.getAccessToken();
        await remoteDataSource.removeMuestra(accessToken, muestraId);
      }
      return Right(null);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }on ServerException catch(exception){
      return Left(ServerFailure(servExcType: exception.type, message: exception.message));
    }
  }

  @override
  Future<Either<Failure, void>> updatePreparaciones(int muestreoId, List<String> preparaciones)async{
    try{
      if(await networkInfo.isConnected()){
        String accessToken = await userLocalDataSource.getAccessToken();
        await remoteDataSource.updatePreparaciones(accessToken, muestreoId, preparaciones);
      }
      return Right(null);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }on ServerException catch(exception){
      return Left(ServerFailure(servExcType: exception.type, message: exception.message));
    }
  }
}