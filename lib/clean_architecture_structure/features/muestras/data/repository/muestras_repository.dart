import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded/preloaded_local_data_source.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestra_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/visits/visits_local_data_source.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestreo_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/data_sources/muestras_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';

class MuestrasRepositoryImpl implements MuestrasRepository{
  final NetworkInfo networkInfo;
  final MuestrasRemoteDataSource remoteDataSource;
  final UserLocalDataSource userLocalDataSource;
  final ProjectsLocalDataSource projectsLocalDataSource;
  final VisitsLocalDataSource visitsLocalDataSource;
  final FormulariosRemoteDataSource formulariosRemoteDataSource;
  final PreloadedLocalDataSource preloadedLocalDataSource;

  MuestrasRepositoryImpl({
    @required this.remoteDataSource,
    @required this.userLocalDataSource,
    @required this.projectsLocalDataSource,
    @required this.visitsLocalDataSource,
    @required this.networkInfo,
    @required this.formulariosRemoteDataSource,
    @required this.preloadedLocalDataSource
  });

  @override
  Future<Either<Failure, Muestreo>> getMuestreo()async{
    try{
      final ProjectModel chosenProject = await projectsLocalDataSource.getChosenProject();
      final VisitModel chosenVisit = await visitsLocalDataSource.getChosenVisit(chosenProject.id);
      MuestreoModel muestreo;
      if( await networkInfo.isConnected() ){
        final String accessToken = await userLocalDataSource.getAccessToken();
        muestreo = await remoteDataSource.getMuestreo(accessToken, chosenVisit.id);
      }else{
        muestreo = await preloadedLocalDataSource.getMuestreo(chosenProject.id, chosenVisit.id);
      }
      return Right(muestreo);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }on ServerException catch(exception){
      return Left(ServerFailure(servExcType: exception.type, message: exception.message));
    }
  }

  @override
  Future<Either<Failure, void>> setFormulario(int muestreoId, Formulario formulario, String tipo)async{
    try{
      if( await networkInfo.isConnected() ){
        final String accessToken = await userLocalDataSource.getAccessToken();
        await remoteDataSource.setFormulario(accessToken, muestreoId, formulario, tipo);
      }else{
        final int chosenProjectId = (await projectsLocalDataSource.getChosenProject()).id;
        final int chosenVisitId = (await visitsLocalDataSource.getChosenVisit(chosenProjectId)).id;
        MuestreoModel muestreo = await preloadedLocalDataSource.getMuestreo(chosenProjectId, chosenVisitId);
        formulario.completo = true;
        if(tipo == 'Pre')
          muestreo = muestreo.copyWith(preFormulario: formulario);
        else
          muestreo = muestreo.copyWith(posFormulario: formulario);
        await preloadedLocalDataSource.updateMuestreo(chosenProjectId, chosenVisitId, muestreo);
      }
      return Right(null);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }on ServerException catch(exception){
      return Left(ServerFailure(servExcType: exception.type));
    }
  }

  @override
  Future<Either<Failure, void>> updatePreparaciones(int muestreoId, List<String> preparaciones)async{
    try{
      if(await networkInfo.isConnected()){
        String accessToken = await userLocalDataSource.getAccessToken();
        await remoteDataSource.updatePreparaciones(accessToken, muestreoId, preparaciones);
      }else{
        final int chosenProjectId = (await projectsLocalDataSource.getChosenProject()).id;
        final int chosenVisitId = (await visitsLocalDataSource.getChosenVisit(chosenProjectId)).id;
        final MuestreoModel muestreo = await preloadedLocalDataSource.getMuestreo(chosenProjectId, chosenVisitId);
        for(int i = 0; i < muestreo.componentes.length; i++)
          muestreo.componentes[i].preparacion = preparaciones[i];
        await preloadedLocalDataSource.updateMuestreo(chosenProjectId, chosenVisitId, muestreo);
      }
      return Right(null);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }on ServerException catch(exception){
      return Left(ServerFailure(servExcType: exception.type, message: exception.message));
    }
  }

  @override
  Future<Either<Failure, void>> setMuestra(int muestreoId, int selectedRangoId, List<double> pesosTomados)async{
    try{
      if( await networkInfo.isConnected() ){
        final String accessToken = await userLocalDataSource.getAccessToken();
        await remoteDataSource.setMuestra(accessToken, muestreoId, selectedRangoId, pesosTomados);
      }else{
        final int chosenProjectId = (await projectsLocalDataSource.getChosenProject()).id;
        final int chosenVisitId = (await visitsLocalDataSource.getChosenVisit(chosenProjectId)).id;
        final MuestreoModel muestreo = await preloadedLocalDataSource.getMuestreo(chosenProjectId, chosenVisitId);
        muestreo.muestrasTomadas.add(MuestraModel(
          id: null, 
          rango: muestreo.rangos.singleWhere((r) => r.id == selectedRangoId).nombre, 
          pesos: pesosTomados
        ));
        await preloadedLocalDataSource.updateMuestreo(chosenProjectId, chosenVisitId, muestreo);
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
      }else{
        final int chosenProjectId = (await projectsLocalDataSource.getChosenProject()).id;
        final int chosenVisitId = (await visitsLocalDataSource.getChosenVisit(chosenProjectId)).id;
        final MuestreoModel muestreo = await preloadedLocalDataSource.getMuestreo(chosenProjectId, chosenVisitId);
        muestreo.muestrasTomadas.removeWhere((m) => m.id == muestraId);
        await preloadedLocalDataSource.updateMuestreo(chosenProjectId, chosenVisitId, muestreo);
      }
      return Right(null);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }on ServerException catch(exception){
      return Left(ServerFailure(servExcType: exception.type, message: exception.message));
    }
  }

  @override
  Future<Either<Failure, void>> endMuestreo()async{
    try{
      if( await networkInfo.isConnected() ){
        int chosenProjectId = (await projectsLocalDataSource.getChosenProject()).id;
        int chosenVisitId = (await visitsLocalDataSource.getChosenVisit(chosenProjectId)).id;
        await preloadedLocalDataSource.removeMuestreo(chosenProjectId, chosenVisitId);
      }
      return Right(null);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }
}