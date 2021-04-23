import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/visits/visits_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/firmer.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded_data/preloaded_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';

class FormulariosRepositoryImpl implements FormulariosRepository{
  final NetworkInfo networkInfo;
  final FormulariosRemoteDataSource remoteDataSource;
  final FormulariosLocalDataSource localDataSource;
  final PreloadedLocalDataSource preloadedDataSource;
  final UserLocalDataSource userLocalDataSource;
  final VisitsLocalDataSource visitsLocalDataSource;
  final ProjectsLocalDataSource projectsLocalDataSource;

  FormulariosRepositoryImpl({
    @required this.networkInfo, 
    @required this.remoteDataSource, 
    @required this.localDataSource, 
    @required this.preloadedDataSource,
    @required this.userLocalDataSource,
    @required this.visitsLocalDataSource,
    @required this.projectsLocalDataSource  
  });

  @override
  Future<Either<Failure, List<Formulario>>> getFormularios()async{
    if(await networkInfo.isConnected()){
      try{
        final String accessToken = await userLocalDataSource.getAccessToken();
        final List<FormularioModel> formularios = await remoteDataSource.getFormularios(accessToken);
        return Right(formularios);
      }on ServerException{
        return Left(ServerFailure());
      }
    }else{
      try{
        final ProjectModel chosenProject = await projectsLocalDataSource.getChosenProject();
        final VisitModel chosenVisit = await visitsLocalDataSource.getChosenVisit(chosenProject.id);
        final List<FormularioModel> formularios = await preloadedDataSource.getPreloadedFormularios(chosenProject.id, chosenVisit.id);
        return Right(formularios);
      }on StorageException catch(exception){
        return Left(StorageFailure(excType: exception.type));
      }
    }
  }

  @override
  Future<Either<Failure, void>> setInitialPosition(Position position)async{
    final ProjectModel chosenProject = await projectsLocalDataSource.getChosenProject();
    final VisitModel chosenVisit = await visitsLocalDataSource.getChosenVisit(chosenProject.id);
    FormularioModel chosenFormulario = await localDataSource.getChosenFormulario(chosenVisit.id);
    if(await networkInfo.isConnected()){
      try{
        final String accessToken = await userLocalDataSource.getAccessToken();
        await remoteDataSource.setInitialPosition(position, chosenFormulario.id, accessToken);
        return Right(null);
      }on ServerException{
        return Left(ServerFailure());
      }
    }else{
      try{
        chosenFormulario = chosenFormulario.copyWith(initialPosition: position);
        await localDataSource.setChosenFormulario(chosenFormulario);
        await preloadedDataSource.updatePreloadedFormulario(chosenProject.id, chosenVisit.id, chosenFormulario);
        return Right(null);
      }on StorageException catch(exception){
        return Left(StorageFailure(excType: exception.type));
      }
    }
  }

  @override
  Future<Either<Failure, void>> setFormulario(Formulario formulario) {
    // TODO: implement setFormulario
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> setFinalPosition(Position position) {
    // TODO: implement setFinalPosition
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> setFirmer(Firmer firmer) {
    // TODO: implement setFirmer
    throw UnimplementedError();
  }
}