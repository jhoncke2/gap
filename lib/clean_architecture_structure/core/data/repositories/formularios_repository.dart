import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/custom_position.dart';
import 'package:meta/meta.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/visits/visits_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/firmer.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded/preloaded_local_data_source.dart';
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
    try{
      final ProjectModel chosenProject = await projectsLocalDataSource.getChosenProject();
      final VisitModel chosenVisit = await visitsLocalDataSource.getChosenVisit(chosenProject.id);
      if(await networkInfo.isConnected()){
        final String accessToken = await userLocalDataSource.getAccessToken();
        final List<FormularioModel> formularios = await remoteDataSource.getFormularios(chosenVisit.id, accessToken);
        return Right(formularios);
      }else{
        final List<FormularioModel> formularios = await preloadedDataSource.getPreloadedFormularios(chosenProject.id, chosenVisit.id);
        return Right(formularios);
      }
    }on ServerException{
      return Left(ServerFailure());
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }

  @override
  Future<Either<Failure, void>> setInitialPosition(CustomPosition position)async{
    return await _executeGeneralVoidFunction(()async{
      final ProjectModel chosenProject = await projectsLocalDataSource.getChosenProject();
      final VisitModel chosenVisit = await visitsLocalDataSource.getChosenVisit(chosenProject.id);
      FormularioModel chosenFormulario = await localDataSource.getChosenFormulario(chosenVisit.id);
      if(await networkInfo.isConnected()){
        final String accessToken = await userLocalDataSource.getAccessToken();
        await remoteDataSource.setInitialPosition((position ), chosenFormulario.id, accessToken);
        return Right(null);
      }else{
        chosenFormulario = chosenFormulario.copyWith(initialPosition: position);
        await localDataSource.setChosenFormulario(chosenFormulario);
        await preloadedDataSource.updatePreloadedFormulario(chosenProject.id, chosenVisit.id, chosenFormulario);
        return Right(null);
      }
    });
  }

  @override
  Future<Either<Failure, void>> setFormulario(Formulario formulario)async{
    return await _executeGeneralVoidFunction(()async{
      final ProjectModel chosenProject = await projectsLocalDataSource.getChosenProject();
      final VisitModel chosenVisit = await visitsLocalDataSource.getChosenVisit(chosenProject.id);
      if(await networkInfo.isConnected()){
        final String accessToken = await userLocalDataSource.getAccessToken();
        await remoteDataSource.setFormulario(formulario, chosenVisit.id, accessToken);
        return Right(null);
      }else{
        await preloadedDataSource.updatePreloadedFormulario(chosenProject.id, chosenVisit.id, formulario);
        return Right(null);
      }
    });
  }

  @override
  Future<Either<Failure, void>> setFinalPosition(CustomPosition position)async{
    return await _executeGeneralVoidFunction(()async{
      final ProjectModel chosenProject = await projectsLocalDataSource.getChosenProject();
      final VisitModel chosenVisit = await visitsLocalDataSource.getChosenVisit(chosenProject.id);
      FormularioModel chosenFormulario = await localDataSource.getChosenFormulario(chosenVisit.id);
      if(await networkInfo.isConnected()){
        final String accessToken = await userLocalDataSource.getAccessToken();
        await remoteDataSource.setFinalPosition(position, chosenFormulario.id, accessToken);
        return Right(null);
      }else{
        chosenFormulario = chosenFormulario.copyWith(finalPosition: position);
        await localDataSource.setChosenFormulario(chosenFormulario);
        await preloadedDataSource.updatePreloadedFormulario(chosenProject.id, chosenVisit.id, chosenFormulario);
        return Right(null);
      }
    });
  }

  @override
  Future<Either<Failure, void>> setFirmer(Firmer firmer)async{
    return await _executeGeneralVoidFunction(()async{
      final ProjectModel chosenProject = await projectsLocalDataSource.getChosenProject();
      final VisitModel chosenVisit = await visitsLocalDataSource.getChosenVisit(chosenProject.id);
      final FormularioModel chosenFormulario = await localDataSource.getChosenFormulario(chosenVisit.id);
      if(await networkInfo.isConnected()){     
        final String accessToken = await userLocalDataSource.getAccessToken();
        await remoteDataSource.setFirmer(firmer, chosenFormulario.id, accessToken);
        return Right(null);
      }else{
        chosenFormulario.firmers.add(firmer);
        await preloadedDataSource.updatePreloadedFormulario(chosenProject.id, chosenVisit.id, chosenFormulario);
        return Right(null);
      }
    });
  }

  Future<Either<Failure, void>> _executeGeneralVoidFunction(
    Future<void> Function() function 
  )async{
    try{
      await function();
      return Right(null);
    }on ServerException{
      return Left(ServerFailure());
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }
}