import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/custom_position.dart';
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
      List<FormularioModel> formularios;
      if(await networkInfo.isConnected()){
        final String accessToken = await userLocalDataSource.getAccessToken();
        formularios = await remoteDataSource.getFormularios(chosenVisit.id, accessToken);
        final FormularioModel chosenFormulario = await localDataSource.getChosenFormulario(chosenVisit.id);
        if(chosenFormulario != null)
          formularios = formularios.map((f) => (f.id == chosenFormulario.id)? chosenFormulario : f).toList();
      }else{
        formularios = await preloadedDataSource.getPreloadedFormularios(chosenProject.id, chosenVisit.id);
      }
      await localDataSource.setFormularios(formularios, chosenVisit.id);
      return Right(formularios);
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
        chosenFormulario = chosenFormulario.copyWith(initialPosition: null);
        await localDataSource.setChosenFormulario(chosenFormulario, chosenVisit.id);
      }else{
        chosenFormulario = chosenFormulario.copyWith(initialPosition: position);
        await localDataSource.setChosenFormulario(chosenFormulario, chosenVisit.id);
      }
      await preloadedDataSource.updatePreloadedFormulario(chosenProject.id, chosenVisit.id, chosenFormulario);
      return Right(null);
    });
  }

  @override
  Future<Either<Failure, void>> setCampos(Formulario formulario)async{
    return await _executeGeneralVoidFunction(()async{
      final ProjectModel chosenProject = await projectsLocalDataSource.getChosenProject();
      final VisitModel chosenVisit = await visitsLocalDataSource.getChosenVisit(chosenProject.id);
      if(await networkInfo.isConnected()){
        final String accessToken = await userLocalDataSource.getAccessToken();
        await remoteDataSource.setCampos(formulario, chosenVisit.id, accessToken);
        formulario = (formulario as FormularioModel).copyWith(campos: []);
        await localDataSource.setChosenFormulario(formulario, chosenVisit.id);
      }
      await preloadedDataSource.updatePreloadedFormulario(chosenProject.id, chosenVisit.id, formulario);
      return Right(null);
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
        chosenFormulario = chosenFormulario.copyWith(finalPosition: null);
        await localDataSource.setChosenFormulario(chosenFormulario, chosenVisit.id);
      }else{
        chosenFormulario = chosenFormulario.copyWith(finalPosition: position);
        await localDataSource.setChosenFormulario(chosenFormulario, chosenVisit.id);
      }
      await preloadedDataSource.updatePreloadedFormulario(chosenProject.id, chosenVisit.id, chosenFormulario);
      return Right(null);
    });
  }

  @override
  Future<Either<Failure, void>> setFirmer(Firmer firmer)async{
    return await _executeGeneralVoidFunction(()async{
      final ProjectModel chosenProject = await projectsLocalDataSource.getChosenProject();
      final VisitModel chosenVisit = await visitsLocalDataSource.getChosenVisit(chosenProject.id);
      FormularioModel chosenFormulario = await localDataSource.getChosenFormulario(chosenVisit.id);
      if(await networkInfo.isConnected()){     
        final String accessToken = await userLocalDataSource.getAccessToken();
        await remoteDataSource.setFirmer(firmer, chosenFormulario.id, chosenVisit.id, accessToken);
        chosenFormulario = chosenFormulario.copyWith(
          firmers: chosenFormulario.firmers.where((f) => f.id != firmer.id).toList()
        );
        await localDataSource.setChosenFormulario(chosenFormulario, chosenVisit.id);
      }else{
        chosenFormulario.firmers.add(firmer);
      }
      await preloadedDataSource.updatePreloadedFormulario(chosenProject.id, chosenVisit.id, chosenFormulario);
      return Right(null);
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

  @override
  Future<Either<Failure, void>> setChosenFormulario(Formulario formulario)async{
    return await _executeGeneralVoidFunction(()async{
      final ProjectModel chosenProject = await projectsLocalDataSource.getChosenProject();
      final VisitModel chosenVisit = await visitsLocalDataSource.getChosenVisit(chosenProject.id);
      await localDataSource.setChosenFormulario(formulario, chosenVisit.id);
      return Right(null);
    });
  }

  @override
  Future<Either<Failure, Formulario>> getChosenFormulario()async{
    try{
      final ProjectModel chosenProject = await projectsLocalDataSource.getChosenProject();
      final VisitModel chosenVisit = await visitsLocalDataSource.getChosenVisit(chosenProject.id);
      final FormularioModel chosenFormulario = await localDataSource.getChosenFormulario(chosenVisit.id);
      if( await networkInfo.isConnected() ){
        final String accessToken = await userLocalDataSource.getAccessToken();
         FormularioModel updatedChosenFormulario = await remoteDataSource.getChosenFormulario(chosenFormulario.id, accessToken);
        updatedChosenFormulario.formStepIndex = chosenFormulario.formStepIndex;
        updatedChosenFormulario = updatedChosenFormulario.copyWith(firmers: chosenFormulario.firmers);
        return Right(updatedChosenFormulario);
      }else{
        final List<FormularioModel> preloadedFormularios = await preloadedDataSource.getPreloadedFormularios(chosenProject.id, chosenVisit.id);
        final FormularioModel preloadedChosenFormulario = preloadedFormularios.singleWhere((f) => f.id == chosenFormulario.id);
        return Right(preloadedChosenFormulario);
      }
    }on ServerException catch(exception){
      return Left(ServerFailure(message: exception.message, servExcType: exception.type));
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }
}